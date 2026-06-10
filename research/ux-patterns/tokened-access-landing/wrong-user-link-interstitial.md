# Pattern: Wrong-user magic-link interstitial (link is for a different identity)
**Surface:** tokened-access-landing · **Observed in:** Better Stack (ref: https://mobbin.com/screens/79ff5d94-60a3-441e-a5e4-d535330f7948)

## Flow
1. A signed-in user clicks a magic link issued for someone else.
2. Instead of silently acting, an interstitial blocks: "Switch accounts — You clicked a magic link for a different user. What do you want to do?"
3. Two explicit choices: "Switch account to jonsmith@…" (primary) vs "Stay signed in as jsmith@…" (secondary).
4. Legal/ToS note below; "Back to Better Stack" escape at top.

## Use when
- Token email doesn't match an existing session/cookie identity — e.g., a shared family computer, or an organizer testing a faculty link while logged into the admin app.
- Our adaptation: organizer (org member, Better Auth session) opens a delegate's tokened link — warn "This link belongs to Dr. Sharma" with "View as organizer" vs "Continue as Dr. Sharma (preview)".

## Avoid when
- No conflicting session exists (the normal external case) — never show this to a clean browser; it adds a step for nothing.
- Don't auto-switch identities without this explicit choice; that is how wrong-person RSVPs and data leaks happen.

## Sad paths observed
- This screen IS the sad-path handler: ambiguous identity becomes an explicit fork instead of a silent overwrite.

## Accessibility
- Both options are large buttons with the full email inside the label — screen-reader users hear exactly which identity each button selects.

## Default verdict for our stack
RECOMMENDED — implement for the session-vs-token mismatch case (org member opens external token); for external-only browsers fall back to the named-recipient header pattern.
