/**
 * Release gate — Specmatic contract verification.
 *
 * Uses the Specmatic wrapper from qa/completeness to resolve an OpenAPI spec,
 * optionally generate one, and validate the running app against it.
 */
import { buildGateResult, writeEvidence, type GateConfig } from "./base.js";
import type { GateResult, RunId } from "../types.js";
import { runSpecmaticVerification } from "../completeness/specmatic-ci.mjs";

export const SPECMATIC_CONTRACT_GATE_ID = "specmatic-contract";

export interface SpecmaticContractGateInput {
  config: GateConfig;
  baseUrl?: string;
  specPath?: string;
  generateOpenApiIfMissing?: boolean;
  required?: boolean;
}

export async function runSpecmaticContractGate(
  input: SpecmaticContractGateInput,
): Promise<GateResult> {
  const start = Date.now();
  try {
    const report = await runSpecmaticVerification({
      root: input.config.workingDir,
      baseUrl: input.baseUrl,
      specPath: input.specPath,
      generateIfMissing: input.generateOpenApiIfMissing ?? false,
      outPath: gateReportPathForRun(input.config.runId),
      runCommand: input.config.runCommand,
    });

    const reportPath = await writeEvidence(
      input.config.evidenceDir,
      SPECMATIC_CONTRACT_GATE_ID,
      "report.json",
      JSON.stringify(report, null, 2),
    );

    return buildGateResult({
      gateId: SPECMATIC_CONTRACT_GATE_ID,
      status: report.success ? "pass" : "fail",
      durationMs: Date.now() - start,
      details: {
        success: report.success,
        specPath: report.specPath,
        specSource: report.specSource,
        coverageReportPath: report.coverageReportPath,
      },
      artifacts: [reportPath],
      shortCircuit: false,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    const missingSpec =
      message.includes("No OpenAPI spec found") || message.includes("OpenAPI spec not found");
    if (missingSpec && !input.required) {
      const skippedPath = await writeEvidence(
        input.config.evidenceDir,
        SPECMATIC_CONTRACT_GATE_ID,
        "report.json",
        JSON.stringify(
          {
            skipped: true,
            reason: message,
          },
          null,
          2,
        ),
      );
      return buildGateResult({
        gateId: SPECMATIC_CONTRACT_GATE_ID,
        status: "skipped",
        durationMs: Date.now() - start,
        details: {
          skipped: true,
          reason: message,
        },
        artifacts: [skippedPath],
        shortCircuit: false,
      });
    }

    const errorPath = await writeEvidence(
      input.config.evidenceDir,
      SPECMATIC_CONTRACT_GATE_ID,
      "error.json",
      JSON.stringify({ error: message }, null, 2),
    );
    return buildGateResult({
      gateId: SPECMATIC_CONTRACT_GATE_ID,
      status: "error",
      durationMs: Date.now() - start,
      details: { error: message },
      artifacts: [errorPath],
      shortCircuit: false,
    });
  }
}

function gateReportPathForRun(runId: RunId): string {
  return `.quality/runs/${runId}/evidence/${SPECMATIC_CONTRACT_GATE_ID}/specmatic-report.json`;
}
