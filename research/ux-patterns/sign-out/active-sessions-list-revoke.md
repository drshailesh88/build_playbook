# Pattern: Active sessions list in settings with per-session revoke
**Surface:** sign-out · **Observed in:** GitHub, GitLab, Pipedrive, Figma, folk, Revolut, Fireflies (refs: [GitHub](https://mobbin.com/screens/5a8b8d3c-3721-4b93-97ed-db33916d3869), [GitLab](https://mobbin.com/screens/38670cce-dc00-46bb-ad31-f080206dd25d), [Pipedrive](https://mobbin.com/screens/7ed47d98-c70b-4186-ac34-5a9b8bf02028), [Figma](https://mobbin.com/screens/7a492b27-a3ca-47a7-932e-46a76e00ad69), [folk](https://mobbin.com/screens/574745bc-656d-4c5f-ac6f-e3bf7ff3273c), [Revolut](https://mobbin.com/screens/a33d51b9-51c6-46f1-b44f-eb4bc6207346), [Fireflies](https://mobbin.com/screens/01cc0f2b-45bb-4628-beaf-e6ffaa3d1f15))

## Flow
1. Settings → "Sessions" / "Active Sessions" / "Your devices" / "Device management" page.
2. Each row: device/browser + OS, location or IP, signed-in / last-accessed timestamps (Figma adds login IP; GitLab shows IP + signed-in date).
3. The current session is explicitly badged: "This is your current session" (GitLab), "THIS DEVICE" (Pipedrive), "Current" (Figma, folk, Fireflies).
4. Per-row action: "Revoke" (GitLab, red), "Log out" (Pipedrive, Revolut), "Remove access"; current session row has no revoke (or routes to normal sign-out).
5. Framing copy sets purpose: "Revoke any sessions that you do not recognize." (GitHub, GitLab).

## Use when
- Any multi-device B2B product — it is the user-facing answer to "is someone else in my account?" and the prerequisite UI for revoke-on-password-change to feel trustworthy.

## Avoid when
- Don't show raw IPs alone without device/browser context (unintelligible); don't omit the current-session badge — users can't tell which row is safe to kill.

## Sad paths observed
- Pipedrive pairs the list with guidance: "If you notice any suspicious logins, we recommend logging the suspicious device out, enabling two-factor authentication, and changing the password" — and keeps a 60-day device history table (login/logout times, expiry reason: "login expired after 12 hours").

## Accessibility
- Tabular rows with text labels and explicit button per row; timestamps as text. Badge ("Current") is text, not color-only.

## Default verdict for our stack
RECOMMENDED — Better Auth's listSessions/revokeSession maps 1:1; ship under Settings → Security with current-session badge and GitHub-style framing copy.
