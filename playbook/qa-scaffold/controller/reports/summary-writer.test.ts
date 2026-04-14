import { promises as fs } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { randomBytes } from "node:crypto";
import { afterEach, beforeEach, describe, expect, test } from "vitest";
import { renderSummary, writeSummary } from "./summary-writer.js";
import {
  applyMutationMeasurement,
  initializeState,
  markFeatureGreen,
  markFeatureBlocked,
} from "../state-manager.js";
import type { FeatureLoopResult } from "../feature-loop.js";
import type { ReleaseResult } from "../gates/release-runner.js";
import type { ViolationEntry } from "../types.js";

let root: string;
beforeEach(async () => {
  root = join(tmpdir(), `summary-${randomBytes(6).toString("hex")}`);
  await fs.mkdir(root, { recursive: true });
});
afterEach(async () => {
  try {
    await fs.rm(root, { recursive: true, force: true });
  } catch {
    /* noop */
  }
});

const NOW = "2026-04-14T22:00:00Z";

function greenFeature(id: string): FeatureLoopResult {
  return {
    featureId: id,
    finalOutcome: "GREEN",
    attempts: [{} as any, {} as any],
    violationEntries: [],
    state: initializeState(NOW),
    plateauBuffer: ["a".repeat(16)],
    priorAttemptSummaries: [],
    startedAt: NOW,
    endedAt: NOW,
  };
}

function blockedFeature(id: string, reason: string): FeatureLoopResult {
  return {
    featureId: id,
    finalOutcome: "BLOCKED",
    attempts: [{} as any],
    violationEntries: [],
    state: initializeState(NOW),
    plateauBuffer: ["b".repeat(16)],
    priorAttemptSummaries: [],
    startedAt: NOW,
    endedAt: NOW,
    blockedReason: reason,
  };
}

describe("renderSummary — structure", () => {
  test("includes all mandatory sections", () => {
    const md = renderSummary({
      runId: "run-abc",
      startedAt: "2026-04-14T21:30:00Z",
      endedAt: "2026-04-14T22:45:00Z",
      controllerVersion: "0.1.0",
      featureResults: [],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("# QA Run Summary — run-abc");
    expect(md).toContain("## Verdict");
    expect(md).toContain("## Contract Integrity");
    expect(md).toContain("## Features");
    expect(md).toContain("## Violations Detected");
    expect(md).toContain("## Anti-cheat Warnings");
    expect(md).toContain("## Next Actions");
  });

  test("header renders session metadata", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: "2026-04-14T21:30:00Z",
      endedAt: "2026-04-14T22:00:00Z",
      controllerVersion: "0.1.0",
      triggeredBy: "npm run qa run",
      previousRunId: "run-prev",
      featureResults: [],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("Triggered by:** npm run qa run");
    expect(md).toContain("Previous run:** run-prev");
    expect(md).toContain("30m 0s"); // 30-minute duration
  });
});

describe("renderSummary — verdict variants", () => {
  test("all green → GREEN badge", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [greenFeature("auth-login"), greenFeature("billing")],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toMatch(/🟢.*2 GREEN/);
  });

  test("blocked feature → yellow badge", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [
        greenFeature("auth-login"),
        blockedFeature("payment", "plateau"),
      ],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toMatch(/🟡.*1 GREEN.*1 BLOCKED/);
  });

  test("integrity breach → CONTRACT TAMPERED", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [
        blockedFeature("auth-login", "integrity breach: contract-hash-verify failed"),
      ],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("CONTRACT TAMPERED");
  });

  test("release gate RED → RED badge overrides success", () => {
    const release: ReleaseResult = {
      gateResults: [],
      verdict: "RED",
      verdictReason: "primary gate(s) failed: vitest-all",
      failedGates: ["vitest-all"],
      warnGates: [],
      startedAt: NOW,
      endedAt: NOW,
      durationMs: 1000,
    };
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [greenFeature("auth-login")],
      violationEntries: [],
      state: initializeState(NOW),
      releaseResult: release,
    });
    expect(md).toMatch(/🔴.*RED/);
    expect(md).toContain("Release gates:");
  });
});

describe("renderSummary — Contract Integrity section", () => {
  test("happy path affirmative statement", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [greenFeature("auth-login")],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("All contract hashes verified intact");
  });

  test("flags integrity breach features", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [
        blockedFeature("auth-login", "integrity breach: contract-hash-verify failed"),
      ],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("❌ 1 feature(s) flagged CONTRACT_TAMPERED");
  });
});

describe("renderSummary — Baseline → Final table", () => {
  test("shows mutation score table when scores provided", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [],
      violationEntries: [],
      state: initializeState(NOW),
      baselineStrykerScore: 65,
      finalStrykerScore: 78,
    });
    expect(md).toContain("| Metric | Baseline | Final | Delta |");
    expect(md).toContain("65.0%");
    expect(md).toContain("78.0%");
    expect(md).toContain("+13.0pp");
  });

  test("section omitted when no scores", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).not.toContain("Baseline → Final");
  });
});

describe("renderSummary — Features section", () => {
  test("per-feature block renders plateau signature + blocked reason", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [blockedFeature("payment", "plateau: 3 consecutive")],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("🔴 payment — BLOCKED");
    expect(md).toContain("Blocked reason:** plateau");
    expect(md).toContain("Last signature:");
  });

  test("includes per-module mutation scores when available", () => {
    let state = initializeState(NOW);
    state = applyMutationMeasurement({
      state,
      modulePath: "src/auth/login.ts",
      newScore: 80,
      tier: "critical_75",
      runId: "run-1",
      timestamp: NOW,
      contractFeatureId: "auth-login",
    }).state;

    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [greenFeature("auth-login")],
      violationEntries: [],
      state,
    });
    expect(md).toContain("src/auth/login.ts");
    expect(md).toContain("80%");
    expect(md).toContain("critical_75");
    expect(md).toContain("floor 75%");
  });

  test("no features → 'No features attempted' placeholder", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("_No features attempted this run._");
  });
});

describe("renderSummary — Violations section", () => {
  test("groups violations by pattern ID with counts", () => {
    const violations: ViolationEntry[] = [
      {
        run_id: "run-1",
        feature_id: "auth-login",
        attempt: 1,
        detected_at: NOW,
        provider: "claude",
        violations: [
          { pattern_id: "SKIP_ADDED", severity: "reject", file: "a.test.ts", detected_at: NOW },
          { pattern_id: "SKIP_ADDED", severity: "reject", file: "b.test.ts", detected_at: NOW },
          { pattern_id: "EXPECT_REMOVED_NET", severity: "reject", file: "c.test.ts", detected_at: NOW },
        ],
        reverted_paths: [],
      },
    ];
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [],
      violationEntries: violations,
      state: initializeState(NOW),
    });
    expect(md).toContain("**SKIP_ADDED**: 2 occurrence(s)");
    expect(md).toContain("**EXPECT_REMOVED_NET**: 1 occurrence(s)");
  });

  test("no violations → 'None this run'", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("_None this run._");
  });
});

describe("renderSummary — Next Actions (rule-based)", () => {
  test("blocked feature → review action", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [blockedFeature("payment", "plateau detected")],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("Review BLOCKED feature `payment`");
  });

  test("clean run → 'No blockers. Safe to continue'", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [greenFeature("auth-login")],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("No blockers. Safe to continue.");
  });

  test("integrity breach → tamper warning", () => {
    const md = renderSummary({
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [
        blockedFeature("auth-login", "integrity breach: contract-hash-verify failed"),
      ],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(md).toContain("Contract tamper detected");
  });
});

describe("renderSummary — determinism", () => {
  test("same inputs produce identical output", () => {
    const input = {
      runId: "run-1" as const,
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [greenFeature("auth-login"), blockedFeature("payment", "plateau")],
      violationEntries: [],
      state: initializeState(NOW),
      baselineStrykerScore: 65,
      finalStrykerScore: 78,
    };
    const md1 = renderSummary(input);
    const md2 = renderSummary(input);
    expect(md1).toBe(md2);
  });

  test("no LLM calls anywhere — 100% deterministic", async () => {
    // Trivial check: the module has no imports of provider/LLM code.
    // This test is structural documentation; if someone adds a provider
    // import to summary-writer, they break this test.
    const path = decodeURIComponent(
      new URL("./summary-writer.ts", import.meta.url).pathname,
    );
    const src = await fs.readFile(path, "utf8");
    expect(/provider|claude|codex|gemini/i.test(src)).toBe(false);
  });
});

describe("writeSummary — file output", () => {
  test("creates summary at specified path", async () => {
    const summaryPath = join(root, "summary.md");
    const written = await writeSummary({
      summaryPath,
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(written).toBe(summaryPath);
    const body = await fs.readFile(summaryPath, "utf8");
    expect(body).toContain("# QA Run Summary — run-1");
  });

  test("creates parent directories", async () => {
    const summaryPath = join(root, "nested", "dir", "summary.md");
    await writeSummary({
      summaryPath,
      runId: "run-1",
      startedAt: NOW,
      endedAt: NOW,
      controllerVersion: "0.1.0",
      featureResults: [],
      violationEntries: [],
      state: initializeState(NOW),
    });
    expect(
      await fs
        .access(summaryPath)
        .then(() => true)
        .catch(() => false),
    ).toBe(true);
  });
});

// Silence warning for unused helpers in some TS configurations.
void markFeatureGreen;
void markFeatureBlocked;
