# Pattern: Tenant-Blocked Screen Naming the Current Org
**Surface:** cross-tenant-deep-link · **Observed in:** Clearbit, Framer (refs: [Clearbit "Request access to the platform"](https://mobbin.com/screens/a44c4021-c6c6-45f2-8223-7ea295304c07), [Framer workspace no-access](https://mobbin.com/screens/23ea2dbf-a2a6-4fe9-a118-8dda59d4c846))

## Flow
1. Signed-in user lands somewhere their CURRENT TENANT (not their identity) cannot go.
2. Screen names the tenant as the blocked unit: "Your current team, Jane Smith, does not have access to the Clearbit platform" (Clearbit); "Looks like you don't have access to this workspace. Contact the owner and try again" (Framer).
3. Clearbit renders an identity card: the signed-in Google account with a Sign out button, plus the current team labeled with a "Current" badge — user can see both layers (who am I / which team am I acting as).
4. Remediation paths are explicit and external: "Contact Clearbit Sales to request access", "If you believe you should already have access with the current team, email customersuccess@..." (Clearbit); "Contact the owner" (Framer).
5. No self-serve resolution — the user leaves or switches identity.

## Use when
- Combination (2) where the block is org-level (the whole tenant lacks the entitlement or membership), and the distinction "your org is blocked, not you" prevents users from futilely re-authenticating.
- Plan/entitlement gates that ride on the same surface as access gates.

## Avoid when
- The user could fix it themselves by switching org — this pattern offers no org switcher; if the user is a member of the target org, show a switch/prompt pattern instead.
- Tenant existence is sensitive (same caveat as request-access).

## Sad paths observed
- "I think I should have access" case is handled with a dedicated escalation line (Clearbit's customersuccess email) instead of leaving the user looping.
- Framer's version sits inside an app shell with nav still alive — user retains escape routes; but its "Something went wrong" header misclassifies a permission state as an error (anti-pattern to copy carefully).

## Accessibility
- Clearbit: identity and team rendered as text rows with explicit "Current" badge — state is readable, not color-encoded.
- All remediation paths are real links with descriptive text, not bare "click here".
- Framer's variant buries the explanation in small gray text under a generic heading — weaker; lead with the specific state.

## Default verdict for our stack
VIABLE — for org-level entitlement blocks (suspended org, plan gate on a feature deep link); for plain membership mismatch our combination (1)/(2) patterns are better fits.
