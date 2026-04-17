import { cp, mkdir, writeFile } from "node:fs/promises";
import { join } from "node:path";
import { tmpdir } from "node:os";
import { randomBytes } from "node:crypto";
import { fileURLToPath } from "node:url";
import { afterEach, describe, expect, it } from "vitest";
import { extractCompletenessIs } from "./extract-is.mjs";

const fixtureRoot = fileURLToPath(
  new URL("../__fixtures__/sample-nextjs-app/", import.meta.url),
);

const tempDirs: string[] = [];

async function makeFixtureCopy(): Promise<string> {
  const dir = join(tmpdir(), `completeness-${randomBytes(6).toString("hex")}`);
  tempDirs.push(dir);
  await cp(fixtureRoot, dir, { recursive: true });
  await mkdir(join(dir, ".quality", "runs", "run-1", "evidence", "knip"), {
    recursive: true,
  });
  await writeFile(
    join(dir, ".quality", "runs", "run-1", "evidence", "knip", "output.json"),
    JSON.stringify(
      {
        files: [],
        issues: [
          {
            file: "src/lib/actions/broken-action.ts",
            exports: ["brokenAction"],
          },
        ],
      },
      null,
      2,
    ),
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

describe("extractCompletenessIs", () => {
  it("builds deterministic inventories and fitness checks", async () => {
    const root = await makeFixtureCopy();

    const { isList, evidence } = await extractCompletenessIs({
      root,
      outPath: "ralph/completeness-is-list.json",
      evidencePath: "ralph/completeness-evidence.json",
    });

    expect(isList.apiEndpoints.some((endpoint: { method: string; routePath: string }) =>
      endpoint.method === "GET" && endpoint.routePath === "/api/events/[eventId]",
    )).toBe(true);
    expect(isList.serverActions.some((action: { exportName: string; hasUseServerDirective: boolean }) =>
      action.exportName === "saveTravel" && action.hasUseServerDirective,
    )).toBe(true);
    expect(isList.uiPages.some((page: { routePath: string }) =>
      page.routePath === "/events/[eventId]",
    )).toBe(true);

    const routeHandlerCheck = evidence.fitnessChecks.find((check: { id: string }) =>
      check.id === "api-route-file-exports-handler",
    );
    expect(routeHandlerCheck.passed).toBe(false);
    expect(routeHandlerCheck.failures.some((failure: string) =>
      failure.includes("src/app/api/broken/route.ts"),
    )).toBe(true);

    const actionUseServerCheck = evidence.fitnessChecks.find((check: { id: string }) =>
      check.id === "server-action-has-use-server",
    );
    expect(actionUseServerCheck.passed).toBe(false);
    expect(actionUseServerCheck.failures.some((failure: string) =>
      failure.includes("src/lib/actions/broken-action.ts"),
    )).toBe(true);
  });

  it("marks unused exports from Knip as unreachable", async () => {
    const root = await makeFixtureCopy();

    const { isList } = await extractCompletenessIs({ root });
    const broken = isList.serverActions.find((action: { exportName: string }) =>
      action.exportName === "brokenAction",
    );

    expect(broken.reachable).toBe(false);
  });
});
