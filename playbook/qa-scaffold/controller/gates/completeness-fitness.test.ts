import { cp, mkdir, writeFile } from "node:fs/promises";
import { randomBytes } from "node:crypto";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { afterEach, describe, expect, it } from "vitest";
import {
  runCompletenessFitnessGate,
  COMPLETENESS_FITNESS_GATE_ID,
} from "./completeness-fitness.js";

const fixtureRoot = fileURLToPath(
  new URL("../__fixtures__/sample-nextjs-app/", import.meta.url),
);

const tempDirs: string[] = [];

async function makeFixtureCopy(): Promise<string> {
  const dir = join(tmpdir(), `completeness-gate-${randomBytes(6).toString("hex")}`);
  tempDirs.push(dir);
  await cp(fixtureRoot, dir, { recursive: true });
  await mkdir(join(dir, ".quality", "policies"), { recursive: true });
  await writeFile(
    join(dir, ".quality", "policies", "lock-manifest.json"),
    JSON.stringify({ schema_version: 1, files: {} }),
  );
  return dir;
}

afterEach(async () => {
  for (const dir of tempDirs.splice(0)) {
    await import("node:fs/promises").then(({ rm }) =>
      rm(dir, { recursive: true, force: true }),
    );
  }
});

describe("runCompletenessFitnessGate", () => {
  it("fails when deterministic completeness checks fail", async () => {
    const root = await makeFixtureCopy();
    const result = await runCompletenessFitnessGate({
      config: {
        runId: "run-1",
        workingDir: root,
        evidenceDir: join(root, ".quality", "runs", "run-1", "evidence"),
      },
    });

    expect(result.gateId).toBe(COMPLETENESS_FITNESS_GATE_ID);
    expect(result.status).toBe("fail");
    expect(result.details.failingChecksCount).toBeGreaterThan(0);
  });
});
