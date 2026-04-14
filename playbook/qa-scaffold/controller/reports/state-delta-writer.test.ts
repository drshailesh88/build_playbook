import { promises as fs } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { randomBytes } from "node:crypto";
import { afterEach, beforeEach, describe, expect, test } from "vitest";
import { buildStateDelta, writeStateDelta } from "./state-delta-writer.js";
import {
  applyMutationMeasurement,
  initializeState,
  markFeatureBlocked,
  markFeatureGreen,
  startRun,
  resetModuleBaseline,
} from "../state-manager.js";

let root: string;
beforeEach(async () => {
  root = join(tmpdir(), `state-delta-${randomBytes(6).toString("hex")}`);
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
const LATER = "2026-04-14T22:30:00Z";

describe("buildStateDelta — empty starting state", () => {
  test("treats entire ending state as 'added'", () => {
    const ending = applyMutationMeasurement({
      state: initializeState(NOW),
      modulePath: "src/a.ts",
      newScore: 80,
      tier: "critical_75",
      runId: "run-1",
      timestamp: NOW,
    }).state;
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: undefined,
      endingState: ending,
    });
    expect(delta.modulesAdded).toHaveLength(1);
    expect(delta.modulesAdded[0]?.path).toBe("src/a.ts");
    expect(delta.modulesRemoved).toEqual([]);
    expect(delta.modulesChanged).toEqual([]);
  });
});

describe("buildStateDelta — module changes", () => {
  test("ratchet-up detected in modulesChanged", () => {
    const starting = applyMutationMeasurement({
      state: initializeState(NOW),
      modulePath: "src/a.ts",
      newScore: 60,
      tier: "critical_75",
      runId: "run-0",
      timestamp: NOW,
    }).state;
    const ending = applyMutationMeasurement({
      state: starting,
      modulePath: "src/a.ts",
      newScore: 75,
      tier: "critical_75",
      runId: "run-1",
      timestamp: LATER,
    }).state;
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: starting,
      endingState: ending,
    });
    expect(delta.modulesChanged).toHaveLength(1);
    expect(delta.modulesChanged[0]?.previous?.mutation_baseline).toBe(60);
    expect(delta.modulesChanged[0]?.current?.mutation_baseline).toBe(75);
  });

  test("new module in ending → modulesAdded", () => {
    const starting = initializeState(NOW);
    const ending = applyMutationMeasurement({
      state: starting,
      modulePath: "src/new.ts",
      newScore: 50,
      tier: "business_60",
      runId: "run-1",
      timestamp: LATER,
    }).state;
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: starting,
      endingState: ending,
    });
    expect(delta.modulesAdded).toHaveLength(1);
    expect(delta.modulesAdded[0]?.path).toBe("src/new.ts");
  });

  test("module absent in ending → modulesRemoved", () => {
    const starting = applyMutationMeasurement({
      state: initializeState(NOW),
      modulePath: "src/gone.ts",
      newScore: 80,
      tier: "critical_75",
      runId: "run-0",
      timestamp: NOW,
    }).state;
    // ending omits the module
    const ending = initializeState(NOW);
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: starting,
      endingState: ending,
    });
    expect(delta.modulesRemoved).toHaveLength(1);
    expect(delta.modulesRemoved[0]?.path).toBe("src/gone.ts");
  });

  test("no module changes → all lists empty", () => {
    const state = applyMutationMeasurement({
      state: initializeState(NOW),
      modulePath: "src/a.ts",
      newScore: 80,
      tier: "critical_75",
      runId: "run-1",
      timestamp: NOW,
    }).state;
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: state,
      endingState: state,
    });
    expect(delta.modulesAdded).toEqual([]);
    expect(delta.modulesRemoved).toEqual([]);
    expect(delta.modulesChanged).toEqual([]);
  });
});

describe("buildStateDelta — feature status", () => {
  test("feature status transition recorded", () => {
    const starting = markFeatureBlocked(
      initializeState(NOW),
      "auth-login",
      { reason: "plateau", signature: "x", timestamp: NOW },
    );
    const ending = markFeatureGreen(starting, "auth-login", "run-1", LATER);
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: starting,
      endingState: ending,
    });
    expect(delta.featuresChanged).toHaveLength(1);
    expect(delta.featuresChanged[0]?.previous).toBe("blocked");
    expect(delta.featuresChanged[0]?.current).toBe("green");
  });

  test("new feature recorded in featuresAdded", () => {
    const starting = initializeState(NOW);
    const ending = markFeatureGreen(starting, "new-feature", "run-1", LATER);
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: starting,
      endingState: ending,
    });
    expect(delta.featuresAdded).toHaveLength(1);
    expect(delta.featuresAdded[0]?.id).toBe("new-feature");
  });
});

describe("buildStateDelta — baseline reset log growth", () => {
  test("counts only entries added this session", () => {
    let starting = applyMutationMeasurement({
      state: initializeState(NOW),
      modulePath: "src/a.ts",
      newScore: 80,
      tier: "critical_75",
      runId: "run-0",
      timestamp: NOW,
    }).state;
    // Pre-existing reset entry
    starting = resetModuleBaseline({
      state: starting,
      modulePath: "src/a.ts",
      newBaseline: 60,
      reason: "old reset",
      triggered_by: "x",
      approved_by: "y",
      timestamp: "2026-04-10T00:00:00Z",
    });
    const ending = resetModuleBaseline({
      state: starting,
      modulePath: "src/a.ts",
      newBaseline: 50,
      reason: "this session's reset",
      triggered_by: "x",
      approved_by: "y",
      timestamp: LATER,
    });
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: starting,
      endingState: ending,
    });
    expect(delta.baselineResetLogGrowth).toBe(1);
  });
});

describe("buildStateDelta — run record + test counts", () => {
  test("run record added this session", () => {
    const starting = initializeState(NOW);
    const ending = startRun(starting, "run-1", NOW);
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: starting,
      endingState: ending,
    });
    expect(delta.runRecordAdded).toBe(true);
  });

  test("test count history growth counted per runner", () => {
    const starting = initializeState(NOW);
    const ending = {
      ...starting,
      test_count_history: {
        vitest_unit: [200, 201, 202],
        vitest_integration: [80],
        playwright: [],
      },
    };
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: starting,
      endingState: ending,
    });
    expect(delta.testCountHistoryGrowth.vitest_unit).toBe(3);
    expect(delta.testCountHistoryGrowth.vitest_integration).toBe(1);
    expect(delta.testCountHistoryGrowth.playwright).toBe(0);
  });
});

describe("writeStateDelta", () => {
  test("writes JSON to the specified path", async () => {
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: initializeState(NOW),
      endingState: initializeState(NOW),
    });
    const out = join(root, "state-delta.json");
    await writeStateDelta(out, delta);
    const body = JSON.parse(await fs.readFile(out, "utf8"));
    expect(body.run_id).toBe("run-1");
    expect(body.schema_version).toBe(1);
  });

  test("creates parent directories", async () => {
    const delta = buildStateDelta({
      runId: "run-1",
      startingState: initializeState(NOW),
      endingState: initializeState(NOW),
    });
    const out = join(root, "nested", "dir", "state-delta.json");
    await writeStateDelta(out, delta);
    expect(
      await fs
        .access(out)
        .then(() => true)
        .catch(() => false),
    ).toBe(true);
  });
});
