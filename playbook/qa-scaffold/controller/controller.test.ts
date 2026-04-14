import { promises as fs } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { randomBytes, createHash } from "node:crypto";
import yaml from "js-yaml";
import { afterEach, beforeEach, describe, expect, test } from "vitest";
import {
  applyCategoryGate,
  buildCli,
  buildSummary,
  generateRunId,
  loadAllContracts,
  runBaselineReset,
  runClean,
  runSession,
} from "./controller.js";
import {
  applyMutationMeasurement,
  initializeState,
  readState,
  writeState,
} from "./state-manager.js";
import type { CommandOutcome, RunCommandFn } from "./gates/base.js";
import type { ContractIndex, TierConfig } from "./types.js";

let root: string;

beforeEach(async () => {
  root = join(tmpdir(), `ctrl-${randomBytes(6).toString("hex")}`);
  await fs.mkdir(join(root, ".quality", "policies"), { recursive: true });
  await fs.mkdir(join(root, ".quality", "contracts"), { recursive: true });
});

afterEach(async () => {
  try {
    await fs.rm(root, { recursive: true, force: true });
  } catch {
    /* noop */
  }
});

function hashEmpty(): string {
  return `sha256:${createHash("sha256").update("").digest("hex")}`;
}

function makeContract(
  id: string,
  overrides: Partial<ContractIndex["feature"]> = {},
): ContractIndex {
  return {
    schema_version: 1,
    feature: {
      id,
      title: id,
      tier: "critical_75",
      category: "auth",
      status: "frozen",
      security_sensitive: true,
      ...overrides,
    },
    approval: { approved_by: "t", approved_at: "2026-04-14T22:00:00Z" },
    source_docs: [],
    artifacts: {
      examples: "examples.md",
      counterexamples: "counterexamples.md",
      invariants: "invariants.md",
      acceptance_tests: "acceptance.spec.ts",
      regression_tests: "regressions.spec.ts",
      api_contract: null,
    },
    counts: {
      examples: 1,
      counterexamples: 0,
      invariants: 0,
      acceptance_tests: 1,
      regression_tests: 0,
    },
    affected_modules: ["src/**"],
    test_data: { seeded_users: [], requires_services: [] },
    hashes: {
      "examples.md": hashEmpty(),
      "acceptance.spec.ts": hashEmpty(),
    },
    version: 1,
    version_history: [
      {
        version: 1,
        date: "2026-04-14",
        approved_by: "t",
        reason: "initial",
        authoring_mode: "source_denied",
        baseline_reset_triggered: false,
      },
    ],
  };
}

async function writeContractOnDisk(id: string, contract: ContractIndex): Promise<void> {
  const dir = join(root, ".quality", "contracts", id);
  await fs.mkdir(dir, { recursive: true });
  await fs.writeFile(join(dir, "examples.md"), "");
  await fs.writeFile(join(dir, "acceptance.spec.ts"), "");
  await fs.writeFile(join(dir, "index.yaml"), yaml.dump(contract));
}

async function writeTiers(): Promise<void> {
  const tiers: TierConfig = {
    schema_version: 1,
    tiers: {
      critical_75: ["src/**"],
      business_60: [],
      ui_gates_only: [],
    },
    unclassified_behavior: "fail_fast",
  };
  await fs.writeFile(
    join(root, ".quality", "policies", "tiers.yaml"),
    yaml.dump(tiers),
  );
}

// ─── applyCategoryGate ────────────────────────────────────────────────────────

describe("applyCategoryGate", () => {
  test("security-sensitive frozen → included", () => {
    const c = makeContract("auth-login", { category: "auth", status: "frozen" });
    expect(applyCategoryGate([c])).toHaveLength(1);
  });

  test("security-sensitive draft → HARD ERROR", () => {
    const c = makeContract("auth-login", { category: "auth", status: "draft" });
    expect(() => applyCategoryGate([c])).toThrow(/HARD ERROR/);
  });

  test("non-critical draft → skipped silently", () => {
    const c = makeContract("other-feature", {
      category: "business_logic",
      status: "draft",
      security_sensitive: false,
    });
    expect(applyCategoryGate([c])).toHaveLength(0);
  });

  test("featureId filter applies", () => {
    const a = makeContract("feat-a");
    const b = makeContract("feat-b");
    expect(applyCategoryGate([a, b], { featureId: "feat-b" })).toHaveLength(1);
  });

  test("category filter applies", () => {
    const a = makeContract("feat-a", { category: "auth" });
    const b = makeContract("feat-b", { category: "payments" });
    expect(applyCategoryGate([a, b], { category: "payments" })).toHaveLength(1);
  });
});

// ─── loadAllContracts ────────────────────────────────────────────────────────

describe("loadAllContracts", () => {
  test("loads every valid contract; skips invalid", async () => {
    await writeContractOnDisk("feat-a", makeContract("feat-a"));
    await writeContractOnDisk("feat-b", makeContract("feat-b"));

    // Broken contract
    const brokenDir = join(root, ".quality", "contracts", "broken");
    await fs.mkdir(brokenDir, { recursive: true });
    await fs.writeFile(
      join(brokenDir, "index.yaml"),
      "schema_version: 999",
    );

    const contracts = await loadAllContracts(
      join(root, ".quality", "contracts"),
    );
    const ids = contracts.map((c) => c.feature.id);
    expect(ids).toContain("feat-a");
    expect(ids).toContain("feat-b");
    expect(ids).not.toContain("broken");
  });

  test("empty directory returns []", async () => {
    const contracts = await loadAllContracts(
      join(root, ".quality", "contracts"),
    );
    expect(contracts).toEqual([]);
  });

  test("missing directory returns []", async () => {
    const contracts = await loadAllContracts(
      join(root, ".quality", "missing"),
    );
    expect(contracts).toEqual([]);
  });
});

// ─── generateRunId ────────────────────────────────────────────────────────────

describe("generateRunId", () => {
  test("matches run-id pattern", () => {
    const id = generateRunId();
    expect(id).toMatch(/^run-[0-9a-zA-Z_-]+$/);
  });

  test("produces distinct ids across calls", () => {
    const ids = new Set(
      Array.from({ length: 20 }, () => generateRunId()),
    );
    expect(ids.size).toBeGreaterThan(5);
  });
});

// ─── buildSummary ────────────────────────────────────────────────────────────

describe("buildSummary", () => {
  test("contains the expected sections", () => {
    const md = buildSummary({
      runId: "run-abc",
      startedAt: "2026-04-14T21:30:00Z",
      endedAt: "2026-04-14T22:45:00Z",
      featureResults: [],
      state: initializeState("2026-04-14T21:30:00Z"),
      baselineScore: 70,
      violationsCount: 0,
    });
    expect(md).toContain("# QA Run Summary — run-abc");
    expect(md).toContain("## Verdict");
    expect(md).toContain("## Contract Integrity");
    expect(md).toContain("## Features");
    expect(md).toContain("## Next Actions");
  });

  test("flags CONTRACT_TAMPERED when a feature blocked with integrity reason", () => {
    const md = buildSummary({
      runId: "run-1",
      startedAt: "2026-04-14T21:30:00Z",
      endedAt: "2026-04-14T22:45:00Z",
      featureResults: [
        {
          featureId: "auth-login",
          finalOutcome: "BLOCKED",
          attempts: [],
          violationEntries: [],
          state: initializeState("2026-04-14T21:30:00Z"),
          plateauBuffer: [],
          priorAttemptSummaries: [],
          startedAt: "2026-04-14T21:30:00Z",
          endedAt: "2026-04-14T21:31:00Z",
          blockedReason: "integrity breach: contract-hash-verify failed",
        },
      ],
      state: initializeState("2026-04-14T21:30:00Z"),
      baselineScore: undefined,
      violationsCount: 0,
    });
    expect(md).toContain("CONTRACT_TAMPERED");
    expect(md).toContain("auth-login");
  });

  test("happy path says all hashes intact", () => {
    const md = buildSummary({
      runId: "run-1",
      startedAt: "2026-04-14T21:30:00Z",
      endedAt: "2026-04-14T22:45:00Z",
      featureResults: [
        {
          featureId: "auth-login",
          finalOutcome: "GREEN",
          attempts: [],
          violationEntries: [],
          state: initializeState("2026-04-14T21:30:00Z"),
          plateauBuffer: [],
          priorAttemptSummaries: [],
          startedAt: "2026-04-14T21:30:00Z",
          endedAt: "2026-04-14T22:45:00Z",
        },
      ],
      state: initializeState("2026-04-14T21:30:00Z"),
      baselineScore: undefined,
      violationsCount: 0,
    });
    expect(md).toContain("All contract hashes verified intact");
  });
});

// ─── runBaselineReset ────────────────────────────────────────────────────────

describe("runBaselineReset", () => {
  test("applies reset + writes state.json with audit entry", async () => {
    let state = initializeState("2026-04-14T22:00:00Z");
    state = applyMutationMeasurement({
      state,
      modulePath: "src/auth/login.ts",
      newScore: 80,
      tier: "critical_75",
      runId: "run-0",
      timestamp: "2026-04-14T22:00:00Z",
    }).state;
    await writeState(join(root, ".quality", "state.json"), state);

    await runBaselineReset({
      workingDir: root,
      module: "src/auth/login.ts",
      reason: "Refactor per PRD v2",
      newBaseline: 60,
      approvedBy: "shailesh",
    });

    const updated = await readState(join(root, ".quality", "state.json"));
    expect(updated.modules["src/auth/login.ts"]?.mutation_baseline).toBe(60);
    expect(updated.baseline_reset_log).toHaveLength(1);
    expect(updated.baseline_reset_log[0]?.reason).toBe("Refactor per PRD v2");
  });

  test("refuses empty reason", async () => {
    await writeState(
      join(root, ".quality", "state.json"),
      applyMutationMeasurement({
        state: initializeState("2026-04-14T22:00:00Z"),
        modulePath: "src/a.ts",
        newScore: 70,
        tier: "business_60",
        runId: "run-0",
        timestamp: "2026-04-14T22:00:00Z",
      }).state,
    );
    await expect(
      runBaselineReset({
        workingDir: root,
        module: "src/a.ts",
        reason: "",
        newBaseline: 50,
        approvedBy: "x",
      }),
    ).rejects.toThrow();
  });
});

// ─── runClean ────────────────────────────────────────────────────────────────

describe("runClean", () => {
  test("clears stale lock", async () => {
    const lockPath = join(root, ".quality", "state.lock");
    await fs.writeFile(
      lockPath,
      JSON.stringify({
        pid: 999999,
        run_id: "run-old",
        acquired_at: "2026-04-14T22:00:00Z",
        host: (await import("node:os")).hostname(),
        qa_controller_version: "0.1.0",
      }),
    );
    const result = await runClean({
      workingDir: root,
      pidAlive: () => false,
    });
    expect(result.staleLockCleared).toBe(true);
  });

  test("archives heavy artifacts from old runs", async () => {
    const oldRunDir = join(root, ".quality", "runs", "run-old");
    const evidenceDir = join(oldRunDir, "evidence");
    await fs.mkdir(evidenceDir, { recursive: true });
    await fs.writeFile(join(evidenceDir, "big.log"), "x".repeat(100));
    await fs.writeFile(join(oldRunDir, "summary.md"), "old");

    // Force mtime 60 days old
    const oldDate = new Date(Date.now() - 60 * 24 * 3600 * 1000);
    await fs.utimes(oldRunDir, oldDate, oldDate);

    const result = await runClean({
      workingDir: root,
      retentionDays: 30,
      pidAlive: () => true,
    });
    expect(result.archivedRuns).toContain("run-old");
    const evidenceGone = await fs
      .access(evidenceDir)
      .then(() => false)
      .catch(() => true);
    expect(evidenceGone).toBe(true);
    // But summary is retained
    const summaryStill = await fs
      .access(join(oldRunDir, "summary.md"))
      .then(() => true)
      .catch(() => false);
    expect(summaryStill).toBe(true);
  });

  test("retains recent runs", async () => {
    const recent = join(root, ".quality", "runs", "run-recent");
    await fs.mkdir(join(recent, "evidence"), { recursive: true });
    await fs.writeFile(join(recent, "summary.md"), "recent");

    const result = await runClean({
      workingDir: root,
      retentionDays: 30,
      pidAlive: () => true,
    });
    expect(result.retainedRuns).toContain("run-recent");
  });
});

// ─── buildCli ─────────────────────────────────────────────────────────────────

describe("buildCli", () => {
  test("registers all documented subcommands", () => {
    const cli = buildCli();
    const names = cli.commands.map((c) => c.name()).sort();
    expect(names).toEqual(
      [
        "audit-violations",
        "baseline",
        "baseline-reset",
        "clean",
        "doctor",
        "report",
        "run",
        "status",
        "unblock",
      ].sort(),
    );
  });
});

// ─── runSession smoke (integration-light) ────────────────────────────────────

describe("runSession — category gate hard error", () => {
  test("throws when security-sensitive contract is not frozen", async () => {
    await writeContractOnDisk(
      "payment-x",
      makeContract("payment-x", { category: "payments", status: "draft" }),
    );
    await writeTiers();
    await expect(
      runSession({
        workingDir: root,
        runId: "run-test-1",
        runCommand: async () => ({
          exitCode: 0,
          stdout: "",
          stderr: "",
          durationMs: 5,
          timedOut: false,
        }),
        skipBaselineStryker: true,
        noNotification: true,
      }),
    ).rejects.toThrow(/HARD ERROR/);
  });
});

describe("runSession — empty contracts → clean session", () => {
  test("no contracts → writes empty summary", async () => {
    await writeTiers();
    const result = await runSession({
      workingDir: root,
      runId: "run-test-2",
      runCommand: async (cmd, args) => {
        // git status returns empty (clean tree)
        if (cmd === "git" && args[0] === "status") {
          return { exitCode: 0, stdout: "", stderr: "", durationMs: 5, timedOut: false };
        }
        return { exitCode: 0, stdout: "", stderr: "", durationMs: 5, timedOut: false };
      },
      skipBaselineStryker: true,
      noNotification: true,
    });
    expect(result.runId).toBe("run-test-2");
    expect(result.featuresAttempted).toEqual([]);
    const summaryExists = await fs
      .access(result.summaryPath)
      .then(() => true)
      .catch(() => false);
    expect(summaryExists).toBe(true);
  });
});

// Silence unused helper export for types
void (null as unknown as CommandOutcome);
void (null as unknown as RunCommandFn);
