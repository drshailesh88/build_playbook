# Pattern: Masked Not-Found (Existence Non-Disclosure)
**Surface:** cross-tenant-deep-link · **Observed in:** Linear, Height, Udemy, Coinbase (refs: [Linear "Team not found"](https://mobbin.com/screens/e96deffa-f341-4ca8-8e8c-923cffa72b8f), [Height "This object doesn't exist"](https://mobbin.com/screens/bd98fbd3-903c-4b52-9a17-fd3ce92fc0ad), [Udemy "You don't have permission"](https://mobbin.com/screens/bc53aef5-5697-43e8-8de9-21b60197b3ef), [Coinbase page-not-found in shell](https://mobbin.com/screens/7484e648-c0ba-4ffa-888c-30c36d53ab32))

## Flow
1. User opens a link to a resource they cannot access (or that doesn't exist — the two are deliberately indistinguishable).
2. The app shell stays intact: sidebar, nav, search all remain (Linear, Height, Coinbase) — only the content pane shows the empty state.
3. Copy avoids confirming existence: "Team not found — There is no team with the identifier BAC" (Linear), "Sorry, this page isn't available. This object doesn't exist." (Height), "Page not found — Sorry, we couldn't find what you were looking for" (Coinbase).
4. A single recovery action points home: "Back to Coinbase Developer Platform" (Coinbase), "Try again" (Height), or the live sidebar itself (Linear).
5. No request-access affordance — by design, there is nothing to request because officially there is nothing there.

## Use when
- Combination (2) for sensitive tenants: resource IDs in URLs must not confirm that Org A or its event exists to a non-member.
- Default posture for fail-closed systems — return the same state for "no access" and "doesn't exist" (HTTP 404-over-403 semantics).

## Avoid when
- The org WANTS discoverability and access requests (client-facing event workspaces) — masking kills the request-access funnel; Notion/Asana chose disclosure for this reason.
- The user is a member who mistyped/holds a stale link to a real-but-moved resource — pure masking with no search/home path strands them. Keep the shell alive like Linear/Height.

## Sad paths observed
- Udemy's variant is a bare full-page block ("You don't have permission to access this page. Visit our support page") with no app shell — honest but a dead end; only a support link saves it.
- Height adds "Try again" suggesting transient failure on a permanent state — misleading affordance; copy the masking, not the button.

## Accessibility
- Empty-state heading + one-sentence explanation as text; illustration is decorative.
- Recovery is a real link/button with descriptive label, and surrounding nav remains keyboard-reachable (shell-intact variants).
- Identical copy for 403/404 must still be specific enough to act on ("go back home", "search") — vagueness for security must not become vagueness of next step.

## Default verdict for our stack
RECOMMENDED — as the fail-closed default for combination (2) when an org has NOT enabled discoverability: render 404-equivalent ("This page isn't available") with shell intact; composes with DEC-057's no-access gate. Discoverable orgs upgrade to request-access-with-identity-disclosure.
