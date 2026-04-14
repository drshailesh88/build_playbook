/**
 * state-delta writer.
 *
 * Computes the diff between a snapshot of state.json taken at session start
 * vs the state at session end. Writes a structured JSON delta to
 * `.quality/runs/<run-id>/state-delta.json` for audit + downstream tooling.
 *
 * The delta is intentionally shallow and additive — enough signal for the
 * report layer, not a full structural diff. Fields:
 *
 *   - runId
 *   - timestamps
 *   - modulesAdded / modulesRemoved / modulesChanged
 *   - featuresAdded / featuresRemoved / featuresChanged (status delta)
 *   - baselineResetLogGrowth (entries added this session)
 *   - testCountHistoryGrowth (new values appended per runner)
 *   - runRecordAdded (the new run entry, if any)
 */
import { promises as fs } from "node:fs";
import { dirname } from "node:path";
import type { RunId, StateJson } from "../types.js";

export interface ModuleChange {
  path: string;
  previous: { mutation_baseline: number; tier: string } | null;
  current: { mutation_baseline: number; tier: string } | null;
}

export interface FeatureStatusChange {
  id: string;
  previous: string | null;
  current: string | null;
}

export interface StateDelta {
  schema_version: 1;
  run_id: RunId;
  computed_at: string;
  modulesAdded: ModuleChange[];
  modulesRemoved: ModuleChange[];
  modulesChanged: ModuleChange[];
  featuresAdded: FeatureStatusChange[];
  featuresRemoved: FeatureStatusChange[];
  featuresChanged: FeatureStatusChange[];
  baselineResetLogGrowth: number;
  testCountHistoryGrowth: {
    vitest_unit: number;
    vitest_integration: number;
    playwright: number;
  };
  runRecordAdded: boolean;
}

export interface BuildDeltaInput {
  runId: RunId;
  startingState: StateJson | undefined;
  endingState: StateJson;
}

export function buildStateDelta(input: BuildDeltaInput): StateDelta {
  const starting = input.startingState;
  const ending = input.endingState;
  const delta: StateDelta = {
    schema_version: 1,
    run_id: input.runId,
    computed_at: new Date().toISOString(),
    modulesAdded: [],
    modulesRemoved: [],
    modulesChanged: [],
    featuresAdded: [],
    featuresRemoved: [],
    featuresChanged: [],
    baselineResetLogGrowth: 0,
    testCountHistoryGrowth: {
      vitest_unit: 0,
      vitest_integration: 0,
      playwright: 0,
    },
    runRecordAdded: false,
  };

  if (!starting) {
    // Whole state is "new" to this session.
    for (const [path, baseline] of Object.entries(ending.modules)) {
      delta.modulesAdded.push({
        path,
        previous: null,
        current: {
          mutation_baseline: baseline.mutation_baseline,
          tier: baseline.tier,
        },
      });
    }
    for (const [id, feat] of Object.entries(ending.features)) {
      delta.featuresAdded.push({
        id,
        previous: null,
        current: feat.status,
      });
    }
    delta.baselineResetLogGrowth = ending.baseline_reset_log.length;
    delta.testCountHistoryGrowth = {
      vitest_unit: ending.test_count_history.vitest_unit.length,
      vitest_integration: ending.test_count_history.vitest_integration.length,
      playwright: ending.test_count_history.playwright.length,
    };
    delta.runRecordAdded = ending.runs[input.runId] !== undefined;
    return delta;
  }

  // Modules
  for (const [path, baseline] of Object.entries(ending.modules)) {
    const prev = starting.modules[path];
    const curr = {
      mutation_baseline: baseline.mutation_baseline,
      tier: baseline.tier,
    };
    if (!prev) {
      delta.modulesAdded.push({ path, previous: null, current: curr });
      continue;
    }
    if (
      prev.mutation_baseline !== baseline.mutation_baseline ||
      prev.tier !== baseline.tier
    ) {
      delta.modulesChanged.push({
        path,
        previous: { mutation_baseline: prev.mutation_baseline, tier: prev.tier },
        current: curr,
      });
    }
  }
  for (const [path, prev] of Object.entries(starting.modules)) {
    if (!ending.modules[path]) {
      delta.modulesRemoved.push({
        path,
        previous: { mutation_baseline: prev.mutation_baseline, tier: prev.tier },
        current: null,
      });
    }
  }

  // Features
  for (const [id, feat] of Object.entries(ending.features)) {
    const prev = starting.features[id];
    if (!prev) {
      delta.featuresAdded.push({ id, previous: null, current: feat.status });
      continue;
    }
    if (prev.status !== feat.status) {
      delta.featuresChanged.push({
        id,
        previous: prev.status,
        current: feat.status,
      });
    }
  }
  for (const [id, prev] of Object.entries(starting.features)) {
    if (!ending.features[id]) {
      delta.featuresRemoved.push({
        id,
        previous: prev.status,
        current: null,
      });
    }
  }

  // Reset log growth
  delta.baselineResetLogGrowth =
    ending.baseline_reset_log.length - starting.baseline_reset_log.length;

  // Test count growth
  delta.testCountHistoryGrowth = {
    vitest_unit:
      ending.test_count_history.vitest_unit.length -
      starting.test_count_history.vitest_unit.length,
    vitest_integration:
      ending.test_count_history.vitest_integration.length -
      starting.test_count_history.vitest_integration.length,
    playwright:
      ending.test_count_history.playwright.length -
      starting.test_count_history.playwright.length,
  };

  // Run record
  delta.runRecordAdded =
    ending.runs[input.runId] !== undefined &&
    starting.runs[input.runId] === undefined;

  return delta;
}

export async function writeStateDelta(
  path: string,
  delta: StateDelta,
): Promise<string> {
  await fs.mkdir(dirname(path), { recursive: true });
  await fs.writeFile(path, JSON.stringify(delta, null, 2));
  return path;
}
