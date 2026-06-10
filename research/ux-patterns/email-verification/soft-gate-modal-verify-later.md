# Pattern: Soft gate — modal over dashboard with explicit "Verify later"
**Surface:** email-verification · **Observed in:** Cloudflare (refs: [Cloudflare](https://mobbin.com/screens/82612600-b413-46eb-a8b0-fb3b45343d79))

## Flow
1. On entering the dashboard unverified, a modal interrupts: "Verify your account — We sent an email to <email>. To verify your account, click the link in the email."
2. Two actions: primary "Resend email", secondary "Verify later".
3. "Verify later" dismisses the modal; the dashboard is fully usable behind it.

## Use when
- You want one strong interruption per session (stronger than a banner, weaker than a wall) while keeping the product accessible.
- Verification meaningfully unlocks capabilities, so the prompt deserves modal weight once.

## Avoid when
- Shown on every navigation — repeated modals are the most irritating variant of the soft gate; cap the frequency.
- Verification is genuinely required — a dismissible modal communicates "optional".

## Sad paths observed
- None beyond resend; modal lacks a change-email affordance (weaker than the PlanetScale/Discord walls on wrong-address recovery).

## Accessibility
- Standard modal semantics needed (focus trap, Esc = "Verify later"); both actions are real buttons.

## Default verdict for our stack
AVOID — splits the difference poorly for us: banner is less annoying for exploration, hard/capability gate is correct where verification matters; a once-per-session modal adds interruption without enforcement.
