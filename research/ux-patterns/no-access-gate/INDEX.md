# no-access-gate — pattern index

**Coverage note.** Queries run — by-pattern: "you don't have access to this page request access contact your admin", "account deactivated by admin you no longer have access sign in to a different workspace". Apps swept: Notion, Mixpanel (logged-in + logged-out variants), Amplitude, Asana, Framer, Udemy, Cron Calendar (excluded: "Selected account isn't a Cron user" is a wrong-OAuth-account sign-in error, not an org gate). NOT found: a gate showing request-PENDING / request-DENIED states (every observed screen is the initial ask — the post-request lifecycle has no harvested precedent); Vercel/Stripe team-access-denied pages did not surface on web.

- ★ `request-access-gate-page.md` — full-page fail-closed gate: headline + "logged in as" identity + Request access (admin notified) + switch-account/back escapes (Notion, Mixpanel, Amplitude)
- `request-access-with-message.md` — in-shell sub-resource gate with optional message-for-approver (Asana)
- `in-shell-gate-with-switcher-escape.md` — denial in content pane, workspace switcher as one-click recovery (Framer)
- `static-403-support-page.md` — bare permission-denied page, support link only (Udemy) — documented as the anti-floor
