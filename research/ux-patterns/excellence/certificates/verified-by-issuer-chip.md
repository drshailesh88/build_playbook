# Pattern: "Verified by {network}" chip — third-party verification beats self-claim

**Surface:** certificates / ecosystem-trust · **Observed in:** Upwork × Credly (refs: https://mobbin.com/flows/33e5892c-973b-43bd-8883-30def3491463, https://mobbin.com/flows/51f133f7-1918-42b5-8b80-f7058e9eb97b)

## Flow
1. Empty state offers BOTH paths with an incentive: "Listing your certifications can help prove your specific knowledge or abilities. (+10%) You can add them manually or import them from Credly."
2. Import modal: checkbox rows of the user's Credly credentials, "Unlink account / Cancel / Import".
3. Imported credential renders with the trust differentiator: green "✓ Verified by Credly" chip + skill tags + "View certification link"; manual entries get no chip — just optional Credential ID/URL fields.
4. Announcement banner pattern: "Now you can add certifications with Credly, a third-party digital credential network."

## Use when
EventState is the ISSUER side of this loop: certificates carrying a stable Credential ID + verification URL are what downstream platforms (Upwork, LinkedIn) can render as "verified".

## Avoid when
Don't build a proprietary "verified" chip for self-claims inside your own product — the chip's value is that a THIRD party vouches; a self-issued chip is decoration.

## Sad paths observed
- Manual fallback always coexists with verified import — never make verification the only path.

## Accessibility
Chip is icon + text ("Verified by Credly"), not icon-only.

## Default verdict for our stack
VIABLE (V2, ecosystem play) — exposing Open Badges/Credly-compatible metadata would let EventState CME certificates appear as verified credentials elsewhere; V1 prerequisite is just stable IDs + public verify URLs (already recommended).

## Live-web corroboration (2026-06-11)
Observed live: Badgr/Parchment exposes "View JSON" (the Open Badges assertion) beside the human-readable page (https://badges.parchment.com/public/assertions/EVRYzlD2RO26uyAKFxkOGQ) — the machine-verification layer is one button, not a separate product. Also observed: issuer-trust is itemized separately from credential-validity ("This issuer is verified by Accredible"; Certifier's honest partial-trust: "The OR Society organization has not been verified by Certifier." without failing the verdict). White-label custom credential domains are the industry's premium lever (Certifier $99/mo + $19/mo "Verified Issuer") — tenant-branded verify domains are a monetizable surface. Refs: `_raw/live-web-verification.md`, `_raw/live-web-issuer-side.md`.
