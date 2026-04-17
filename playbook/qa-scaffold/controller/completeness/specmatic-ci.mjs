#!/usr/bin/env node
import { promises as fs } from "node:fs";
import { spawn } from "node:child_process";
import { basename, dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

export async function resolveOpenApiSpec(options = {}) {
  const root = resolve(options.root ?? process.cwd());
  if (options.specPath) {
    const explicit = resolve(root, options.specPath);
    await ensureFile(explicit);
    return { specPath: explicit, source: "explicit" };
  }

  const candidates = [
    "contracts/openapi/openapi.yaml",
    "contracts/openapi/openapi.yml",
    "contracts/openapi/openapi.json",
    "openapi/openapi.yaml",
    "openapi/openapi.yml",
    "openapi/openapi.json",
    "next.openapi.json",
    "public/openapi.json",
  ];
  for (const candidate of candidates) {
    const path = resolve(root, candidate);
    if (await fileExists(path)) {
      return { specPath: path, source: candidate };
    }
  }

  if (options.generateIfMissing) {
    const generated = await generateOpenApi(root, options.runCommand);
    if (generated) return { specPath: generated, source: "generated" };
  }

  throw new Error(
    "No OpenAPI spec found. Expected one of contracts/openapi/openapi.{yaml,yml,json}, openapi/openapi.{yaml,yml,json}, next.openapi.json, or public/openapi.json.",
  );
}

export async function runSpecmaticVerification(options = {}) {
  const root = resolve(options.root ?? process.cwd());
  const reportPath = resolve(root, options.outPath ?? "ralph/specmatic-report.json");
  const baseUrl = options.baseUrl ?? "http://127.0.0.1:3000";
  const runCommand = options.runCommand ?? defaultRunCommand;
  const spec = await resolveOpenApiSpec({
    root,
    specPath: options.specPath,
    generateIfMissing: options.generateIfMissing ?? true,
    runCommand,
  });

  const args = ["specmatic", "test", `--testBaseURL=${baseUrl}`, spec.specPath];
  const result = await runCommand("npx", args, { cwd: root });
  const coverageReportPath = join(root, "build", "reports", "specmatic", "coverage_report.json");
  const coverage = await readJsonIfPresent(coverageReportPath);
  const report = {
    schemaVersion: 1,
    generatedAt: new Date().toISOString(),
    baseUrl,
    specPath: spec.specPath,
    specSource: spec.source,
    command: ["npx", ...args],
    exitCode: result.exitCode,
    stdout: result.stdout,
    stderr: result.stderr,
    coverageReportPath: coverage ? coverageReportPath : null,
    coverage,
    success: result.exitCode === 0,
  };

  await fs.mkdir(dirname(reportPath), { recursive: true });
  await fs.writeFile(reportPath, `${JSON.stringify(report, null, 2)}\n`);
  return report;
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  try {
    await runSpecmaticVerification(args);
  } catch (error) {
    console.error(
      `[specmatic-ci] ${error instanceof Error ? error.message : String(error)}`,
    );
    process.exitCode = 2;
  }
}

async function generateOpenApi(root, runCommand) {
  const commands = [
    ["openapi-gen", "generate"],
    ["next-openapi-gen", "generate"],
  ];
  for (const command of commands) {
    const result = await runCommand("npx", command, { cwd: root });
    if (result.exitCode !== 0) continue;
    for (const candidate of ["next.openapi.json", "public/openapi.json"]) {
      const path = resolve(root, candidate);
      if (await fileExists(path)) return path;
    }
  }
  return null;
}

async function ensureFile(path) {
  if (!(await fileExists(path))) {
    throw new Error(`OpenAPI spec not found at ${path}.`);
  }
}

async function fileExists(path) {
  return (await fs.stat(path).catch(() => null))?.isFile() ?? false;
}

async function readJsonIfPresent(path) {
  const raw = await fs.readFile(path, "utf8").catch(() => null);
  if (raw === null) return null;
  try {
    return JSON.parse(raw);
  } catch {
    return null;
  }
}

async function defaultRunCommand(cmd, args, options = {}) {
  return new Promise((resolvePromise) => {
    const child = spawn(cmd, args, {
      cwd: options.cwd,
      stdio: ["ignore", "pipe", "pipe"],
      env: process.env,
    });
    let stdout = "";
    let stderr = "";
    child.stdout.on("data", (chunk) => {
      stdout += chunk.toString();
    });
    child.stderr.on("data", (chunk) => {
      stderr += chunk.toString();
    });
    child.on("close", (code) => {
      resolvePromise({
        exitCode: typeof code === "number" ? code : 1,
        stdout,
        stderr,
      });
    });
    child.on("error", (error) => {
      resolvePromise({
        exitCode: 1,
        stdout,
        stderr: `${stderr}${error.message}`,
      });
    });
  });
}

function parseArgs(args) {
  const parsed = {
    root: ".",
    baseUrl: "http://127.0.0.1:3000",
    outPath: "ralph/specmatic-report.json",
    specPath: undefined,
    generateIfMissing: true,
  };
  for (let index = 0; index < args.length; index++) {
    const value = args[index];
    const next = args[index + 1];
    if (value === "--root" && next) {
      parsed.root = next;
      index++;
      continue;
    }
    if (value === "--base-url" && next) {
      parsed.baseUrl = next;
      index++;
      continue;
    }
    if (value === "--out" && next) {
      parsed.outPath = next;
      index++;
      continue;
    }
    if (value === "--spec" && next) {
      parsed.specPath = next;
      index++;
      continue;
    }
    if (value === "--no-generate") {
      parsed.generateIfMissing = false;
    }
  }
  return parsed;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  await main();
}
