#!/usr/bin/env node
/**
 * QA controller — CLI entry point (blueprint Part 5.1, Part 7).
 *
 * Subcommands:
 *   run              Full session: preflight → lock → baseline → features → summary
 *   baseline         Full Stryker baseline measurement (skeleton for Phase 5)
 *   status           Current state snapshot (stub — Phase 5)
 *   report           Generate cumulative/single-run report (stub — Phase 5)
 *   doctor           Drift check (stub — Phase 5)
 *   clean            Clear stale locks + compress old runs
 *   unblock          Reset BLOCKED feature state (stub — Phase 5)
 *   baseline-reset   Explicit ratchet-down with audit log entry
 *   audit-violations Review all violation history (stub — Phase 5)
 *
 * Phase 3 ships `run`, `baseline-reset`, and `clean` fully. Others print a
 * "not yet implemented" message so the surface is stable.
 */
import { promises as fs } from "node:fs";
import { join, resolve } from "node:path";
import { Command } from "commander";
import yaml from "js-yaml";
import {
  defaultRunCommand,
  type RunCommandFn,
} from "./gates/base.js";
import {
  acquireSessionLock,
  endRun,
  incrementViolationCount,
  initializeState,
  readState,
  recordRunFeatureOutcome,
  releaseSessionLock,
  resetModuleBaseline,
  startRun,
  writeState,
} from "./state-manager.js";
import { runRecoveryPreflight } from "./recovery.js";
import { runFeatureLoop, type FeatureLoopResult } from "./feature-loop.js";
import {
  getDirectDeps,
  getReverseDeps,
} from "./detection/dependency-analyzer.js";
import { loadProvider } from "./providers/base.js";
import { parseStrykerReport } from "./parsers/stryker-json.js";
import {
  ContractIndexSchema,
  TierConfigSchema,
  SecurityCategorySet,
  type ContractIndex,
  type RunId,
  type StateJson,
  type TierConfig,
  type ViolationEntry,
} from "./types.js";

const ISO_NOW = (): string => new Date().toISOString();

const CONTROLLER_VERSION = "0.1.0";

// ─── Session orchestration (testable) ────────────────────────────────────────

export interface SessionInput {
  workingDir: string;
  runCommand?: RunCommandFn;
  /** Override run id (otherwise generated). */
  runId?: RunId;
  /** Filter — run only a single feature. */
  featureId?: string;
  /** Filter — run only features of this category. */
  category?: string;
  /** Skip the notification side-effect. */
  noNotification?: boolean;
  /** Skip baseline Stryker (for tests). */
  skipBaselineStryker?: boolean;
  /** Override onOpen (macOS `open` by default, no-op on tests). */
  onOpen?: (path: string) => Promise<void>;
  /** Override notification. */
  onNotify?: (message: string) => Promise<void>;
}

export interface SessionResult {
  runId: RunId;
  featuresAttempted: string[];
  featuresGreen: string[];
  featuresBlocked: string[];
  violationsCount: number;
  summaryPath: string;
  stateDeltaPath: string;
  endedAt: string;
  error?: string;
}

export async function runSession(input: SessionInput): Promise<SessionResult> {
  const runCommand = input.runCommand ?? defaultRunCommand();
  const runId = input.runId ?? generateRunId();

  const qualityDir = join(input.workingDir, ".quality");
  const runsDir = join(qualityDir, "runs");
  const runArtifactsDir = join(runsDir, runId);
  const lockPath = join(qualityDir, "state.lock");
  const statePath = join(qualityDir, "state.json");
  const policiesDir = join(qualityDir, "policies");
  const contractsDir = join(qualityDir, "contracts");

  // 1. Preflight (R-2).
  await runRecoveryPreflight({
    workingDir: input.workingDir,
    newRunId: runId,
    runCommand,
  });

  // 2. Acquire lock.
  await fs.mkdir(runArtifactsDir, { recursive: true });
  const startedAt = ISO_NOW();
  await acquireSessionLock({
    lockPath,
    runId,
    qaControllerVersion: CONTROLLER_VERSION,
    timestamp: startedAt,
  });

  let state: StateJson;
  try {
    state = await readState(statePath);
  } catch {
    state = initializeState(startedAt);
    await writeState(statePath, state);
  }

  const tiers = await loadTierConfig(policiesDir);
  const contracts = await loadAllContracts(contractsDir);
  const filteredContracts = applyCategoryGate(contracts, {
    ...(input.featureId !== undefined ? { featureId: input.featureId } : {}),
    ...(input.category !== undefined ? { category: input.category } : {}),
  });

  // 3. Full Stryker baseline (parallel with in-memory init — kept sequential
  // for simplicity in Phase 3; Phase 5 can parallelize via Promise.all).
  let baselineScore: number | undefined;
  if (!input.skipBaselineStryker) {
    baselineScore = await runFullStrykerBaseline(runCommand, input.workingDir);
  }
  state = startRun(state, runId, startedAt, baselineScore);

  // 4. Feature enumeration + serial loop.
  const provider = await loadProvider(policiesDir, {
    workingDir: input.workingDir,
    runCommand,
  });

  const featureResults: FeatureLoopResult[] = [];
  const violationEntries: ViolationEntry[] = [];

  for (const contract of filteredContracts) {
    const contractDir = join(contractsDir, contract.feature.id);
    state = recordRunFeatureOutcome(
      state,
      runId,
      contract.feature.id,
      "attempted",
      ISO_NOW(),
    );
    const result = await runFeatureLoop({
      runId,
      sessionId: runId,
      featureId: contract.feature.id,
      contract,
      contractDir,
      state,
      tiers,
      workingDir: input.workingDir,
      runArtifactsDir,
      provider,
      runCommand,
      getDirectDeps: (file: string) =>
        getDirectDeps(file, input.workingDir),
      getReverseDeps: (files: string[]) =>
        getReverseDeps(files, input.workingDir),
    });
    featureResults.push(result);
    state = result.state; // Adopt any mutation baseline updates.

    state = recordRunFeatureOutcome(
      state,
      runId,
      contract.feature.id,
      result.finalOutcome === "GREEN" ? "green" : "blocked",
      ISO_NOW(),
    );

    for (const v of result.violationEntries) {
      violationEntries.push(v);
      state = incrementViolationCount(state, runId, ISO_NOW());
    }
  }

  // 5. End run + persist state.
  const endedAt = ISO_NOW();
  state = endRun(state, runId, endedAt);
  await writeState(statePath, state);
  await fs.writeFile(
    join(runArtifactsDir, "state-delta.json"),
    JSON.stringify(
      { runId, startedAt, endedAt, featureResultsCount: featureResults.length },
      null,
      2,
    ),
  );

  // 6. Violations ledger.
  const violationsJsonl = violationEntries
    .map((v) => JSON.stringify(v))
    .join("\n");
  if (violationsJsonl) {
    await fs.writeFile(
      join(runArtifactsDir, "violations.jsonl"),
      violationsJsonl + "\n",
    );
  }

  // 7. Summary.md (deterministic).
  const summaryPath = join(runArtifactsDir, "summary.md");
  const summary = buildSummary({
    runId,
    startedAt,
    endedAt,
    featureResults,
    state,
    baselineScore,
    violationsCount: violationEntries.length,
  });
  await fs.writeFile(summaryPath, summary);

  // 8. Commit state.
  try {
    await runCommand("git", ["add", ".quality/state.json", `.quality/runs/${runId}/`], {
      cwd: input.workingDir,
    });
    await runCommand(
      "git",
      ["commit", "-m", `chore(qa): state update after ${runId}`],
      {
        cwd: input.workingDir,
        env: { ...process.env, QA_CONTROLLER_COMMIT: "1" },
      },
    );
  } catch {
    // Commit is best-effort; user may commit manually.
  }

  // 9. Release lock.
  await releaseSessionLock(lockPath);

  // 10. Notifications.
  const greenCount = featureResults.filter(
    (f) => f.finalOutcome === "GREEN",
  ).length;
  const blockedCount = featureResults.length - greenCount;
  const verdictMsg = `QA run complete: ${greenCount} green, ${blockedCount} blocked`;
  if (!input.noNotification) {
    const notifier = input.onNotify ?? defaultNotify;
    await notifier(verdictMsg).catch(() => {
      /* notifications are best-effort */
    });
    const opener = input.onOpen ?? defaultOpen;
    await opener(summaryPath).catch(() => {
      /* also best-effort */
    });
  }

  return {
    runId,
    featuresAttempted: featureResults.map((f) => f.featureId),
    featuresGreen: featureResults
      .filter((f) => f.finalOutcome === "GREEN")
      .map((f) => f.featureId),
    featuresBlocked: featureResults
      .filter((f) => f.finalOutcome === "BLOCKED")
      .map((f) => f.featureId),
    violationsCount: violationEntries.length,
    summaryPath,
    stateDeltaPath: join(runArtifactsDir, "state-delta.json"),
    endedAt,
  };
}

// ─── Baseline reset command ──────────────────────────────────────────────────

export interface BaselineResetInput {
  workingDir: string;
  module: string;
  reason: string;
  newBaseline: number;
  approvedBy: string;
  runCommand?: RunCommandFn;
}

export async function runBaselineReset(
  input: BaselineResetInput,
): Promise<void> {
  const statePath = join(input.workingDir, ".quality", "state.json");
  const state = await readState(statePath);
  const updated = resetModuleBaseline({
    state,
    modulePath: input.module,
    newBaseline: input.newBaseline,
    reason: input.reason,
    triggered_by: "qa-baseline-reset command",
    approved_by: input.approvedBy,
    timestamp: ISO_NOW(),
  });
  await writeState(statePath, updated);
}

// ─── Clean command ───────────────────────────────────────────────────────────

export interface CleanResult {
  staleLockCleared: boolean;
  archivedRuns: string[];
  retainedRuns: string[];
}

export interface CleanInput {
  workingDir: string;
  retentionDays?: number;
  pidAlive?: (pid: number) => boolean;
}

export async function runClean(input: CleanInput): Promise<CleanResult> {
  const retentionDays = input.retentionDays ?? 30;
  const qualityDir = join(input.workingDir, ".quality");
  const lockPath = join(qualityDir, "state.lock");
  const runsDir = join(qualityDir, "runs");

  // 1. Clear stale lock (if present).
  let staleLockCleared = false;
  try {
    const { readSessionLock, isLockAlive } = await import("./state-manager.js");
    const lock = await readSessionLock(lockPath);
    if (lock && !isLockAlive(lock, input.pidAlive)) {
      await fs.unlink(lockPath);
      staleLockCleared = true;
    }
  } catch {
    /* ignore */
  }

  // 2. Archive heavy artifacts from runs older than retentionDays.
  const archivedRuns: string[] = [];
  const retainedRuns: string[] = [];
  let entries: string[] = [];
  try {
    entries = await fs.readdir(runsDir);
  } catch {
    entries = [];
  }
  const cutoff = Date.now() - retentionDays * 24 * 3600 * 1000;
  for (const name of entries) {
    if (name === "abandoned") continue;
    const runDir = join(runsDir, name);
    const stat = await fs.stat(runDir).catch(() => null);
    if (!stat || !stat.isDirectory()) continue;
    if (stat.mtimeMs < cutoff) {
      // Remove heavy gitignored artifact dirs; keep summary + state-delta.
      for (const heavy of [
        "evidence",
        "fixer-notes",
        "traces",
        "stryker-html",
        "playwright-report",
      ]) {
        const heavyPath = join(runDir, heavy);
        await fs.rm(heavyPath, { recursive: true, force: true });
      }
      archivedRuns.push(name);
    } else {
      retainedRuns.push(name);
    }
  }

  return { staleLockCleared, archivedRuns, retainedRuns };
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

export function generateRunId(): RunId {
  const ts = new Date().toISOString().replace(/[:.]/g, "-").slice(0, 19);
  const rand = Math.floor(Math.random() * 1000)
    .toString()
    .padStart(3, "0");
  return `run-${ts}-${rand}`;
}

async function loadTierConfig(policiesDir: string): Promise<TierConfig> {
  const path = join(policiesDir, "tiers.yaml");
  const raw = await fs.readFile(path, "utf8").catch(() => null);
  if (raw === null) {
    // Minimal config when missing (Phase 5 scaffold will write this).
    return TierConfigSchema.parse({
      schema_version: 1,
      tiers: { critical_75: [], business_60: [], ui_gates_only: [] },
      unclassified_behavior: "fail_fast",
    });
  }
  return TierConfigSchema.parse(yaml.load(raw));
}

export async function loadAllContracts(
  contractsDir: string,
): Promise<ContractIndex[]> {
  let entries: string[];
  try {
    entries = await fs.readdir(contractsDir);
  } catch (err) {
    if ((err as NodeJS.ErrnoException).code === "ENOENT") return [];
    throw err;
  }
  const contracts: ContractIndex[] = [];
  for (const name of entries) {
    const indexPath = join(contractsDir, name, "index.yaml");
    const raw = await fs.readFile(indexPath, "utf8").catch(() => null);
    if (raw === null) continue;
    const parsed = yaml.load(raw);
    const result = ContractIndexSchema.safeParse(parsed);
    if (result.success) contracts.push(result.data);
  }
  return contracts;
}

export interface CategoryGateFilter {
  featureId?: string;
  category?: string;
}

export function applyCategoryGate(
  contracts: ContractIndex[],
  filter: CategoryGateFilter = {},
): ContractIndex[] {
  // 12d: auth / payments / user_data — MUST be frozen; otherwise hard error.
  //      business_logic / ui — not frozen = skip with warning (O-γ).
  const critical: ContractIndex[] = [];
  const business: ContractIndex[] = [];
  const errors: string[] = [];

  for (const c of contracts) {
    if (filter.featureId && c.feature.id !== filter.featureId) continue;
    if (filter.category && c.feature.category !== filter.category) continue;

    if (SecurityCategorySet.has(c.feature.category)) {
      if (c.feature.status !== "frozen") {
        errors.push(
          `HARD ERROR: feature ${c.feature.id} (${c.feature.category}) is status=${c.feature.status}; must be frozen before qa run`,
        );
      } else {
        critical.push(c);
      }
    } else {
      if (c.feature.status !== "frozen") {
        // Skip-with-warning in Phase 3; the controller's release log captures these.
        continue;
      }
      business.push(c);
    }
  }

  if (errors.length > 0) {
    throw new Error(errors.join("\n"));
  }

  return [...critical, ...business];
}

async function runFullStrykerBaseline(
  runCommand: RunCommandFn,
  workingDir: string,
): Promise<number | undefined> {
  const outcome = await runCommand("npx", ["stryker", "run"], {
    cwd: workingDir,
    timeout: 60 * 60 * 1000, // 1 hour safety
  });
  if (outcome.exitCode !== 0 && outcome.exitCode !== 1) {
    return undefined;
  }
  try {
    const report = await parseStrykerReport(
      join(workingDir, "reports", "mutation", "mutation.json"),
    );
    return report.overallScore ?? undefined;
  } catch {
    return undefined;
  }
}

export interface BuildSummaryInput {
  runId: RunId;
  startedAt: string;
  endedAt: string;
  featureResults: FeatureLoopResult[];
  state: StateJson;
  baselineScore: number | undefined;
  violationsCount: number;
}

export function buildSummary(input: BuildSummaryInput): string {
  const { runId, startedAt, endedAt, featureResults, state, violationsCount } = input;

  const greens = featureResults.filter((f) => f.finalOutcome === "GREEN");
  const blocked = featureResults.filter((f) => f.finalOutcome === "BLOCKED");
  const duration = prettyDuration(startedAt, endedAt);

  const runRecord = state.runs[runId];
  const finalScore = runRecord?.final_full_mutation_score;
  const baselineRecorded = runRecord?.baseline_full_mutation_score;

  const lines: string[] = [];
  lines.push(`# QA Run Summary — ${runId}`);
  lines.push("");
  lines.push(
    `**Session:** ${startedAt} → ${endedAt} (${duration})`,
  );
  lines.push(`**Controller:** v${CONTROLLER_VERSION}`);
  lines.push("");
  lines.push(`## Verdict`);
  lines.push("");
  lines.push(
    `- ${featureResults.length} feature(s) attempted`,
  );
  lines.push(`- ${greens.length} green`);
  lines.push(`- ${blocked.length} blocked`);
  lines.push(`- ${violationsCount} violation(s) detected`);
  lines.push("");

  lines.push(`## Contract Integrity`);
  lines.push("");
  // Phase 3: the contract-hash-verify gate runs inside every attempt; we
  // surface a simple summary based on whether any BLOCKED feature was
  // caused by CONTRACT_TAMPERED.
  const integrityBlocked = blocked.filter((f) =>
    f.blockedReason?.includes("integrity breach"),
  );
  if (integrityBlocked.length === 0) {
    lines.push(`- All contract hashes verified intact across all iterations ✅`);
  } else {
    lines.push(
      `- ❌ ${integrityBlocked.length} feature(s) flagged CONTRACT_TAMPERED`,
    );
    for (const f of integrityBlocked) {
      lines.push(`  - \`${f.featureId}\`: ${f.blockedReason}`);
    }
  }
  lines.push("");

  if (baselineRecorded !== undefined || finalScore !== undefined) {
    lines.push(`## Baseline → Final`);
    lines.push("");
    lines.push(`| Metric | Baseline | Final |`);
    lines.push(`|---|---|---|`);
    lines.push(
      `| Overall mutation score | ${baselineRecorded ?? "n/a"} | ${finalScore ?? "n/a"} |`,
    );
    lines.push("");
  }

  lines.push(`## Features`);
  lines.push("");
  for (const f of featureResults) {
    const emoji = f.finalOutcome === "GREEN" ? "🟢" : "🔴";
    lines.push(
      `### ${emoji} ${f.featureId} — ${f.finalOutcome} (${f.attempts.length} attempt(s))`,
    );
    lines.push("");
    if (f.blockedReason) {
      lines.push(`**Blocked reason:** ${f.blockedReason}`);
      lines.push("");
    }
    lines.push(
      `Last signature: \`${f.plateauBuffer[f.plateauBuffer.length - 1] ?? "n/a"}\``,
    );
    lines.push("");
  }

  if (violationsCount > 0) {
    lines.push(`## Violations Detected`);
    lines.push("");
    lines.push(`See \`violations.jsonl\` in the run directory.`);
    lines.push("");
  }

  lines.push(`## Next Actions`);
  lines.push("");
  for (const b of blocked) {
    lines.push(
      `- Review BLOCKED feature \`${b.featureId}\`: ${b.blockedReason ?? "unknown"}`,
    );
  }
  if (blocked.length === 0 && greens.length > 0) {
    lines.push(`- No blockers. Safe to continue.`);
  }
  if (integrityBlocked.length > 0) {
    lines.push(
      `- **Contract tamper** detected — investigate and rebase before next run.`,
    );
  }
  lines.push("");
  return lines.join("\n");
}

function prettyDuration(startedAt: string, endedAt: string): string {
  const ms = Math.max(0, new Date(endedAt).getTime() - new Date(startedAt).getTime());
  const h = Math.floor(ms / 3600_000);
  const m = Math.floor((ms % 3600_000) / 60_000);
  const s = Math.floor((ms % 60_000) / 1000);
  return `${h}h ${m}m ${s}s`;
}

async function defaultNotify(message: string): Promise<void> {
  if (process.platform !== "darwin") return;
  const runCommand = defaultRunCommand();
  await runCommand(
    "osascript",
    ["-e", `display notification "${message.replace(/"/g, '\\"')}" with title "QA"`],
    {},
  );
}

async function defaultOpen(path: string): Promise<void> {
  if (process.platform !== "darwin") return;
  const runCommand = defaultRunCommand();
  await runCommand("open", [path], {});
}

// ─── CLI wiring ──────────────────────────────────────────────────────────────

export function buildCli(): Command {
  const program = new Command();
  program
    .name("qa")
    .description("QA controller — hardened test-and-repair loop")
    .version(CONTROLLER_VERSION);

  program
    .command("run")
    .description("Run the full QA session")
    .option("--feature <id>", "run only this feature")
    .option("--category <category>", "run only features in this category")
    .option("--no-notification", "skip macOS notification + open")
    .option("--skip-baseline-stryker", "skip full Stryker baseline (dev)")
    .action(async (opts) => {
      const result = await runSession({
        workingDir: process.cwd(),
        ...(opts.feature ? { featureId: opts.feature as string } : {}),
        ...(opts.category ? { category: opts.category as string } : {}),
        noNotification: opts.notification === false,
        skipBaselineStryker: Boolean(opts.skipBaselineStryker),
      });
      process.stdout.write(`RUN ${result.runId}\n`);
      process.stdout.write(`summary: ${result.summaryPath}\n`);
      process.stdout.write(
        `green=${result.featuresGreen.length} blocked=${result.featuresBlocked.length} violations=${result.violationsCount}\n`,
      );
    });

  program
    .command("baseline-reset")
    .description("Explicit ratchet-down of a module baseline (audit-logged)")
    .requiredOption("--module <path>", "module path (relative to repo root)")
    .requiredOption("--reason <text>", "reason for the reset")
    .requiredOption("--new-baseline <score>", "new baseline (0-100)")
    .option("--approved-by <user>", "approver name", process.env.USER ?? "unknown")
    .action(async (opts) => {
      await runBaselineReset({
        workingDir: process.cwd(),
        module: opts.module,
        reason: opts.reason,
        newBaseline: Number(opts.newBaseline),
        approvedBy: opts.approvedBy,
      });
      process.stdout.write(`baseline reset for ${opts.module}\n`);
    });

  program
    .command("clean")
    .description("Clear stale locks + compress runs older than retention")
    .option("--retention-days <days>", "retain heavy artifacts for N days", "30")
    .action(async (opts) => {
      const result = await runClean({
        workingDir: process.cwd(),
        retentionDays: Number(opts.retentionDays),
      });
      process.stdout.write(
        `clean: staleLockCleared=${result.staleLockCleared} archived=${result.archivedRuns.length} retained=${result.retainedRuns.length}\n`,
      );
    });

  for (const stubName of [
    "status",
    "report",
    "doctor",
    "unblock",
    "audit-violations",
    "baseline",
  ] as const) {
    program
      .command(stubName)
      .description(`${stubName} (not yet implemented — Phase 5)`)
      .allowUnknownOption()
      .action(async () => {
        process.stdout.write(
          `${stubName}: not yet implemented — Phase 5.\n`,
        );
      });
  }

  return program;
}

// ─── Main entry ──────────────────────────────────────────────────────────────

async function main(): Promise<void> {
  const cli = buildCli();
  await cli.parseAsync(process.argv);
}

// Only run main when invoked as a script. When imported as a module, skip.
const isMain = (() => {
  try {
    const invoked = resolve(process.argv[1] ?? "");
    const selfUrl = new URL(import.meta.url).pathname;
    return invoked === selfUrl;
  } catch {
    return false;
  }
})();

if (isMain) {
  main().catch((err) => {
    process.stderr.write(`error: ${err instanceof Error ? err.message : String(err)}\n`);
    process.exit(1);
  });
}
