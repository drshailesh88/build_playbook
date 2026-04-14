import { promises as fs } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { randomBytes } from "node:crypto";
import yaml from "js-yaml";
import { afterEach, beforeEach, describe, expect, test } from "vitest";
import { runInstaller } from "./install.js";

let targetDir: string;
let scaffoldRoot: string;

beforeEach(async () => {
  const base = join(tmpdir(), `install-${randomBytes(6).toString("hex")}`);
  targetDir = join(base, "target");
  scaffoldRoot = join(base, "scaffold");
  await fs.mkdir(targetDir, { recursive: true });
  await fs.mkdir(scaffoldRoot, { recursive: true });
  await fs.mkdir(join(scaffoldRoot, "controller"), { recursive: true });
  await fs.mkdir(join(scaffoldRoot, "registry", "services"), { recursive: true });
  await fs.mkdir(join(scaffoldRoot, "snippets", "global-setup"), { recursive: true });
  await fs.mkdir(join(scaffoldRoot, "templates", ".claude", "hooks"), {
    recursive: true,
  });
  await fs.mkdir(join(scaffoldRoot, "templates", ".husky"), { recursive: true });
});

afterEach(async () => {
  try {
    await fs.rm(join(targetDir, ".."), { recursive: true, force: true });
  } catch {
    /* noop */
  }
});

async function seedMinimalScaffold(): Promise<void> {
  // Minimal controller tree
  await fs.writeFile(
    join(scaffoldRoot, "controller", "README.md"),
    "QA controller",
  );
  await fs.writeFile(
    join(scaffoldRoot, "controller", "types.ts"),
    "export {};",
  );
  // A tiny Clerk manifest
  await fs.writeFile(
    join(scaffoldRoot, "registry", "services", "clerk.yaml"),
    yaml.dump({
      name: "clerk",
      display_name: "Clerk",
      category_hint: "auth",
      status: "validated",
      detection: { package_patterns: ["@clerk/nextjs"], env_patterns: ["CLERK_*"] },
      env_test_vars: {
        required: [
          { name: "CLERK_SECRET_KEY", description: "test key" },
          { name: "E2E_CLERK_USER_USERNAME" },
        ],
        optional: [{ name: "CLERK_TESTING_TOKEN" }],
      },
      snippets: {
        global_setup: "snippets/global-setup/clerk.ts",
        auto_install_dev_packages: ["@clerk/testing"],
      },
      tier_hints: { critical_75: ["src/**/auth/**", "middleware.ts"] },
    }),
  );
  await fs.writeFile(
    join(scaffoldRoot, "snippets", "global-setup", "clerk.ts"),
    "// clerk setup",
  );

  // Enforcement templates
  await fs.writeFile(
    join(scaffoldRoot, "templates", ".claude", "settings.json"),
    JSON.stringify({ permissions: { deny: [] } }),
  );
  await fs.writeFile(
    join(scaffoldRoot, "templates", ".claude", "hooks", "block-locked-paths.sh"),
    "#!/bin/bash\nexit 0\n",
  );
  await fs.writeFile(
    join(scaffoldRoot, "templates", ".husky", "pre-commit"),
    "#!/bin/bash\nexit 0\n",
  );
}

async function seedTargetPackage(deps: Record<string, string>): Promise<void> {
  await fs.writeFile(
    join(targetDir, "package.json"),
    JSON.stringify({ name: "target", dependencies: deps }),
  );
}

describe("runInstaller — happy path", () => {
  test("copies controller, scaffolds .quality/, detects Clerk", async () => {
    await seedMinimalScaffold();
    await seedTargetPackage({ "@clerk/nextjs": "^5" });
    await fs.writeFile(
      join(targetDir, ".env.example"),
      "CLERK_SECRET_KEY=\n",
    );

    const result = await runInstaller({
      targetDir,
      scaffoldRoot,
      skipNpmInstall: true,
      runCommand: async () => ({ exitCode: 0, stdout: "", stderr: "" }),
    });

    expect(result.detection.detected).toHaveLength(1);
    expect(result.detection.detected[0]?.name).toBe("clerk");

    // Controller files copied
    const qaExists = await fs.access(join(targetDir, "qa", "types.ts")).then(() => true).catch(() => false);
    expect(qaExists).toBe(true);

    // .quality/ scaffolded
    const contractsDir = await fs.stat(join(targetDir, ".quality", "contracts"));
    expect(contractsDir.isDirectory()).toBe(true);

    // .env.test.example has the Clerk keys
    const envTest = await fs.readFile(join(targetDir, ".env.test.example"), "utf8");
    expect(envTest).toContain("CLERK_SECRET_KEY");
    expect(envTest).toContain("E2E_CLERK_USER_USERNAME");
    expect(envTest).toContain("CLERK_TESTING_TOKEN"); // optional is listed too

    // tiers.yaml merged with Clerk's critical paths
    const tiers = yaml.load(
      await fs.readFile(join(targetDir, ".quality", "policies", "tiers.yaml"), "utf8"),
    ) as any;
    expect(tiers.tiers.critical_75).toContain("src/**/auth/**");
    expect(tiers.unclassified_behavior).toBe("fail_fast");

    // providers.yaml + thresholds.yaml + lock-manifest.json written
    const providers = yaml.load(
      await fs.readFile(join(targetDir, ".quality", "policies", "providers.yaml"), "utf8"),
    ) as any;
    expect(providers.active_fixer).toBe("claude");
    expect(providers.enabled).toContain("claude");

    const thresholds = yaml.load(
      await fs.readFile(join(targetDir, ".quality", "policies", "thresholds.yaml"), "utf8"),
    ) as any;
    expect(thresholds.max_attempts).toBe(10);
    expect(thresholds.plateau_window).toBe(3);

    const lock = JSON.parse(
      await fs.readFile(join(targetDir, ".quality", "policies", "lock-manifest.json"), "utf8"),
    );
    expect(lock.schema_version).toBe(1);
    expect(lock.files).toBeDefined();

    // Enforcement templates installed
    const settingsExists = await fs
      .access(join(targetDir, ".claude", "settings.json"))
      .then(() => true)
      .catch(() => false);
    expect(settingsExists).toBe(true);

    const hookStat = await fs.stat(join(targetDir, ".claude", "hooks", "block-locked-paths.sh"));
    // Should be executable
    expect((hookStat.mode & 0o111) !== 0).toBe(true);

    const huskyStat = await fs.stat(join(targetDir, ".husky", "pre-commit"));
    expect((huskyStat.mode & 0o111) !== 0).toBe(true);

    // install-report.md contains detected services + next steps
    const report = await fs.readFile(join(targetDir, ".quality", "install-report.md"), "utf8");
    expect(report).toContain("clerk");
    expect(report).toContain("Next Steps");
    expect(report).toContain("contract-pack");

    // detected-services.yaml has provenance
    const detected = await fs.readFile(
      join(targetDir, ".quality", "policies", "detected-services.yaml"),
      "utf8",
    );
    expect(detected).toContain("installed_from_registry:");
  });
});

describe("runInstaller — upgrade mode", () => {
  test("preserves existing user edits", async () => {
    await seedMinimalScaffold();
    await seedTargetPackage({ "@clerk/nextjs": "^5" });

    // First install
    await runInstaller({
      targetDir,
      scaffoldRoot,
      skipNpmInstall: true,
      runCommand: async () => ({ exitCode: 0, stdout: "", stderr: "" }),
    });

    // User edits providers.yaml
    const providersPath = join(targetDir, ".quality", "policies", "providers.yaml");
    await fs.writeFile(
      providersPath,
      yaml.dump({
        schema_version: 1,
        active_fixer: "claude",
        enabled: ["claude", "codex"],
        disabled: ["gemini"],
        max_turns: 45,
      }),
    );

    // Re-run with --upgrade
    await runInstaller({
      targetDir,
      scaffoldRoot,
      upgrade: true,
      skipNpmInstall: true,
      runCommand: async () => ({ exitCode: 0, stdout: "", stderr: "" }),
    });

    const providers = yaml.load(await fs.readFile(providersPath, "utf8")) as any;
    expect(providers.enabled).toContain("codex");
    expect(providers.max_turns).toBe(45);
  });
});

describe("runInstaller — detection modes", () => {
  test("strict mode aborts when unknown services present", async () => {
    await seedMinimalScaffold();
    await seedTargetPackage({ "@weird/unknown-lib": "^1" });

    const result = await runInstaller({
      targetDir,
      scaffoldRoot,
      mode: "strict",
      skipNpmInstall: true,
      runCommand: async () => ({ exitCode: 0, stdout: "", stderr: "" }),
    });
    expect(result.aborted).toBeDefined();
    expect(result.aborted).toContain("strict");
  });

  test("stubs mode generates .yaml.stub files", async () => {
    await seedMinimalScaffold();
    await seedTargetPackage({ "@my/unknown-lib": "^1" });

    const result = await runInstaller({
      targetDir,
      scaffoldRoot,
      mode: "stubs",
      skipNpmInstall: true,
      runCommand: async () => ({ exitCode: 0, stdout: "", stderr: "" }),
    });
    expect(result.stubManifests.length).toBeGreaterThan(0);
    const body = await fs.readFile(result.stubManifests[0]!, "utf8");
    expect(body).toContain("status: stub");
  });
});

describe("runInstaller — dryRun", () => {
  test("writes nothing in dry-run mode", async () => {
    await seedMinimalScaffold();
    await seedTargetPackage({ "@clerk/nextjs": "^5" });

    const result = await runInstaller({
      targetDir,
      scaffoldRoot,
      dryRun: true,
      skipNpmInstall: true,
      runCommand: async () => ({ exitCode: 0, stdout: "", stderr: "" }),
    });
    expect(result.detection.detected).toHaveLength(1);

    // Nothing should be on disk.
    const qaExists = await fs.access(join(targetDir, "qa")).then(() => true).catch(() => false);
    expect(qaExists).toBe(false);
    const qualityExists = await fs
      .access(join(targetDir, ".quality", "policies"))
      .then(() => true)
      .catch(() => false);
    expect(qualityExists).toBe(false);
  });
});

describe("runInstaller — npm install delegation", () => {
  test("queues dev packages for injected runner", async () => {
    await seedMinimalScaffold();
    await seedTargetPackage({ "@clerk/nextjs": "^5" });

    let capturedArgs: string[] | undefined;
    await runInstaller({
      targetDir,
      scaffoldRoot,
      runCommand: async (_cmd, args) => {
        capturedArgs = args;
        return { exitCode: 0, stdout: "", stderr: "" };
      },
    });
    expect(capturedArgs).toEqual(["install", "-D", "@clerk/testing"]);
  });

  test("non-zero exit → packages listed as skipped", async () => {
    await seedMinimalScaffold();
    await seedTargetPackage({ "@clerk/nextjs": "^5" });

    const result = await runInstaller({
      targetDir,
      scaffoldRoot,
      runCommand: async () => ({ exitCode: 1, stdout: "", stderr: "boom" }),
    });
    expect(result.devPackagesInstalled).toEqual([]);
    expect(result.devPackagesSkipped).toContain("@clerk/testing");
  });
});

describe("runInstaller — no services detected", () => {
  test("still scaffolds .quality/ + policies + templates", async () => {
    await seedMinimalScaffold();
    await seedTargetPackage({ react: "^19" });

    const result = await runInstaller({
      targetDir,
      scaffoldRoot,
      skipNpmInstall: true,
      runCommand: async () => ({ exitCode: 0, stdout: "", stderr: "" }),
    });
    expect(result.detection.detected).toEqual([]);

    const qaExists = await fs.access(join(targetDir, "qa")).then(() => true).catch(() => false);
    expect(qaExists).toBe(true);
    const providersExists = await fs
      .access(join(targetDir, ".quality", "policies", "providers.yaml"))
      .then(() => true)
      .catch(() => false);
    expect(providersExists).toBe(true);
  });
});
