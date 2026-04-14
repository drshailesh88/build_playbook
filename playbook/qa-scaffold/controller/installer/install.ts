#!/usr/bin/env tsx
/**
 * Installer script invoked by `/playbook:install-qa-harness`.
 *
 * Steps (blueprint Part 1, Part 2, Part 4, 9.1):
 *   1. Copy `playbook/qa-scaffold/controller/` into the target app's `qa/`
 *   2. Run service detection against target's package.json + .env.example
 *   3. For each detected service: merge env_test_vars into .env.test.example,
 *      inject global-setup snippets, merge tier_hints into
 *      .quality/policies/tiers.yaml (marked as suggested), queue auto_install
 *      dev packages.
 *   4. Scaffold `.quality/` tree (contracts/, policies/, runs/)
 *   5. Write `.quality/policies/providers.yaml` (claude enabled by default)
 *   6. Write `.quality/policies/thresholds.yaml` (defaults)
 *   7. Generate `lock-manifest.json` (SHA256 of locked files that exist)
 *   8. Install enforcement layer templates (.claude/settings*, hooks, husky)
 *   9. Run `npm install` for queued dev packages
 *  10. Write `.quality/install-report.md`
 *
 * Flags:
 *   --upgrade           Idempotent re-run; merge without clobbering user edits.
 *   --strict-detection  Abort on unknown services (F1).
 *   --stub-unknowns     Generate .yaml.stub manifests for unknown services (F3).
 *   --dry-run           Compute actions, write nothing.
 */
import { promises as fs } from "node:fs";
import { createHash } from "node:crypto";
import { dirname, join, relative, resolve } from "node:path";
import yaml from "js-yaml";
import {
  detectServices,
  writeDetectedServicesYaml,
  writeStubManifest,
  type DetectionMode,
  type DetectionReport,
} from "../detection/service-detector.js";

// ─── Types ────────────────────────────────────────────────────────────────────

export interface InstallInput {
  targetDir: string;
  /** Root of the playbook scaffold (where `controller/`, `registry/`,
   * `snippets/`, `templates/` live). */
  scaffoldRoot: string;
  mode?: DetectionMode;
  upgrade?: boolean;
  dryRun?: boolean;
  /** Don't actually `npm install`. Tests. */
  skipNpmInstall?: boolean;
  /** Injected runner for npm install. */
  runCommand?: (
    cmd: string,
    args: string[],
    options?: { cwd?: string },
  ) => Promise<{ exitCode: number; stdout: string; stderr: string }>;
}

export interface InstallResult {
  detection: DetectionReport;
  copiedFiles: string[];
  envTestVarsAdded: string[];
  tierHintsMerged: boolean;
  devPackagesInstalled: string[];
  devPackagesSkipped: string[];
  stubManifests: string[];
  lockManifestPath: string;
  installReportPath: string;
  providersYamlPath: string;
  thresholdsYamlPath: string;
  aborted?: string;
}

// ─── Main ─────────────────────────────────────────────────────────────────────

export async function runInstaller(input: InstallInput): Promise<InstallResult> {
  const { targetDir, scaffoldRoot, upgrade = false, dryRun = false } = input;
  const mode = input.mode ?? "default";
  const isWrite = !dryRun;

  const registryDir = join(scaffoldRoot, "registry", "services");
  const snippetsDir = join(scaffoldRoot, "snippets");
  const templatesDir = join(scaffoldRoot, "templates");
  const controllerSrc = join(scaffoldRoot, "controller");

  const result: InstallResult = {
    detection: {
      detected: [],
      unknowns: [],
      aborted: false,
      scannedPackageJson: false,
      scannedEnvExample: false,
    },
    copiedFiles: [],
    envTestVarsAdded: [],
    tierHintsMerged: false,
    devPackagesInstalled: [],
    devPackagesSkipped: [],
    stubManifests: [],
    lockManifestPath: "",
    installReportPath: "",
    providersYamlPath: "",
    thresholdsYamlPath: "",
  };

  // 1. Copy controller → target/qa/
  const qaDir = join(targetDir, "qa");
  result.copiedFiles = await copyTree(controllerSrc, qaDir, {
    write: isWrite,
    skipExisting: upgrade, // upgrade doesn't clobber user edits to controller
    excludeNames: new Set(["node_modules", "dist", "coverage", ".gitignore"]),
  });

  // 2. Run service detection
  result.detection = await detectServices({
    workingDir: targetDir,
    registryDir,
    mode,
  });

  if (mode === "stubs") {
    for (const unknown of result.detection.unknowns) {
      if (isWrite) {
        const path = await writeStubManifest(registryDir, unknown);
        if (path) result.stubManifests.push(path);
      }
    }
  }

  if (result.detection.aborted) {
    result.aborted = `strict-detection: ${result.detection.unknowns.length} unknown service(s) — aborting.`;
    return result;
  }

  // 3. Merge env_test_vars, snippets, tier_hints per detected service
  const envVarsRequired = new Map<string, string | undefined>();
  const devPackagesToInstall = new Set<string>();
  const globalSetupSnippets: string[] = [];
  const mocksSnippets: string[] = [];
  const tierFragments: Array<Record<string, string[]>> = [];

  for (const detected of result.detection.detected) {
    const m = detected.manifest;
    for (const v of m.env_test_vars.required) {
      envVarsRequired.set(v.name, v.description);
    }
    for (const v of m.env_test_vars.optional) {
      if (!envVarsRequired.has(v.name)) {
        envVarsRequired.set(v.name, `(optional) ${v.description ?? ""}`);
      }
    }
    for (const pkg of m.snippets?.auto_install_dev_packages ?? []) {
      devPackagesToInstall.add(pkg);
    }
    if (m.snippets?.global_setup) {
      globalSetupSnippets.push(m.snippets.global_setup);
    }
    if (m.tier_hints) {
      tierFragments.push({
        ...(m.tier_hints.critical_75 ? { critical_75: m.tier_hints.critical_75 } : {}),
        ...(m.tier_hints.business_60 ? { business_60: m.tier_hints.business_60 } : {}),
        ...(m.tier_hints.ui_gates_only ? { ui_gates_only: m.tier_hints.ui_gates_only } : {}),
      });
    }
  }

  // 4. Scaffold .quality/ tree
  const qualityDir = join(targetDir, ".quality");
  for (const sub of ["contracts", "policies", "runs"]) {
    if (isWrite) {
      await fs.mkdir(join(qualityDir, sub), { recursive: true });
    }
  }

  // 5. Detected-services.yaml (L2 with provenance)
  if (isWrite) {
    await writeDetectedServicesYaml({
      workingDir: targetDir,
      report: result.detection,
    });
  }

  // 6. Env.test.example
  const envTestExamplePath = join(targetDir, ".env.test.example");
  if (envVarsRequired.size > 0) {
    const merged = await mergeEnvTestExample(
      envTestExamplePath,
      envVarsRequired,
      { write: isWrite, upgrade },
    );
    result.envTestVarsAdded = merged;
  }

  // 7. Global-setup + mocks snippets
  if (globalSetupSnippets.length > 0 && isWrite) {
    await installGlobalSetup(
      join(targetDir, "tests", "global-setup.ts"),
      globalSetupSnippets,
      snippetsDir,
      { upgrade },
    );
  }
  for (const detected of result.detection.detected) {
    const mocks = detected.manifest.snippets?.mocks;
    if (!mocks) continue;
    for (const relPath of mocks) {
      const src = resolve(scaffoldRoot, relPath);
      const dst = join(targetDir, "tests", "mocks", relative(join(snippetsDir, "mocks"), src));
      if (isWrite) {
        await fs.mkdir(dirname(dst), { recursive: true });
        await copyFileIfMissing(src, dst, { upgrade });
      }
      mocksSnippets.push(dst);
    }
  }

  // 8. Merge tier_hints → tiers.yaml (marked as suggested)
  const tiersPath = join(qualityDir, "policies", "tiers.yaml");
  if (tierFragments.length > 0 && isWrite) {
    await mergeTiersYaml(tiersPath, tierFragments, { upgrade });
    result.tierHintsMerged = true;
  }

  // 9. providers.yaml (Claude enabled by default)
  const providersPath = join(qualityDir, "policies", "providers.yaml");
  if (isWrite) {
    await writeYamlIfMissing(
      providersPath,
      {
        schema_version: 1,
        active_fixer: "claude",
        enabled: ["claude"],
        disabled: ["codex", "gemini"],
        max_turns: 30,
      },
      { upgrade },
      "# Installed by /playbook:install-qa-harness.\n# To enable codex/gemini: install Seatbelt wrapper + flip flags.\n",
    );
  }
  result.providersYamlPath = providersPath;

  // 10. thresholds.yaml (plateau window, attempt budget)
  const thresholdsPath = join(qualityDir, "policies", "thresholds.yaml");
  if (isWrite) {
    await writeYamlIfMissing(
      thresholdsPath,
      {
        schema_version: 1,
        max_attempts: 10,
        plateau_window: 3,
        timeouts_ms: {
          vitest: 300_000,
          playwright: 600_000,
          stryker_incremental: 600_000,
          stryker_full: 3_600_000,
        },
      },
      { upgrade },
      "# Installed by /playbook:install-qa-harness. Tune per-project as needed.\n",
    );
  }
  result.thresholdsYamlPath = thresholdsPath;

  // 11. lock-manifest.json (SHA256 of locked files that exist)
  const lockManifestPath = join(qualityDir, "policies", "lock-manifest.json");
  if (isWrite) {
    await writeLockManifest(lockManifestPath, targetDir);
  }
  result.lockManifestPath = lockManifestPath;

  // 12. Enforcement templates (Layer 1, 2, 4)
  if (isWrite) {
    await installTemplates(templatesDir, targetDir, { upgrade });
  }

  // 13. npm install
  if (devPackagesToInstall.size > 0 && !input.skipNpmInstall && isWrite) {
    const pkgs = [...devPackagesToInstall];
    const runner = input.runCommand ?? (async (cmd, args, options) => {
      const { execa } = await import("execa");
      const out = await execa(cmd, args, {
        ...(options?.cwd !== undefined ? { cwd: options.cwd } : {}),
        reject: false,
      });
      return {
        exitCode: typeof out.exitCode === "number" ? out.exitCode : 1,
        stdout: typeof out.stdout === "string" ? out.stdout : "",
        stderr: typeof out.stderr === "string" ? out.stderr : "",
      };
    });
    const outcome = await runner("npm", ["install", "-D", ...pkgs], {
      cwd: targetDir,
    });
    if (outcome.exitCode === 0) {
      result.devPackagesInstalled = pkgs;
    } else {
      result.devPackagesSkipped = pkgs;
    }
  } else {
    result.devPackagesSkipped = [...devPackagesToInstall];
  }

  // 14. install-report.md
  const reportPath = join(qualityDir, "install-report.md");
  if (isWrite) {
    await writeInstallReport(reportPath, result);
  }
  result.installReportPath = reportPath;

  return result;
}

// ─── helpers ─────────────────────────────────────────────────────────────────

interface CopyOptions {
  write: boolean;
  skipExisting: boolean;
  excludeNames: Set<string>;
}

async function copyTree(
  src: string,
  dst: string,
  opts: CopyOptions,
): Promise<string[]> {
  const copied: string[] = [];
  let entries: Array<{ name: string; isDirectory(): boolean; isFile(): boolean }>;
  try {
    entries = await fs.readdir(src, { withFileTypes: true });
  } catch (err) {
    if ((err as NodeJS.ErrnoException).code === "ENOENT") return [];
    throw err;
  }
  if (opts.write) await fs.mkdir(dst, { recursive: true });
  for (const entry of entries) {
    if (opts.excludeNames.has(entry.name)) continue;
    const srcPath = join(src, entry.name);
    const dstPath = join(dst, entry.name);
    if (entry.isDirectory()) {
      const nested = await copyTree(srcPath, dstPath, opts);
      copied.push(...nested);
    } else if (entry.isFile()) {
      if (opts.skipExisting) {
        try {
          await fs.access(dstPath);
          continue;
        } catch {
          /* doesn't exist — proceed */
        }
      }
      if (opts.write) {
        await fs.copyFile(srcPath, dstPath);
      }
      copied.push(dstPath);
    }
  }
  return copied;
}

async function copyFileIfMissing(
  src: string,
  dst: string,
  opts: { upgrade: boolean },
): Promise<boolean> {
  if (opts.upgrade) {
    try {
      await fs.access(dst);
      return false;
    } catch {
      /* doesn't exist */
    }
  }
  await fs.copyFile(src, dst);
  return true;
}

async function mergeEnvTestExample(
  path: string,
  newVars: Map<string, string | undefined>,
  opts: { write: boolean; upgrade: boolean },
): Promise<string[]> {
  const existing = await fs.readFile(path, "utf8").catch(() => "");
  const existingKeys = new Set<string>();
  for (const line of existing.split("\n")) {
    const eq = line.indexOf("=");
    if (eq === -1) continue;
    const key = line.slice(0, eq).trim();
    if (/^[A-Z][A-Z0-9_]*$/.test(key)) existingKeys.add(key);
  }
  const added: string[] = [];
  const lines = existing === "" ? [] : existing.split("\n");
  if (existing === "") {
    lines.push("# .env.test.example — generated by /playbook:install-qa-harness");
    lines.push("# Copy to .env.test and fill in real test-mode values. Never commit .env.test.");
    lines.push("");
  }
  for (const [name, description] of newVars) {
    if (existingKeys.has(name)) continue;
    if (description) lines.push(`# ${description}`);
    lines.push(`${name}=`);
    added.push(name);
  }
  if (opts.write && added.length > 0) {
    await fs.mkdir(dirname(path), { recursive: true });
    await fs.writeFile(path, lines.join("\n") + (lines.at(-1) === "" ? "" : "\n"));
  }
  return added;
}

async function installGlobalSetup(
  path: string,
  snippetPaths: string[],
  snippetsRoot: string,
  opts: { upgrade: boolean },
): Promise<void> {
  // Simple strategy: if the target file doesn't exist, copy the FIRST
  // snippet verbatim. If multiple snippets apply (rare — usually one auth
  // flow), concatenate with clear section markers.
  if (snippetPaths.length === 0) return;
  try {
    await fs.access(path);
    if (opts.upgrade) return; // don't clobber user edits
  } catch {
    /* doesn't exist — proceed */
  }
  await fs.mkdir(dirname(path), { recursive: true });
  const contents: string[] = [
    "// Auto-generated by /playbook:install-qa-harness.",
    "// Contains global setup from detected services.",
    "",
  ];
  for (const rel of snippetPaths) {
    const src = resolve(snippetsRoot, "..", rel);
    const body = await fs.readFile(src, "utf8").catch(() => "");
    if (body === "") continue;
    contents.push(`// ─── from ${rel} ────────────────────────────────────`);
    contents.push(body);
    contents.push("");
  }
  await fs.writeFile(path, contents.join("\n"));
}

async function mergeTiersYaml(
  path: string,
  fragments: Array<Record<string, string[]>>,
  opts: { upgrade: boolean },
): Promise<void> {
  const existing = await fs.readFile(path, "utf8").catch(() => null);
  let tiers: {
    schema_version: 1;
    tiers: { critical_75: string[]; business_60: string[]; ui_gates_only: string[] };
    unclassified_behavior: "fail_fast";
  };
  if (existing) {
    const parsed = yaml.load(existing) as typeof tiers | undefined;
    tiers = parsed ?? {
      schema_version: 1,
      tiers: { critical_75: [], business_60: [], ui_gates_only: [] },
      unclassified_behavior: "fail_fast",
    };
    if (!tiers.tiers) {
      tiers.tiers = { critical_75: [], business_60: [], ui_gates_only: [] };
    }
  } else {
    tiers = {
      schema_version: 1,
      tiers: { critical_75: [], business_60: [], ui_gates_only: [] },
      unclassified_behavior: "fail_fast",
    };
  }

  for (const frag of fragments) {
    for (const [tierName, globs] of Object.entries(frag) as Array<
      [keyof typeof tiers.tiers, string[]]
    >) {
      const set = new Set(tiers.tiers[tierName] ?? []);
      for (const g of globs) set.add(g);
      tiers.tiers[tierName] = [...set].sort();
    }
  }

  await fs.mkdir(dirname(path), { recursive: true });
  const preamble =
    "# Installed by /playbook:install-qa-harness.\n" +
    "# Tier globs suggested by detected services are merged here.\n" +
    "# Review carefully — unclassified_behavior=fail_fast means every source\n" +
    "# file must match a glob or qa-run aborts.\n";
  await fs.writeFile(path, preamble + yaml.dump(tiers));
  void opts;
}

async function writeYamlIfMissing(
  path: string,
  body: unknown,
  opts: { upgrade: boolean },
  preamble: string,
): Promise<void> {
  try {
    await fs.access(path);
    if (opts.upgrade) return; // preserve user edits
  } catch {
    /* doesn't exist */
  }
  await fs.mkdir(dirname(path), { recursive: true });
  await fs.writeFile(path, preamble + yaml.dump(body));
}

async function writeLockManifest(path: string, targetDir: string): Promise<void> {
  const LOCKED_FILES = [
    "vitest.config.ts",
    "vitest.config.mjs",
    "playwright.config.ts",
    "stryker.conf.mjs",
    "stryker.conf.json",
    "tsconfig.json",
    "eslint.config.mjs",
    ".eslintrc.cjs",
    ".claude/settings.json",
    ".quality/policies/tiers.yaml",
  ];
  const files: Record<string, string> = {};
  for (const rel of LOCKED_FILES) {
    const abs = join(targetDir, rel);
    try {
      const buf = await fs.readFile(abs);
      files[rel] = `sha256:${createHash("sha256").update(buf).digest("hex")}`;
    } catch {
      /* file doesn't exist — skip */
    }
  }
  await fs.mkdir(dirname(path), { recursive: true });
  await fs.writeFile(
    path,
    JSON.stringify(
      {
        schema_version: 1,
        last_updated: new Date().toISOString(),
        files,
      },
      null,
      2,
    ),
  );
}

async function installTemplates(
  templatesDir: string,
  targetDir: string,
  opts: { upgrade: boolean },
): Promise<void> {
  // Copy .claude/settings*.json + hooks + .husky/pre-commit.
  const map: Array<[string, string]> = [
    [".claude/settings.json", ".claude/settings.json"],
    [".claude/settings-contract-authoring.json", ".claude/settings-contract-authoring.json"],
    [".claude/settings-test-authoring.json", ".claude/settings-test-authoring.json"],
    [".claude/settings-selector-wiring.json", ".claude/settings-selector-wiring.json"],
    [".claude/hooks/block-locked-paths.sh", ".claude/hooks/block-locked-paths.sh"],
    [".husky/pre-commit", ".husky/pre-commit"],
  ];
  for (const [rel, dstRel] of map) {
    const src = join(templatesDir, rel);
    const dst = join(targetDir, dstRel);
    try {
      await fs.access(src);
    } catch {
      continue;
    }
    if (opts.upgrade) {
      try {
        await fs.access(dst);
        continue;
      } catch {
        /* missing — install */
      }
    }
    await fs.mkdir(dirname(dst), { recursive: true });
    await fs.copyFile(src, dst);
    if (rel.endsWith(".sh") || rel.endsWith("pre-commit")) {
      await fs.chmod(dst, 0o755);
    }
  }
}

async function writeInstallReport(
  path: string,
  result: InstallResult,
): Promise<void> {
  const lines: string[] = [];
  lines.push("# QA Harness — Install Report");
  lines.push("");
  lines.push(`Generated: ${new Date().toISOString()}`);
  lines.push("");
  lines.push("## Detected Services");
  lines.push("");
  if (result.detection.detected.length === 0) {
    lines.push("_None detected._");
  } else {
    for (const d of result.detection.detected) {
      lines.push(`- **${d.name}** (${d.manifest.status}): matched ${d.matchedPackagePatterns.length} package pattern(s), ${d.matchedEnvPatterns.length} env pattern(s)`);
    }
  }
  lines.push("");
  lines.push("## Unknown Signals");
  lines.push("");
  if (result.detection.unknowns.length === 0) {
    lines.push("_No unknowns._");
  } else {
    for (const u of result.detection.unknowns) {
      lines.push(`- ${u.kind}: \`${u.value}\`${u.suggestedService ? ` → suggests \`${u.suggestedService}\`` : ""}`);
    }
  }
  lines.push("");
  lines.push("## Env Variables Added to `.env.test.example`");
  lines.push("");
  for (const v of result.envTestVarsAdded) lines.push(`- ${v}`);
  if (result.envTestVarsAdded.length === 0) lines.push("_None._");
  lines.push("");
  lines.push("## Dev Packages Installed");
  lines.push("");
  if (result.devPackagesInstalled.length === 0 && result.devPackagesSkipped.length === 0) {
    lines.push("_None._");
  } else {
    if (result.devPackagesInstalled.length > 0) {
      lines.push("**Installed:**");
      for (const p of result.devPackagesInstalled) lines.push(`- ${p}`);
    }
    if (result.devPackagesSkipped.length > 0) {
      lines.push("**Skipped:**");
      for (const p of result.devPackagesSkipped) lines.push(`- ${p}`);
    }
  }
  lines.push("");
  lines.push("## Stub Manifests");
  lines.push("");
  for (const s of result.stubManifests) lines.push(`- ${s}`);
  if (result.stubManifests.length === 0) lines.push("_None._");
  lines.push("");
  lines.push("## Next Steps");
  lines.push("");
  lines.push("1. Fill in `.env.test` (copy from `.env.test.example`).");
  lines.push("2. Review `.quality/policies/tiers.yaml` and adjust globs for your project.");
  lines.push("3. Author contracts: `/playbook:contract-pack <feature-name>` for each critical feature.");
  lines.push("4. Run `npx qa baseline` to populate module mutation baselines.");
  lines.push("5. Run `npx qa run` for the first QA session.");
  lines.push("");

  await fs.mkdir(dirname(path), { recursive: true });
  await fs.writeFile(path, lines.join("\n"));
}
