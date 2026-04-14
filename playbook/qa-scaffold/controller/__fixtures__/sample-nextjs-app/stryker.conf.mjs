/** @type {import('@stryker-mutator/api/core').PartialStrykerOptions} */
export default {
  mutate: ["src/lib/**/*.ts"],
  testRunner: "vitest",
  vitest: {
    configFile: "vitest.config.ts",
  },
  coverageAnalysis: "perTest",
  reporters: ["json", "clear-text"],
  jsonReporter: {
    fileName: "reports/mutation/mutation.json",
  },
  incrementalFile: "reports/mutation/incremental.json",
  timeoutMS: 60000,
  disableTypeChecks: true,
  concurrency: 2,
  tempDirName: ".stryker-tmp",
  cleanTempDir: true,
  checkers: [],
};
