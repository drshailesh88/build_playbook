// DRAFT — installed by /playbook:install-qa-harness when NextAuth/Auth.js is detected.
// Lives in the target app at `tests/global-setup.ts`. Validate against a real
// NextAuth app before trusting; adjust the credentials-provider path + form
// field names as needed.

import { chromium, type FullConfig } from "@playwright/test";
import { mkdirSync } from "node:fs";
import { dirname, resolve } from "node:path";

export default async function globalSetup(_config: FullConfig) {
  const storageFile = resolve(process.cwd(), "playwright/.nextauth/user.json");
  mkdirSync(dirname(storageFile), { recursive: true });

  const baseUrl = process.env.NEXTAUTH_URL ?? "http://localhost:3000";
  const email = process.env.E2E_TEST_USER_EMAIL;
  const password = process.env.E2E_TEST_USER_PASSWORD;
  if (!email || !password) {
    throw new Error(
      "NextAuth global-setup: E2E_TEST_USER_EMAIL + E2E_TEST_USER_PASSWORD required in .env.test",
    );
  }

  const browser = await chromium.launch();
  const page = await browser.newPage();

  // Default NextAuth credentials flow. Adjust selectors if your form differs.
  await page.goto(`${baseUrl}/api/auth/signin`);
  await page.fill('input[name="email"]', email);
  await page.fill('input[name="password"]', password);
  await page.click('button[type="submit"]');
  await page.waitForURL(new RegExp(`^${baseUrl}(/|$)`));

  await page.context().storageState({ path: storageFile });
  await browser.close();
}
