import { cp, mkdir } from "node:fs/promises";
import { randomBytes } from "node:crypto";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { afterEach, describe, expect, it, vi } from "vitest";
import {
  runSpecmaticContractGate,
  SPECMATIC_CONTRACT_GATE_ID,
} from "./specmatic-contract.js";

const fixtureRoot = fileURLToPath(
  new URL("../__fixtures__/sample-nextjs-app/", import.meta.url),
);

const tempDirs: string[] = [];

async function makeFixtureCopy(): Promise<string> {
  const dir = join(tmpdir(), `specmatic-gate-${randomBytes(6).toString("hex")}`);
  tempDirs.push(dir);
  await cp(fixtureRoot, dir, { recursive: true });
  return dir;
}

afterEach(async () => {
  for (const dir of tempDirs.splice(0)) {
    await import("node:fs/promises").then(({ rm }) =>
      rm(dir, { recursive: true, force: true }),
    );
  }
});

describe("runSpecmaticContractGate", () => {
  it("passes when specmatic verification succeeds", async () => {
    const root = await makeFixtureCopy();
    const runner = vi.fn(async () => ({
      exitCode: 0,
      stdout: "ok",
      stderr: "",
      durationMs: 10,
      timedOut: false,
    }));

    const result = await runSpecmaticContractGate({
      config: {
        runId: "run-1",
        workingDir: root,
        evidenceDir: join(root, ".quality", "runs", "run-1", "evidence"),
        runCommand: runner,
      },
      baseUrl: "http://127.0.0.1:3000",
    });

    expect(result.gateId).toBe(SPECMATIC_CONTRACT_GATE_ID);
    expect(result.status).toBe("pass");
  });

  it("skips when no OpenAPI spec exists and the gate is not required", async () => {
    const root = join(tmpdir(), `specmatic-empty-${randomBytes(6).toString("hex")}`);
    tempDirs.push(root);
    await mkdir(join(root, ".quality", "runs", "run-1", "evidence"), { recursive: true });

    const result = await runSpecmaticContractGate({
      config: {
        runId: "run-1",
        workingDir: root,
        evidenceDir: join(root, ".quality", "runs", "run-1", "evidence"),
      },
    });

    expect(result.status).toBe("skipped");
  });
});
