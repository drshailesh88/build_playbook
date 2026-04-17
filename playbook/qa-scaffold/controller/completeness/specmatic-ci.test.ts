import { cp, mkdir, writeFile } from "node:fs/promises";
import { join } from "node:path";
import { tmpdir } from "node:os";
import { randomBytes } from "node:crypto";
import { fileURLToPath } from "node:url";
import { afterEach, describe, expect, it, vi } from "vitest";
import { resolveOpenApiSpec, runSpecmaticVerification } from "./specmatic-ci.mjs";

const fixtureRoot = fileURLToPath(
  new URL("../__fixtures__/sample-nextjs-app/", import.meta.url),
);

const tempDirs: string[] = [];

async function makeFixtureCopy(): Promise<string> {
  const dir = join(tmpdir(), `specmatic-${randomBytes(6).toString("hex")}`);
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

describe("specmatic-ci", () => {
  it("resolves an existing OpenAPI spec from the project root", async () => {
    const root = await makeFixtureCopy();

    const resolved = await resolveOpenApiSpec({ root });
    expect(resolved.source).toBe("next.openapi.json");
    expect(resolved.specPath.endsWith("next.openapi.json")).toBe(true);
  });

  it("writes a report using the resolved spec and a mocked command runner", async () => {
    const root = await makeFixtureCopy();
    const runCommand = vi.fn(async () => ({
      exitCode: 0,
      stdout: "specmatic ok",
      stderr: "",
    }));
    await mkdir(join(root, "build", "reports", "specmatic"), { recursive: true });
    await writeFile(
      join(root, "build", "reports", "specmatic", "coverage_report.json"),
      JSON.stringify({ covered: ["GET /api/events/{eventId}"] }, null, 2),
    );

    const report = await runSpecmaticVerification({
      root,
      outPath: "ralph/specmatic-report.json",
      baseUrl: "http://127.0.0.1:3000",
      runCommand,
    });

    expect(report.success).toBe(true);
    expect(report.specPath.endsWith("next.openapi.json")).toBe(true);
    expect(runCommand).toHaveBeenCalled();
    expect(report.coverage.covered).toContain("GET /api/events/{eventId}");
  });
});
