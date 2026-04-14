/**
 * End-to-end pipeline integration test.
 *
 * Runs the FULL real pipeline against a minimal Next.js-shaped fixture in a
 * temp workspace:
 *
 *   A. runInstaller() scaffolds .quality/ structure, writes providers.yaml,
 *      thresholds.yaml, and install-report.md.
 *   B. A manually authored tiers.yaml covers every source file
 *      (runClassifyCheck returns ok).
 *   C. A contract is initialized + frozen for the math module using
 *      initializeContract + freezeContract.
 *   D. runBaseline() actually invokes `npx stryker run` + vitest via real
 *      subprocesses; mutation.json is written to disk; state.json is updated
 *      with a realistic mutation_baseline for src/lib/math.ts; parseStrykerReport
 *      reads the on-disk file and returns non-empty perFile data.
 *
 * This test is SLOW (~3-5 min dominated by npm install + stryker). Gated
 * behind `npm run test:integration` — excluded from the default `npm test`.
 *
 * Read the README for rationale: this catches fixture-vs-reality drift
 * BEFORE we install into a real production app.
 */
import { afterAll, beforeAll, describe, expect, test } from "vitest";
import { promises as fs } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { randomBytes } from "node:crypto";
import { execa } from "execa";
import yaml from "js-yaml";

import { runInstaller } from "../../installer/install.js";
import { runBaseline } from "../../controller.js";
import { initializeContract, freezeContract } from "../../contract-utils.js";
import { readState } from "../../state-manager.js";
import { parseStrykerReport } from "../../parsers/stryker-json.js";
import { runClassifyCheck } from "../../classify-checker.js";

const HERE = dirname(fileURLToPath(import.meta.url));
const FIXTURE_SOURCE = resolve(HERE, "..", "..", "__fixtures__", "sample-nextjs-app");
const SCAFFOLD_ROOT = resolve(HERE, "..", "..", "..");

let workspace: string;

const EXCLUDE_ON_COPY = new Set([
  "node_modules",
  "dist",
  ".stryker-tmp",
  "reports",
  ".quality",
]);

async function copyDir(src: string, dst: string): Promise<void> {
  await fs.mkdir(dst, { recursive: true });
  const entries = await fs.readdir(src, { withFileTypes: true });
  for (const entry of entries) {
    if (EXCLUDE_ON_COPY.has(entry.name)) continue;
    const s = join(src, entry.name);
    const d = join(dst, entry.name);
    if (entry.isDirectory()) {
      await copyDir(s, d);
    } else if (entry.isFile()) {
      await fs.copyFile(s, d);
    }
  }
}

beforeAll(async () => {
  workspace = join(
    tmpdir(),
    `qa-integration-${randomBytes(6).toString("hex")}`,
  );
  await copyDir(FIXTURE_SOURCE, workspace);

  const install = await execa(
    "npm",
    ["install", "--no-audit", "--no-fund", "--loglevel=error"],
    { cwd: workspace, reject: false },
  );
  if (install.exitCode !== 0) {
    const stderr = typeof install.stderr === "string" ? install.stderr : "";
    throw new Error(
      `npm install in fixture workspace failed (exit ${install.exitCode}):\n${stderr.slice(0, 2000)}`,
    );
  }
}, 300_000);

afterAll(async () => {
  if (workspace && process.env.KEEP_INTEGRATION_WORKSPACE !== "1") {
    await fs.rm(workspace, { recursive: true, force: true }).catch(() => {});
  }
});

describe("full QA pipeline against sample-nextjs-app fixture", () => {
  test("A. runInstaller scaffolds .quality/ and writes policy files", async () => {
    const result = await runInstaller({
      targetDir: workspace,
      scaffoldRoot: SCAFFOLD_ROOT,
      mode: "default",
      skipNpmInstall: true,
    });

    expect(result.aborted).toBeUndefined();

    const qualityDir = join(workspace, ".quality");
    expect((await fs.stat(join(qualityDir, "contracts"))).isDirectory()).toBe(true);
    expect((await fs.stat(join(qualityDir, "policies"))).isDirectory()).toBe(true);
    expect((await fs.stat(join(qualityDir, "runs"))).isDirectory()).toBe(true);

    const providers = await fs.readFile(result.providersYamlPath, "utf8");
    expect(providers).toContain("active_fixer: claude");

    const thresholds = await fs.readFile(result.thresholdsYamlPath, "utf8");
    expect(thresholds).toContain("max_attempts");

    const installReport = await fs.readFile(result.installReportPath, "utf8");
    expect(installReport.length).toBeGreaterThan(100);
    expect(installReport).toContain("# QA Harness");

    const lockManifestRaw = await fs.readFile(result.lockManifestPath, "utf8");
    const lockManifest = JSON.parse(lockManifestRaw);
    expect(lockManifest.schema_version).toBe(1);
    expect(typeof lockManifest.files).toBe("object");

    const copiedFile = join(workspace, "qa", "state-manager.js");
    const copiedMissing = await fs.access(copiedFile).then(() => true).catch(() => false);
    expect(copiedMissing).toBe(false);

    const installerLeaked = await fs
      .stat(join(workspace, "qa", "installer"))
      .then(() => true)
      .catch(() => false);
    expect(installerLeaked).toBe(false);

    const testsLeaked = await fs
      .stat(join(workspace, "qa", "__tests__"))
      .then(() => true)
      .catch(() => false);
    expect(testsLeaked).toBe(false);

    const fixturesLeaked = await fs
      .stat(join(workspace, "qa", "__fixtures__"))
      .then(() => true)
      .catch(() => false);
    expect(fixturesLeaked).toBe(false);
  });

  test("B. tiers.yaml covers every source file — runClassifyCheck returns ok", async () => {
    const tiersPath = join(workspace, ".quality", "policies", "tiers.yaml");
    const tiers = {
      schema_version: 1,
      tiers: {
        critical_75: ["src/lib/math.ts"],
        business_60: ["src/lib/validator.ts"],
        ui_gates_only: ["app/**"],
      },
      unclassified_behavior: "fail_fast",
    };
    await fs.writeFile(tiersPath, yaml.dump(tiers));

    const check = await runClassifyCheck({ workingDir: workspace });
    if (!check.ok) {
      throw new Error(
        `classify-check failed unexpectedly. unclassified: ${JSON.stringify(check.unclassified)}; scanned: ${check.scanned}`,
      );
    }
    expect(check.ok).toBe(true);
    expect(check.unclassified).toEqual([]);
    expect(check.scanned).toBeGreaterThanOrEqual(3);
  });

  test("C. contract initialized + frozen for math module", async () => {
    const contractDir = join(workspace, ".quality", "contracts", "math-ops");
    await fs.mkdir(contractDir, { recursive: true });

    await fs.writeFile(
      join(contractDir, "examples.md"),
      [
        "# Examples — math-ops",
        "",
        "## Example 1: add positives",
        "add(2, 3) must equal 5.",
        "",
        "## Example 2: multiply positives",
        "multiply(4, 5) must equal 20.",
        "",
      ].join("\n"),
    );
    await fs.writeFile(
      join(contractDir, "counterexamples.md"),
      [
        "# Counterexamples — math-ops",
        "",
        "## Counterexample 1: divide by zero",
        "divide(10, 0) must throw; it must not return Infinity, NaN, or 0.",
        "",
      ].join("\n"),
    );
    await fs.writeFile(
      join(contractDir, "invariants.md"),
      [
        "# Invariants — math-ops",
        "",
        "1. add is commutative — ALWAYS true",
        "2. multiply by 0 is always 0 — ALWAYS true",
        "",
      ].join("\n"),
    );
    await fs.writeFile(
      join(contractDir, "acceptance.spec.ts"),
      'test("stub acceptance", () => { expect(1).toBe(1); });\n',
    );
    await fs.writeFile(join(contractDir, "regressions.spec.ts"), "// none yet\n");

    const initial = await initializeContract({
      contractDir,
      featureId: "math-ops",
      title: "Math operations",
      tier: "critical_75",
      category: "business_logic",
      approvedBy: "integration-test",
      affectedModules: ["src/lib/math.ts"],
    });
    expect(initial.feature.status).toBe("pending_approval");
    expect(initial.feature.security_sensitive).toBe(true);
    expect(initial.counts.examples).toBe(2);
    expect(initial.counts.counterexamples).toBe(1);
    expect(initial.counts.invariants).toBe(2);
    expect(initial.counts.acceptance_tests).toBe(1);

    const frozen = await freezeContract({
      contractDir,
      approvedBy: "integration-test",
      prOrCommit: "integration-sha",
    });
    expect(frozen.feature.status).toBe("frozen");
    expect(frozen.hashes["examples.md"]).toMatch(/^sha256:[a-f0-9]{64}$/);
    expect(frozen.hashes["acceptance.spec.ts"]).toMatch(/^sha256:[a-f0-9]{64}$/);
  });

  test(
    "D. runBaseline invokes real Stryker + writes mutation.json + updates state.json",
    async () => {
      await runBaseline({
        workingDir: workspace,
        module: "src/lib/math.ts",
      });

      const mutationPath = join(workspace, "reports", "mutation", "mutation.json");
      expect(
        await fs.access(mutationPath).then(() => true).catch(() => false),
      ).toBe(true);

      const stryReport = await parseStrykerReport(mutationPath);
      expect(stryReport.perFile.size).toBeGreaterThan(0);
      expect(stryReport.totalMutants).toBeGreaterThan(0);

      const mathEntry = [...stryReport.perFile.entries()].find(([path]) =>
        path.endsWith("src/lib/math.ts"),
      );
      expect(mathEntry).toBeDefined();
      const [, mathScore] = mathEntry!;
      expect(mathScore.total).toBeGreaterThan(0);
      expect(mathScore.score).not.toBeNull();
      expect(mathScore.score!).toBeGreaterThan(0);
      expect(mathScore.score!).toBeLessThanOrEqual(100);

      const statePath = join(workspace, ".quality", "state.json");
      const state = await readState(statePath);

      const moduleKey = Object.keys(state.modules).find((k) =>
        k.endsWith("src/lib/math.ts"),
      );
      expect(moduleKey).toBeDefined();
      const moduleBaseline = state.modules[moduleKey!];
      expect(moduleBaseline).toBeDefined();
      expect(moduleBaseline!.tier).toBe("critical_75");
      expect(moduleBaseline!.mutation_baseline).toBeGreaterThan(0);
      expect(moduleBaseline!.mutation_baseline).toBeLessThanOrEqual(100);
      expect(moduleBaseline!.mutation_baseline_set_at).toMatch(
        /^\d{4}-\d{2}-\d{2}T/,
      );
    },
    400_000,
  );
});
