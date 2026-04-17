#!/usr/bin/env node
import { promises as fs } from "node:fs";
import { createRequire } from "node:module";
import { basename, dirname, extname, isAbsolute, join, relative, resolve, sep } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const EXTRACTOR_VERSION = 1;
const HTTP_METHODS = new Set(["GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"]);
const SOURCE_EXTENSIONS = new Set([".ts", ".tsx", ".js", ".jsx", ".mts", ".cts", ".mjs", ".cjs"]);
const TEST_FILE_RE = /(^|\/)(tests\/|test\/|__tests__\/|.+\.(test|spec)\.[^/]+$)/;
const IGNORE_DIRS = new Set([
  ".git",
  ".next",
  ".turbo",
  "coverage",
  "dist",
  "build",
  "node_modules",
  "reports",
  "tmp",
]);

export async function extractCompletenessIs(options = {}) {
  const root = resolve(options.root ?? process.cwd());
  const ts = await loadTypeScript(root);
  const discovered = await discoverProjectFiles(root);
  const knipSignals = await loadLatestKnipSignals(root);

  const testFiles = discovered.allFiles.filter((file) => TEST_FILE_RE.test(file));
  const uiPages = [];
  const apiEndpoints = [];
  const serverActions = [];
  const routeHandlers = [];
  const drizzleArtifacts = discovered.drizzleFiles.map((file) => ({
    id: `drizzle:${file}`,
    kind: "drizzle-schema",
    sourceFile: file,
  }));

  for (const file of discovered.pageFiles) {
    const routePath = deriveAppRoutePath(file.rootDir, file.file);
    if (routePath === null) continue;
    const page = {
      id: `page:${routePath}`,
      kind: "ui-page",
      routePath,
      sourceFile: file.file,
      testFiles: findRelatedTests(
        tokensForEntity({ routePath, sourceFile: file.file }),
        testFiles,
      ),
      reachable: !knipSignals.unusedFiles.has(file.file),
      dynamic: routePath.includes("["),
    };
    uiPages.push(page);
  }

  for (const file of discovered.routeFiles) {
    const details = await analyzeSourceFile(ts, root, file.file);
    const routePath = deriveAppRoutePath(file.rootDir, file.file);
    if (routePath === null) continue;
    const methods = details.exportedNames.filter((name) => HTTP_METHODS.has(name));
    const baseEntity = buildCodeEntity({
      routePath,
      sourceFile: file.file,
      testFiles,
      knipSignals,
      details,
    });
    const handler = {
      id: `route-file:${file.file}`,
      kind: "route-handler-file",
      routePath,
      sourceFile: file.file,
      methods,
      testFiles: baseEntity.testFiles,
      reachable: baseEntity.reachable,
      validationSignals: baseEntity.validationSignals,
      accessSignals: baseEntity.accessSignals,
      auditSignals: baseEntity.auditSignals,
      mutationSignals: baseEntity.mutationSignals,
      transactionSignals: baseEntity.transactionSignals,
      exportedNames: details.exportedNames,
    };
    routeHandlers.push(handler);

    if (methods.length === 0) {
      apiEndpoints.push({
        id: `endpoint:unhandled:${routePath}`,
        kind: "api-endpoint",
        routePath,
        method: "UNHANDLED",
        sourceFile: file.file,
        testFiles: baseEntity.testFiles,
        reachable: baseEntity.reachable,
        validationSignals: baseEntity.validationSignals,
        accessSignals: baseEntity.accessSignals,
        auditSignals: baseEntity.auditSignals,
        mutationSignals: baseEntity.mutationSignals,
        transactionSignals: baseEntity.transactionSignals,
        eventScoped: isEventScoped(routePath, file.file),
      });
      continue;
    }

    for (const method of methods) {
      apiEndpoints.push({
        id: `endpoint:${method}:${routePath}`,
        kind: "api-endpoint",
        routePath,
        method,
        sourceFile: file.file,
        testFiles: baseEntity.testFiles,
        reachable: baseEntity.reachable,
        validationSignals: baseEntity.validationSignals,
        accessSignals: baseEntity.accessSignals,
        auditSignals: baseEntity.auditSignals,
        mutationSignals: dedupeStrings([
          ...baseEntity.mutationSignals,
          ...(isMutatingMethod(method) ? [`method:${method}`] : []),
        ]),
        transactionSignals: baseEntity.transactionSignals,
        eventScoped: isEventScoped(routePath, file.file),
      });
    }
  }

  for (const file of discovered.actionFiles) {
    const details = await analyzeSourceFile(ts, root, file.file);
    const common = buildCodeEntity({
      routePath: null,
      sourceFile: file.file,
      testFiles,
      knipSignals,
      details,
    });
    for (const exportName of details.exportedNames) {
      if (HTTP_METHODS.has(exportName)) continue;
      serverActions.push({
        id: `action:${file.file}#${exportName}`,
        kind: "server-action",
        exportName,
        sourceFile: file.file,
        hasUseServerDirective: details.hasUseServerDirective,
        testFiles: common.testFiles,
        reachable: common.reachable && !knipSignals.isUnusedExport(file.file, exportName),
        validationSignals: common.validationSignals,
        accessSignals: common.accessSignals,
        auditSignals: common.auditSignals,
        mutationSignals: common.mutationSignals,
        transactionSignals: common.transactionSignals,
        eventScoped: isEventScoped(null, file.file),
      });
    }
  }

  const issues = buildFitnessChecks({ apiEndpoints, serverActions, uiPages, routeHandlers });
  const isList = {
    schemaVersion: EXTRACTOR_VERSION,
    generatedAt: new Date().toISOString(),
    projectRoot: root,
    summaries: {
      apiEndpoints: apiEndpoints.length,
      routeHandlers: routeHandlers.length,
      serverActions: serverActions.length,
      uiPages: uiPages.length,
      drizzleArtifacts: drizzleArtifacts.length,
      tests: testFiles.length,
      fitnessChecks: issues.length,
      failingChecks: issues.filter((check) => !check.passed).length,
    },
    apiEndpoints,
    routeHandlers,
    serverActions,
    uiPages,
    drizzleArtifacts,
  };
  const evidence = {
    schemaVersion: EXTRACTOR_VERSION,
    generatedAt: isList.generatedAt,
    extractorVersion: EXTRACTOR_VERSION,
    projectRoot: root,
    discovered: {
      appRoots: discovered.appRoots,
      actionRoots: discovered.actionRoots,
      drizzleRoots: discovered.drizzleRoots,
      testFiles,
    },
    negativeSignals: {
      knipReportPath: knipSignals.reportPath,
      unusedFiles: [...knipSignals.unusedFiles].sort(),
      unusedExportsByFile: Object.fromEntries(
        [...knipSignals.unusedExports.entries()]
          .sort(([left], [right]) => left.localeCompare(right))
          .map(([file, names]) => [file, [...names].sort()]),
      ),
    },
    fitnessChecks: issues,
    warnings: buildWarnings({ apiEndpoints, serverActions, uiPages }),
  };

  if (options.outPath) {
    await writeJson(resolve(root, options.outPath), isList);
  }
  if (options.evidencePath) {
    await writeJson(resolve(root, options.evidencePath), evidence);
  }

  return { isList, evidence };
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  try {
    await extractCompletenessIs({
      root: args.root,
      outPath: args.out,
      evidencePath: args.evidence,
    });
  } catch (error) {
    console.error(
      `[completeness-is] ${error instanceof Error ? error.message : String(error)}`,
    );
    process.exitCode = 2;
  }
}

async function loadTypeScript(root) {
  const requireFromRoot = createRequire(pathToFileURL(join(root, "package.json")).href);
  try {
    return requireFromRoot("typescript");
  } catch {
    try {
      return createRequire(import.meta.url)("typescript");
    } catch {
      throw new Error(
        "Local 'typescript' dependency not found. Install TypeScript in the target app before running completeness extraction.",
      );
    }
  }
}

async function discoverProjectFiles(root) {
  const appRoots = await existingDirs([join(root, "src", "app"), join(root, "app")]);
  const actionRoots = await existingDirs([join(root, "src", "lib", "actions"), join(root, "lib", "actions")]);
  const drizzleRoots = await existingDirs([join(root, "drizzle")]);
  const allFiles = (await walk(root)).map((file) => normalizePath(relative(root, file)));
  const pageFiles = appRoots.flatMap((dir) =>
    allFiles
      .filter((file) => file.startsWith(normalizePath(relative(root, dir))) && basename(file).startsWith("page."))
      .map((file) => ({ rootDir: normalizePath(relative(root, dir)), file })),
  );
  const routeFiles = appRoots.flatMap((dir) =>
    allFiles
      .filter((file) => file.startsWith(normalizePath(relative(root, dir))) && basename(file).startsWith("route."))
      .map((file) => ({ rootDir: normalizePath(relative(root, dir)), file })),
  );
  const actionFiles = actionRoots.flatMap((dir) =>
    allFiles
      .filter((file) => file.startsWith(normalizePath(relative(root, dir))) && SOURCE_EXTENSIONS.has(extname(file)))
      .filter((file) => !TEST_FILE_RE.test(file))
      .map((file) => ({ rootDir: normalizePath(relative(root, dir)), file })),
  );
  const drizzleFiles = drizzleRoots.flatMap((dir) =>
    allFiles.filter((file) => file.startsWith(normalizePath(relative(root, dir))) && SOURCE_EXTENSIONS.has(extname(file))),
  );
  return {
    appRoots: appRoots.map((dir) => normalizePath(relative(root, dir))),
    actionRoots: actionRoots.map((dir) => normalizePath(relative(root, dir))),
    drizzleRoots: drizzleRoots.map((dir) => normalizePath(relative(root, dir))),
    allFiles,
    pageFiles,
    routeFiles,
    actionFiles,
    drizzleFiles,
  };
}

function analyzeSourceFile(ts, root, relativeFile) {
  const filePath = join(root, relativeFile);
  return fs.readFile(filePath, "utf8").then((text) => {
    const scriptKind =
      extname(relativeFile).includes("x") ? ts.ScriptKind.TSX : ts.ScriptKind.TS;
    const sourceFile = ts.createSourceFile(filePath, text, ts.ScriptTarget.Latest, true, scriptKind);
    const importedModules = [];
    const importedNames = [];
    const exportedNames = [];
    const callNames = new Set();

    for (const statement of sourceFile.statements) {
      if (ts.isImportDeclaration(statement)) {
        const moduleName =
          ts.isStringLiteral(statement.moduleSpecifier) ? statement.moduleSpecifier.text : null;
        if (moduleName) importedModules.push(moduleName);
        const clause = statement.importClause;
        if (clause?.name) importedNames.push(clause.name.text);
        if (clause?.namedBindings && ts.isNamedImports(clause.namedBindings)) {
          for (const element of clause.namedBindings.elements) {
            importedNames.push((element.propertyName ?? element.name).text);
          }
        }
      }
      collectExportedNames(ts, statement, exportedNames);
    }

    const visit = (node) => {
      if (ts.isCallExpression(node)) {
        callNames.add(node.expression.getText(sourceFile));
      }
      ts.forEachChild(node, visit);
    };
    visit(sourceFile);

    const hasUseServerDirective = sourceFile.statements.some((statement) =>
      ts.isExpressionStatement(statement) &&
      ts.isStringLiteral(statement.expression) &&
      statement.expression.text === "use server",
    );
    const validationSignals = detectValidationSignals(text, importedModules, callNames);
    const accessSignals = detectSignals(text, callNames, [
      "assertEventAccess",
      "assertAccess",
      "requireAuth",
      "requireUser",
      "currentUser",
      "getAuth",
      "auth(",
      "protect",
    ]);
    const auditSignals = detectSignals(text, callNames, ["audit", "Audit"]);
    const mutationSignals = detectMutationSignals(callNames);
    const transactionSignals = detectSignals(text, callNames, [".transaction", "transaction("]);

    return {
      hasUseServerDirective,
      importedModules,
      importedNames,
      exportedNames: dedupeStrings(exportedNames),
      callNames: [...callNames],
      validationSignals,
      accessSignals,
      auditSignals,
      mutationSignals,
      transactionSignals,
    };
  });
}

function collectExportedNames(ts, statement, exportedNames) {
  const hasExportModifier = (node) =>
    !!node.modifiers?.some((modifier) => modifier.kind === ts.SyntaxKind.ExportKeyword);

  if (ts.isFunctionDeclaration(statement) && statement.name && hasExportModifier(statement)) {
    exportedNames.push(statement.name.text);
    return;
  }
  if (ts.isVariableStatement(statement) && hasExportModifier(statement)) {
    for (const declaration of statement.declarationList.declarations) {
      if (ts.isIdentifier(declaration.name)) {
        exportedNames.push(declaration.name.text);
      }
    }
    return;
  }
  if (ts.isExportDeclaration(statement) && statement.exportClause && ts.isNamedExports(statement.exportClause)) {
    for (const element of statement.exportClause.elements) {
      exportedNames.push((element.propertyName ?? element.name).text);
    }
  }
}

function detectValidationSignals(text, importedModules, callNames) {
  const signals = [];
  const hasZodImport = importedModules.some((moduleName) => moduleName.includes("zod"));
  if (hasZodImport) signals.push("import:zod");
  for (const name of callNames) {
    if (
      name.endsWith(".parse") ||
      name.endsWith(".safeParse") ||
      name.endsWith(".parseAsync") ||
      name.endsWith(".safeParseAsync")
    ) {
      signals.push(`call:${name}`);
    }
  }
  if (/schema/i.test(text) && /\b(parse|safeParse|parseAsync|safeParseAsync)\(/.test(text)) {
    signals.push("text:validation");
  }
  return dedupeStrings(signals);
}

function detectSignals(text, callNames, patterns) {
  const signals = [];
  for (const pattern of patterns) {
    if (text.includes(pattern)) signals.push(`text:${pattern}`);
    for (const name of callNames) {
      if (name.includes(pattern.replace("(", ""))) {
        signals.push(`call:${name}`);
      }
    }
  }
  return dedupeStrings(signals);
}

function detectMutationSignals(callNames) {
  const signals = [];
  for (const name of callNames) {
    if (name.endsWith(".insert") || name.endsWith(".update") || name.endsWith(".delete")) {
      signals.push(`call:${name}`);
    }
  }
  return dedupeStrings(signals);
}

function buildCodeEntity({ routePath, sourceFile, testFiles, knipSignals, details }) {
  return {
    routePath,
    sourceFile,
    testFiles: findRelatedTests(tokensForEntity({ routePath, sourceFile }), testFiles),
    reachable: !knipSignals.unusedFiles.has(sourceFile),
    validationSignals: details.validationSignals,
    accessSignals: details.accessSignals,
    auditSignals: details.auditSignals,
    mutationSignals: details.mutationSignals,
    transactionSignals: details.transactionSignals,
  };
}

function buildFitnessChecks({ apiEndpoints, serverActions, uiPages, routeHandlers }) {
  const checks = [];
  checks.push(
    makeCheck(
      "api-route-file-exports-handler",
      "Every route.ts file exports at least one HTTP handler.",
      routeHandlers
        .filter((handler) => handler.methods.length === 0)
        .map((handler) => `${handler.sourceFile}: no HTTP method exports`),
    ),
  );
  checks.push(
    makeCheck(
      "api-endpoint-has-test",
      "Every API endpoint has at least one related test file.",
      apiEndpoints
        .filter((endpoint) => endpoint.method !== "UNHANDLED" && endpoint.testFiles.length === 0)
        .map((endpoint) => `${endpoint.method} ${endpoint.routePath}: no related tests`),
    ),
  );
  checks.push(
    makeCheck(
      "server-action-has-use-server",
      "Every exported server action lives in a file with 'use server'.",
      serverActions
        .filter((action) => !action.hasUseServerDirective)
        .map((action) => `${action.sourceFile}#${action.exportName}: missing 'use server'`),
    ),
  );
  checks.push(
    makeCheck(
      "server-action-has-test",
      "Every exported server action has at least one related test file.",
      serverActions
        .filter((action) => action.testFiles.length === 0)
        .map((action) => `${action.sourceFile}#${action.exportName}: no related tests`),
    ),
  );
  checks.push(
    makeCheck(
      "mutations-have-validation",
      "Every mutating route or action shows a validation signal.",
      [
        ...apiEndpoints
          .filter((endpoint) => isMutatingEndpoint(endpoint) && endpoint.validationSignals.length === 0)
          .map((endpoint) => `${endpoint.method} ${endpoint.routePath}: no validation signal`),
        ...serverActions
          .filter((action) => action.mutationSignals.length > 0 && action.validationSignals.length === 0)
          .map((action) => `${action.sourceFile}#${action.exportName}: no validation signal`),
      ],
    ),
  );
  checks.push(
    makeCheck(
      "event-scoped-mutations-have-access-guard",
      "Every event-scoped mutation shows an access-control signal.",
      [
        ...apiEndpoints
          .filter(
            (endpoint) =>
              endpoint.eventScoped &&
              isMutatingEndpoint(endpoint) &&
              endpoint.accessSignals.length === 0,
          )
          .map((endpoint) => `${endpoint.method} ${endpoint.routePath}: no access guard signal`),
        ...serverActions
          .filter(
            (action) =>
              action.eventScoped &&
              action.mutationSignals.length > 0 &&
              action.accessSignals.length === 0,
          )
          .map((action) => `${action.sourceFile}#${action.exportName}: no access guard signal`),
      ],
    ),
  );
  checks.push(
    makeCheck(
      "travel-domain-mutations-write-audit-log",
      "Travel/accommodation/transport mutations show an audit-log signal.",
      [
        ...apiEndpoints
          .filter(
            (endpoint) =>
              isTravelDomain(endpoint.sourceFile, endpoint.routePath) &&
              isMutatingEndpoint(endpoint) &&
              endpoint.auditSignals.length === 0,
          )
          .map((endpoint) => `${endpoint.method} ${endpoint.routePath}: no audit signal`),
        ...serverActions
          .filter(
            (action) =>
              isTravelDomain(action.sourceFile, null) &&
              action.mutationSignals.length > 0 &&
              action.auditSignals.length === 0,
          )
          .map((action) => `${action.sourceFile}#${action.exportName}: no audit signal`),
      ],
    ),
  );
  checks.push(
    makeCheck(
      "ui-page-has-test",
      "Every UI page has at least one related test file.",
      uiPages
        .filter((page) => page.testFiles.length === 0)
        .map((page) => `${page.routePath}: no related tests`),
    ),
  );
  return checks;
}

function buildWarnings({ apiEndpoints, serverActions, uiPages }) {
  return {
    unhandledRouteFiles: apiEndpoints
      .filter((endpoint) => endpoint.method === "UNHANDLED")
      .map((endpoint) => endpoint.sourceFile),
    unreachableEntities: [
      ...apiEndpoints.filter((endpoint) => !endpoint.reachable).map((endpoint) => endpoint.id),
      ...serverActions.filter((action) => !action.reachable).map((action) => action.id),
      ...uiPages.filter((page) => !page.reachable).map((page) => page.id),
    ].sort(),
  };
}

function makeCheck(id, description, failures) {
  return {
    id,
    description,
    passed: failures.length === 0,
    failures,
  };
}

function isMutatingMethod(method) {
  return ["POST", "PUT", "PATCH", "DELETE"].includes(method);
}

function isMutatingEndpoint(endpoint) {
  return endpoint.method !== "UNHANDLED" && (isMutatingMethod(endpoint.method) || endpoint.mutationSignals.length > 0);
}

function isTravelDomain(sourceFile, routePath) {
  const haystack = `${sourceFile} ${routePath ?? ""}`.toLowerCase();
  return ["travel", "accommodation", "transport"].some((part) => haystack.includes(part));
}

function isEventScoped(routePath, sourceFile) {
  return `${routePath ?? ""} ${sourceFile}`.toLowerCase().includes("event");
}

function tokensForEntity({ routePath, sourceFile }) {
  const tokens = new Set();
  const seed = [routePath ?? "", sourceFile]
    .join("/")
    .replace(/\[|\]|\(|\)|\./g, "/")
    .split(/[\/_-]+/)
    .filter(Boolean)
    .map((token) => token.toLowerCase());
  for (const token of seed) {
    if (["src", "app", "lib", "actions", "page", "route", "tests", "test", "unit"].includes(token)) {
      continue;
    }
    tokens.add(token);
  }
  return [...tokens];
}

function findRelatedTests(tokens, testFiles) {
  if (tokens.length === 0) return [];
  const ranked = testFiles
    .map((file) => {
      const lower = file.toLowerCase();
      const score = tokens.reduce((count, token) => (lower.includes(token) ? count + 1 : count), 0);
      return { file, score };
    })
    .filter((entry) => entry.score > 0)
    .sort((left, right) => right.score - left.score || left.file.localeCompare(right.file));
  return ranked.slice(0, 5).map((entry) => entry.file);
}

function deriveAppRoutePath(appRoot, relativeFile) {
  const absoluteRoot = normalizePath(appRoot);
  const relativeToApp = relativeFile.startsWith(`${absoluteRoot}/`)
    ? relativeFile.slice(absoluteRoot.length + 1)
    : relativeFile;
  const segments = dirname(relativeToApp)
    .split("/")
    .filter(Boolean)
    .map(normalizeSegment)
    .filter(Boolean);
  return `/${segments.join("/")}`.replace(/\/+/g, "/");
}

function normalizeSegment(segment) {
  if (segment === ".") return null;
  if (/^\([^)]*\)$/.test(segment)) return null;
  const intercepted = segment.match(/^\([^)]*\)(.+)$/);
  if (intercepted) return intercepted[1];
  if (segment.startsWith("@")) return null;
  return segment;
}

async function loadLatestKnipSignals(root) {
  const runsRoot = join(root, ".quality", "runs");
  const candidates = [];
  const walkRuns = async (dir) => {
    let entries = [];
    try {
      entries = await fs.readdir(dir, { withFileTypes: true });
    } catch {
      return;
    }
    for (const entry of entries) {
      const entryPath = join(dir, entry.name);
      if (entry.isDirectory()) {
        await walkRuns(entryPath);
        continue;
      }
      if (entry.name === "output.json" && normalizePath(entryPath).includes("/evidence/knip/")) {
        const stats = await fs.stat(entryPath).catch(() => null);
        if (stats) {
          candidates.push({ path: entryPath, mtimeMs: stats.mtimeMs });
        }
      }
    }
  };
  await walkRuns(runsRoot);

  const latest = candidates.sort((left, right) => right.mtimeMs - left.mtimeMs)[0];
  const unusedFiles = new Set();
  const unusedExports = new Map();

  if (!latest) {
    return {
      reportPath: null,
      unusedFiles,
      unusedExports,
      isUnusedExport(file, exportName) {
        return false;
      },
    };
  }

  const raw = await fs.readFile(latest.path, "utf8").catch(() => "{}");
  let parsed;
  try {
    parsed = JSON.parse(raw);
  } catch {
    parsed = {};
  }
  for (const file of parsed.files ?? []) {
    const normalized = normalizePath(String(file));
    if (normalized.startsWith("/")) {
      unusedFiles.add(normalizePath(relative(root, normalized)));
    } else {
      unusedFiles.add(normalized);
    }
  }
  for (const issue of parsed.issues ?? []) {
    const rawFile = String(issue.file ?? "");
    const file = isAbsolute(rawFile)
      ? normalizePath(relative(root, rawFile))
      : normalizePath(rawFile);
    if (!file) continue;
    const names = issue.exports ?? [];
    if (!unusedExports.has(file)) unusedExports.set(file, new Set());
    for (const item of names) {
      if (typeof item === "string") {
        unusedExports.get(file).add(item);
      } else if (item && typeof item === "object" && typeof item.name === "string") {
        unusedExports.get(file).add(item.name);
      }
    }
  }

  return {
    reportPath: normalizePath(relative(root, latest.path)),
    unusedFiles,
    unusedExports,
    isUnusedExport(file, exportName) {
      return unusedExports.get(file)?.has(exportName) ?? false;
    },
  };
}

async function existingDirs(paths) {
  const found = [];
  for (const path of paths) {
    const stats = await fs.stat(path).catch(() => null);
    if (stats?.isDirectory()) found.push(path);
  }
  return found;
}

async function walk(root) {
  const files = [];
  const traverse = async (dir) => {
    let entries = [];
    try {
      entries = await fs.readdir(dir, { withFileTypes: true });
    } catch {
      return;
    }
    for (const entry of entries) {
      const fullPath = join(dir, entry.name);
      if (entry.isDirectory()) {
        if (IGNORE_DIRS.has(entry.name) || entry.name.startsWith(".")) continue;
        await traverse(fullPath);
        continue;
      }
      if (entry.isFile() && SOURCE_EXTENSIONS.has(extname(entry.name))) {
        files.push(fullPath);
      }
    }
  };
  await traverse(root);
  return files.sort();
}

async function writeJson(path, body) {
  await fs.mkdir(dirname(path), { recursive: true });
  await fs.writeFile(path, `${JSON.stringify(body, null, 2)}\n`);
}

function normalizePath(path) {
  return path.split(sep).join("/");
}

function dedupeStrings(items) {
  return [...new Set(items)].sort();
}

function parseArgs(args) {
  const parsed = {
    root: ".",
    out: "ralph/completeness-is-list.json",
    evidence: "ralph/completeness-evidence.json",
  };
  for (let index = 0; index < args.length; index++) {
    const value = args[index];
    const next = args[index + 1];
    if (value === "--root" && next) {
      parsed.root = next;
      index++;
      continue;
    }
    if (value === "--out" && next) {
      parsed.out = next;
      index++;
      continue;
    }
    if (value === "--evidence" && next) {
      parsed.evidence = next;
      index++;
      continue;
    }
  }
  return parsed;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  await main();
}
