# Pattern: Token sad-path family — one distinct page per failure cause

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Supabase, Jitter, Clay, Linear, Squarespace (refs: [Supabase no-token](https://mobbin.com/screens/53cc50f8-fdd3-4181-939c-d60006ab5a97), [Jitter invalid/used](https://mobbin.com/screens/afbfda33-219a-4d01-b1cd-d25b1289c6ca), [Clay not-found](https://mobbin.com/screens/4e84282b-5e3d-4cb9-b8b6-6defdc7e8e89), [Linear already-accepted](https://mobbin.com/screens/7a0995a4-f085-45cd-b657-d88269272e9e), [Squarespace already-have-access](https://mobbin.com/screens/c7957528-2575-4d14-8183-4aa52a5a6c8d))

## Flow
Each failure cause gets its own copy and recovery route:
1. **Missing/unauthorized token** — invitation context stays visible ("You have been invited to join {org}") with the error explained and BOTH recovery CTAs: "Sign in" / "Create an account" (Supabase).
2. **Invalid or already-used link** — names both causes in one sentence: "This login link is invalid or has been used already, please try again." + "Back to login" (Jitter).
3. **Already accepted** — "Invitation already accepted — …please contact the workspace admins or {app} support." + "Go back"; header shows "Logged in as: {email}" to diagnose wrong-account (Linear).
4. **Already have access** — distinct copy: "You already have permissions on this site." (Squarespace).

## Use when
Any tokened public link — faculty confirm tokens, invite links. The visitor must learn WHAT failed and WHAT to do next without a dashboard.

## Avoid when
A generic "invalid link" page for all causes — and never Clay's dead end ("Maybe it has already been used?" with NO recovery CTA — observed anti-pattern).

## Sad paths observed
This pattern IS the sad-path family; the differentiator is cause-specific copy + recovery per cause.

## Accessibility
Full-page states with one clear next action; identity echo ("Logged in as…") in plain text.

## Microcopy worth stealing
"This login link is invalid or has been used already, please try again." · "If you think this is a mistake … contact {admins}." · "Logged in as: {email}"

## Default verdict for our stack
RECOMMENDED — the old app has exactly one sad-path message (expired → "contact the event organizer"). The rebuild's confirm page needs the full family: expired / invalid / already-accepted / already-declined, each with its own copy and an organizer-contact escalation.
