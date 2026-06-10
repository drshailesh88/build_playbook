# Pattern: User/admin-configurable session timeout duration
**Surface:** session-expiry · **Observed in:** Kraken, Vanta (refs: [Kraken auto sign-out](https://mobbin.com/screens/5dad215d-c5ce-4832-9dcb-4e8b3d9479fe), [Vanta idle timeout](https://mobbin.com/screens/f30e4014-8b3e-465e-95a2-83c09dc35e37))

## Flow
1. Kraken (user-level, Security settings): "Change auto sign-out duration — Adjust the duration for automatic sign-out after account inactivity." Radio options: 1 hour / 8 hours (default) / 1 day / 7 days / Other…; Cancel/Save.
2. Vanta (workspace-admin-level, Settings → Security): "Idle session timeout — Choose a session timeout length. If your team members remain idle during this period, they'll be logged out automatically." Dropdown: 30 minutes → 30 days; applies to the whole tenant.
3. Default value labeled explicitly (Kraken: "8 hours (default)").

## Use when
- B2B multi-tenant with security-conscious customers — tenant admins expect to set idle-timeout policy (compliance asks for it); user-level control suits high-security consumer (exchange/banking) products.

## Avoid when
- MVP without enterprise compliance pull — a hardcoded sensible default + the warning-countdown pattern covers most needs; exposing the knob early adds policy complexity (which timeout wins, user vs tenant?).

## Sad paths observed
- Both label the default and the consequence in plain language before saving; Vanta scopes it clearly to "your team members" (tenant-wide effect disclosed).

## Accessibility
- Plain radio group / select with descriptive labels — standard form semantics.

## Default verdict for our stack
VIABLE (later) — park as a tenant-security setting for the enterprise tier; not part of the initial expiry UX, but the schema should not preclude per-tenant timeout policy.
