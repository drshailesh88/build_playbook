# Pattern: Account Chooser for This Destination
**Surface:** cross-tenant-deep-link · **Observed in:** Proton, Grammarly, Confluence, Whereby, ClickUp (refs: [Proton "Choose an account"](https://mobbin.com/screens/1cbd9ced-59a6-4d30-b880-2514c9fe35a4), [Grammarly choose-an-account](https://mobbin.com/screens/dc9f00c3-d1ba-4904-8262-65df7fc0d59c), [Confluence "Choose or add another account"](https://mobbin.com/screens/ed0de1ce-bf14-4cfc-a512-d95ac91bc369), [Whereby "Your accounts"](https://mobbin.com/screens/6e2dae71-0e89-4e82-8151-273e444af8de), [ClickUp "Select an account"](https://mobbin.com/screens/cd12e57c-a545-428d-b96d-78a1418c3d0d))

## Flow
1. User arrives at a destination where multiple known identities could apply (multi-session or remembered accounts).
2. Chooser lists each identity with avatar + name + email, stating the destination: "Choose an account to continue to Proton Mail".
3. Signed-out-but-remembered accounts are listed too, marked "Signed out" (Grammarly) or with per-account "Sign out" links (Proton).
4. Always one more row than the account list: "Add another account" / "Sign in with a different account" (Confluence, Grammarly, ClickUp "Sign into another account").
5. Bulk escape: "Sign out of all accounts" (Proton), "Log out" (Confluence, Whereby).
6. Pick → continue to the original destination under that identity. ClickUp embeds this as a modal directly over the target resource (a form), resolving identity in place.

## Use when
- Combination (3) when remembered identities exist on the device — let the user pick the identity that has access before showing a credentials form.
- Combination (1)/(2) when the fix is plausibly "you're on the wrong account, not the wrong org" — Google-Docs-style ask-on-this-doc.
- Multi-session support exists (several identities simultaneously authenticated).

## Avoid when
- Single-session apps with no remembered identities — it degenerates to a sign-in form with extra steps.
- The mismatch is org-level under ONE identity (our primary tenant model) — choosing accounts can't fix an activeOrganizationId problem; use the workspace router or mismatch interstitial.

## Sad paths observed
- Stale/abandoned accounts pollute the list: Grammarly provides "Remove an account"; Proton per-account "Sign out".
- None of the named account is right: every observed variant keeps "use a different account" as a permanent row, so the chooser never traps.
- Cross-brand identity confusion: The New Yorker explains WHY it's asking ("You recently signed in to another Condé Nast brand. Would you like to continue with the same account?") — the explanation prevents mistaken continuation ([ref](https://mobbin.com/screens/7655bbac-d2ec-49c1-a2df-40039506c0c6)).

## Accessibility
- List rows expose name AND email as text (distinguishes same-name accounts for screen readers).
- Destination named in the heading ("to continue to Proton Mail") so the choice has context.
- Status ("Signed out", "Current") as text badges, not color.

## Default verdict for our stack
VIABLE — secondary to the workspace router: Event State's tenancy is org-switching under one Better Auth identity, so account choosing only matters if we ship multi-session/remembered-accounts; keep as the combination (3) enhancement, not the core mechanism.
