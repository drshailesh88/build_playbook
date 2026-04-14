/**
 * Deterministic summary writer (blueprint Part 11 + 13d).
 *
 * Renders `.quality/runs/<run-id>/summary.md` entirely from structured
 * inputs — NO LLM, no prose generation. Every section is template-filled
 * from controller state so the same inputs always produce the same output.
 *
 * Sections (blueprint Part 11):
 *   1. Header + session metadata
 *   2. Verdict (feature counts, violations, integrity)
 *   3. Contract Integrity (13d: affirmative statement of hash state)
 *   4. Baseline → Final metrics table
 *   5. Features (per-feature blocks with attempt counts)
 *   6. Baseline Changes table
 *   7. Violations Detected
 *   8. Anti-cheat Warnings
 *   9. Performance
 *   10. Next Actions (rule-based)
 */
import { promises as fs } from "node:fs";
import { dirname } from "node:path";
import type {
  BaselineResetEntry,
  RunId,
  StateJson,
  ViolationEntry,
} from "../types.js";
import type {
  FeatureLoopResult,
} from "../feature-loop.js";
import type { ReleaseResult } from "../gates/release-runner.js";

export interface SummaryInput {
  runId: RunId;
  startedAt: string;
  endedAt: string;
  controllerVersion: string;
  triggeredBy?: string;
  previousRunId?: string;
  featureResults: FeatureLoopResult[];
  violationEntries: ViolationEntry[];
  /** Release-gate outcome when present (otherwise loop-only session). */
  releaseResult?: ReleaseResult;
  /** State AT SESSION END. Used for final baselines + reset history. */
  state: StateJson;
  /** Snapshot of module baselines BEFORE the session started. Used to
   * compute the "Baseline Changes" table. */
  startingState?: StateJson;
  /** Stryker overall baseline measured at session start (may be missing). */
  baselineStrykerScore?: number;
  /** Stryker full score at session end. */
  finalStrykerScore?: number;
  /** Anti-cheat warnings collected across attempts (pattern IDs → count). */
  warnings?: Record<string, number>;
  /** Performance timing summary. */
  performance?: {
    baselineStrykerMs?: number;
    medianIterationMs?: number;
    maxIterationMs?: number;
    fixerInvocations?: number;
    fixerRuntimeMs?: number;
  };
}

export interface SummaryWriteInput extends SummaryInput {
  summaryPath: string;
}

export async function writeSummary(
  input: SummaryWriteInput,
): Promise<string> {
  const content = renderSummary(input);
  await fs.mkdir(dirname(input.summaryPath), { recursive: true });
  await fs.writeFile(input.summaryPath, content, "utf8");
  return input.summaryPath;
}

export function renderSummary(input: SummaryInput): string {
  const greens = input.featureResults.filter(
    (f) => f.finalOutcome === "GREEN",
  );
  const blocked = input.featureResults.filter(
    (f) => f.finalOutcome === "BLOCKED",
  );
  const violationsCount = input.violationEntries.length;
  const integrityBreaches = blocked.filter((f) =>
    (f.blockedReason ?? "").toLowerCase().includes("integrity breach"),
  );

  const lines: string[] = [];

  // ── Header
  lines.push(`# QA Run Summary — ${input.runId}`);
  lines.push("");
  lines.push(
    `**Session:** ${input.startedAt} → ${input.endedAt} (${prettyDuration(input.startedAt, input.endedAt)})`,
  );
  lines.push(`**Controller:** v${input.controllerVersion}`);
  if (input.triggeredBy) {
    lines.push(`**Triggered by:** ${input.triggeredBy}`);
  }
  if (input.previousRunId) {
    lines.push(`**Previous run:** ${input.previousRunId}`);
  }
  lines.push("");

  // ── Verdict
  lines.push(`## Verdict`);
  lines.push("");
  lines.push(`**Status:** ${verdictBadge(input, greens.length, blocked.length, violationsCount, integrityBreaches.length)}`);
  lines.push("");
  lines.push(`- ${input.featureResults.length} feature(s) attempted`);
  lines.push(`- ${greens.length} green`);
  lines.push(`- ${blocked.length} blocked`);
  lines.push(`- ${violationsCount} violation(s) detected`);
  lines.push(`- ${integrityBreaches.length} contract tamper event(s)`);
  if (input.releaseResult) {
    lines.push(
      `- Release gates: **${input.releaseResult.verdict}** (${input.releaseResult.verdictReason})`,
    );
  }
  lines.push("");

  // ── Contract Integrity (13d — affirmative)
  lines.push(`## Contract Integrity`);
  lines.push("");
  if (integrityBreaches.length === 0) {
    lines.push(
      `- All contract hashes verified intact across all iterations ✅`,
    );
  } else {
    lines.push(
      `- ❌ ${integrityBreaches.length} feature(s) flagged CONTRACT_TAMPERED:`,
    );
    for (const f of integrityBreaches) {
      lines.push(`  - \`${f.featureId}\`: ${f.blockedReason}`);
    }
  }
  if (input.releaseResult) {
    const releaseIntegrity = input.releaseResult.gateResults.find(
      (g) => g.gateId === "contract-hash-verify",
    );
    if (releaseIntegrity && releaseIntegrity.status === "pass") {
      lines.push(`- Release-time contract hash verification: passed ✅`);
    } else if (releaseIntegrity) {
      lines.push(
        `- ❌ Release-time contract hash verification: ${releaseIntegrity.status}`,
      );
    }
  }
  lines.push("");

  // ── Baseline → Final
  if (
    input.baselineStrykerScore !== undefined ||
    input.finalStrykerScore !== undefined
  ) {
    lines.push(`## Baseline → Final`);
    lines.push("");
    lines.push(`| Metric | Baseline | Final | Delta |`);
    lines.push(`|---|---|---|---|`);
    lines.push(
      `| Overall mutation score | ${formatScore(input.baselineStrykerScore)} | ${formatScore(input.finalStrykerScore)} | ${formatDelta(input.baselineStrykerScore, input.finalStrykerScore)} |`,
    );
    lines.push("");
  }

  // ── Features
  lines.push(`## Features`);
  lines.push("");
  if (input.featureResults.length === 0) {
    lines.push(`_No features attempted this run._`);
    lines.push("");
  } else {
    for (const f of input.featureResults) {
      const emoji = f.finalOutcome === "GREEN" ? "🟢" : "🔴";
      const featState = input.state.features[f.featureId];
      const mutationsForFeature = collectModulesForFeature(f, input.state);
      lines.push(
        `### ${emoji} ${f.featureId} — ${f.finalOutcome} (${f.attempts.length} attempt(s))`,
      );
      lines.push("");
      if (f.blockedReason) {
        lines.push(`**Blocked reason:** ${f.blockedReason}`);
      }
      if (featState?.last_green_at) {
        lines.push(`**Last green:** ${featState.last_green_at}`);
      }
      const lastSig = f.plateauBuffer[f.plateauBuffer.length - 1];
      if (lastSig) {
        lines.push(`**Last signature:** \`${lastSig}\``);
      }
      if (mutationsForFeature.length > 0) {
        lines.push("");
        lines.push(`Per-module mutation scores:`);
        for (const m of mutationsForFeature) {
          lines.push(
            `- \`${m.path}\`: ${m.score}% (${m.tier}${m.floor !== null ? `, floor ${m.floor}%` : ", no floor"})`,
          );
        }
      }
      lines.push("");
    }
  }

  // ── Baseline Changes
  const baselineChanges = computeBaselineChanges(
    input.startingState,
    input.state,
  );
  if (baselineChanges.length > 0 || input.state.baseline_reset_log.length > 0) {
    lines.push(`## Baseline Changes`);
    lines.push("");
    if (baselineChanges.length > 0) {
      lines.push(`| Module | Previous | Current | Delta | Source |`);
      lines.push(`|---|---|---|---|---|`);
      for (const c of baselineChanges) {
        lines.push(
          `| \`${c.module}\` | ${formatScore(c.previous)} | ${formatScore(c.current)} | ${formatDelta(c.previous, c.current)} | ${c.source} |`,
        );
      }
      lines.push("");
    }
    const recentResets = collectRecentResets(input.state.baseline_reset_log, input);
    if (recentResets.length > 0) {
      lines.push(`**Baseline resets this session:**`);
      for (const r of recentResets) {
        lines.push(
          `- \`${r.module}\`: ${r.old_baseline}% → ${r.new_baseline}% — _${r.reason}_ (approved by ${r.approved_by})`,
        );
      }
      lines.push("");
    }
  }

  // ── Violations
  lines.push(`## Violations Detected`);
  lines.push("");
  if (violationsCount === 0) {
    lines.push(`_None this run._`);
  } else {
    const byPattern = groupViolationsByPattern(input.violationEntries);
    for (const [patternId, count] of Object.entries(byPattern)) {
      lines.push(`- **${patternId}**: ${count} occurrence(s)`);
    }
    lines.push("");
    lines.push(`See \`violations.jsonl\` for full entries.`);
  }
  lines.push("");

  // ── Anti-cheat Warnings
  const warnings = input.warnings ?? {};
  lines.push(`## Anti-cheat Warnings`);
  lines.push("");
  if (Object.keys(warnings).length === 0) {
    lines.push(`_No warnings this run._`);
  } else {
    for (const [patternId, count] of Object.entries(warnings)) {
      lines.push(`- **${patternId}**: ${count} occurrence(s) flagged for review`);
    }
  }
  lines.push("");

  // ── Performance
  if (input.performance) {
    lines.push(`## Performance`);
    lines.push("");
    const p = input.performance;
    if (p.baselineStrykerMs !== undefined) {
      lines.push(`- Full baseline Stryker: ${prettyMs(p.baselineStrykerMs)}`);
    }
    if (p.medianIterationMs !== undefined || p.maxIterationMs !== undefined) {
      lines.push(
        `- Per-iteration incremental Stryker: median ${prettyMs(p.medianIterationMs ?? 0)}, max ${prettyMs(p.maxIterationMs ?? 0)}`,
      );
    }
    if (p.fixerInvocations !== undefined) {
      lines.push(`- Total fixer invocations: ${p.fixerInvocations}`);
    }
    if (p.fixerRuntimeMs !== undefined) {
      lines.push(`- Total fixer runtime: ${prettyMs(p.fixerRuntimeMs)}`);
    }
    if (input.releaseResult) {
      lines.push(
        `- Release gate runner: ${prettyMs(input.releaseResult.durationMs)}`,
      );
    }
    lines.push("");
  }

  // ── Next Actions (rule-based)
  lines.push(`## Next Actions`);
  lines.push("");
  const actions = buildNextActions(
    input,
    greens,
    blocked,
    integrityBreaches,
    violationsCount,
    warnings,
  );
  for (const action of actions) lines.push(`- ${action}`);
  lines.push("");

  return lines.join("\n");
}

// ─── helpers ─────────────────────────────────────────────────────────────────

function verdictBadge(
  input: SummaryInput,
  greens: number,
  blocked: number,
  violations: number,
  integrity: number,
): string {
  if (integrity > 0) return `❌ CONTRACT TAMPERED (${integrity})`;
  if (input.releaseResult?.verdict === "HARD") return `❌ HARD (release gate integrity breach)`;
  if (input.releaseResult?.verdict === "RED") return `🔴 RED (release gate failure)`;
  if (blocked > 0) return `🟡 ${greens} GREEN · ${blocked} BLOCKED`;
  if (violations > 0 || input.releaseResult?.verdict === "WARN") {
    return `🟡 ${greens} GREEN · warnings present`;
  }
  return `🟢 ${greens} GREEN`;
}

function formatScore(score: number | undefined): string {
  if (score === undefined || score === null) return "n/a";
  return `${score.toFixed(1)}%`;
}

function formatDelta(before?: number, after?: number): string {
  if (before === undefined || after === undefined) return "n/a";
  const delta = after - before;
  if (delta === 0) return "0";
  const sign = delta > 0 ? "+" : "";
  return `${sign}${delta.toFixed(1)}pp`;
}

function prettyDuration(startedAt: string, endedAt: string): string {
  const ms = Math.max(0, new Date(endedAt).getTime() - new Date(startedAt).getTime());
  return prettyMs(ms);
}

function prettyMs(ms: number): string {
  if (ms < 1000) return `${ms}ms`;
  const s = ms / 1000;
  if (s < 60) return `${s.toFixed(1)}s`;
  const m = Math.floor(s / 60);
  const rem = Math.round(s - m * 60);
  return `${m}m ${rem}s`;
}

function collectModulesForFeature(
  feature: FeatureLoopResult,
  state: StateJson,
): Array<{ path: string; score: number; tier: string; floor: number | null }> {
  // Pull modules whose `declared_in_contract` matches the feature id OR
  // modules that the feature's attempts produced. For Phase 4 we use the
  // simpler approach: filter by declared_in_contract.
  const out: Array<{ path: string; score: number; tier: string; floor: number | null }> = [];
  for (const [path, baseline] of Object.entries(state.modules)) {
    if (baseline.declared_in_contract !== feature.featureId) continue;
    out.push({
      path,
      score: baseline.mutation_baseline,
      tier: baseline.tier,
      floor: tierFloor(baseline.tier),
    });
  }
  return out;
}

function tierFloor(tier: string): number | null {
  if (tier === "critical_75") return 75;
  if (tier === "business_60") return 60;
  return null;
}

function computeBaselineChanges(
  starting: StateJson | undefined,
  ending: StateJson,
): Array<{ module: string; previous: number | undefined; current: number; source: string }> {
  if (!starting) return [];
  const changes: Array<{ module: string; previous: number | undefined; current: number; source: string }> = [];
  for (const [module, endBaseline] of Object.entries(ending.modules)) {
    const startBaseline = starting.modules[module];
    if (!startBaseline) {
      changes.push({
        module,
        previous: undefined,
        current: endBaseline.mutation_baseline,
        source: "new module",
      });
      continue;
    }
    if (startBaseline.mutation_baseline === endBaseline.mutation_baseline) continue;
    changes.push({
      module,
      previous: startBaseline.mutation_baseline,
      current: endBaseline.mutation_baseline,
      source:
        endBaseline.mutation_baseline > startBaseline.mutation_baseline
          ? "ratchet up"
          : "reset",
    });
  }
  return changes;
}

function collectRecentResets(
  log: BaselineResetEntry[],
  input: SummaryInput,
): BaselineResetEntry[] {
  const sessionStart = new Date(input.startedAt).getTime();
  return log.filter((e) => new Date(e.timestamp).getTime() >= sessionStart);
}

function groupViolationsByPattern(
  entries: ViolationEntry[],
): Record<string, number> {
  const out: Record<string, number> = {};
  for (const entry of entries) {
    for (const v of entry.violations) {
      out[v.pattern_id] = (out[v.pattern_id] ?? 0) + 1;
    }
  }
  return out;
}

function buildNextActions(
  input: SummaryInput,
  greens: FeatureLoopResult[],
  blocked: FeatureLoopResult[],
  integrityBreaches: FeatureLoopResult[],
  violationsCount: number,
  warnings: Record<string, number>,
): string[] {
  const actions: string[] = [];

  for (const b of blocked) {
    actions.push(
      `Review BLOCKED feature \`${b.featureId}\`: ${b.blockedReason ?? "unknown"}`,
    );
  }
  if (integrityBreaches.length > 0) {
    actions.push(
      `**Contract tamper detected** — investigate \`.quality/contracts/\` and rebase before next run`,
    );
  }
  if (violationsCount > 0) {
    actions.push(
      `${violationsCount} violation(s) detected — review \`violations.jsonl\``,
    );
  }
  if (Object.keys(warnings).length > 0) {
    const total = Object.values(warnings).reduce((a, b) => a + b, 0);
    actions.push(`${total} anti-cheat warning(s) for manual review`);
  }
  if (input.releaseResult?.verdict === "RED") {
    actions.push(
      `Release gates RED: ${input.releaseResult.failedGates.join(", ")} — block release until addressed`,
    );
  } else if (input.releaseResult?.verdict === "WARN") {
    actions.push(
      `Release gates WARN (non-blocking): review ${input.releaseResult.warnGates.join(", ")}`,
    );
  } else if (input.releaseResult?.verdict === "HARD") {
    actions.push(
      `Release gate HARD failure: contract integrity breach — do not ship`,
    );
  }
  if (
    blocked.length === 0 &&
    integrityBreaches.length === 0 &&
    violationsCount === 0 &&
    (input.releaseResult?.verdict === "GREEN" || !input.releaseResult)
  ) {
    if (greens.length > 0) {
      actions.push(`No blockers. Safe to continue.`);
    } else {
      actions.push(`No features attempted and nothing failed — check configuration.`);
    }
  }
  return actions;
}
