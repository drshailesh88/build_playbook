/**
 * Release gate — deterministic completeness fitness.
 *
 * Runs the completeness extractor against the target app and fails when any
 * structural completeness fitness check fails.
 */
import { buildGateResult, writeEvidence, type GateConfig } from "./base.js";
import type { GateResult } from "../types.js";
import { extractCompletenessIs } from "../completeness/extract-is.mjs";

export const COMPLETENESS_FITNESS_GATE_ID = "completeness-fitness";

export interface CompletenessFitnessGateInput {
  config: GateConfig;
}

export async function runCompletenessFitnessGate(
  input: CompletenessFitnessGateInput,
): Promise<GateResult> {
  const start = Date.now();
  try {
    const { isList, evidence } = await extractCompletenessIs({
      root: input.config.workingDir,
    });

    const hasTrackedSurface =
      isList.apiEndpoints.length > 0 ||
      isList.serverActions.length > 0 ||
      isList.uiPages.length > 0 ||
      isList.drizzleArtifacts.length > 0;

    if (!hasTrackedSurface) {
      const skippedPath = await writeEvidence(
        input.config.evidenceDir,
        COMPLETENESS_FITNESS_GATE_ID,
        "report.json",
        JSON.stringify(
          {
            schemaVersion: 1,
            skipped: true,
            reason: "no app router, server action, page, or drizzle surface detected",
          },
          null,
          2,
        ),
      );
      return buildGateResult({
        gateId: COMPLETENESS_FITNESS_GATE_ID,
        status: "skipped",
        durationMs: Date.now() - start,
        details: {
          skipped: true,
          reason: "no tracked completeness surface detected",
        },
        artifacts: [skippedPath],
        shortCircuit: false,
      });
    }

    const failingChecks = evidence.fitnessChecks.filter(
      (check: { passed: boolean }) => !check.passed,
    );
    const reportPath = await writeEvidence(
      input.config.evidenceDir,
      COMPLETENESS_FITNESS_GATE_ID,
      "report.json",
      JSON.stringify(
        {
          schemaVersion: 1,
          generatedAt: new Date().toISOString(),
          summary: isList.summaries,
          warnings: evidence.warnings,
          failingChecks,
          allChecks: evidence.fitnessChecks,
        },
        null,
        2,
      ),
    );

    return buildGateResult({
      gateId: COMPLETENESS_FITNESS_GATE_ID,
      status: failingChecks.length === 0 ? "pass" : "fail",
      durationMs: Date.now() - start,
      details: {
        summary: isList.summaries,
        failingChecksCount: failingChecks.length,
        failingCheckIds: failingChecks.map((check: { id: string }) => check.id),
      },
      artifacts: [reportPath],
      shortCircuit: false,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    const errorPath = await writeEvidence(
      input.config.evidenceDir,
      COMPLETENESS_FITNESS_GATE_ID,
      "error.json",
      JSON.stringify({ error: message }, null, 2),
    );
    return buildGateResult({
      gateId: COMPLETENESS_FITNESS_GATE_ID,
      status: "error",
      durationMs: Date.now() - start,
      details: { error: message },
      artifacts: [errorPath],
      shortCircuit: false,
    });
  }
}
