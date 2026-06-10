# Pattern: Invite-Not-Found Minimal Dead-End
**Surface:** invite-error-states · **Observed in:** Clay (refs: [Clay](https://mobbin.com/screens/4e84282b-5e3d-4cb9-b8b6-6defdc7e8e89))

## Flow
1. Revoked/consumed/unknown invite token renders a near-empty page: alarm-clock emoji, heading "Not Found".
2. Body offers a guess, not a diagnosis: "We could not find this invite. Maybe it has already been used?"
3. No CTA, no login link, no contact path — the user is stranded.

## Use when
Honestly: as a deliberate minimal catch-all ONLY for malformed/forged tokens where you intentionally reveal nothing (security-by-vagueness for revoked invites — the same screen covers revoked and never-existed so a revoked invitee can't distinguish).

## Avoid when
Almost always — for legitimate users with expired/revoked/used invites this is the worst observed handling: no escape hatch violates the dead-end rule; if the user might have an account, at minimum link to login.

## Sad paths observed
This IS the sad path; the notable observation is the absence of any recovery affordance — harvested as an anti-pattern benchmark.

## Accessibility
Single h1 + one sentence is trivially readable, but with no focusable action the page traps keyboard users with nothing to do.

## Default verdict for our stack
AVOID — keep the vague copy idea for revoked-vs-unknown indistinguishability if desired, but always attach "Go to login" + "Request a new invite" actions; a bare dead-end fails our quality bar.
