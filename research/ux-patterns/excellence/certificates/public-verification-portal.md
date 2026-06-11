# Pattern: Public verification portal (credential URL / ID lookup → verdict)

**Surface:** certificates / public-verify · **Observed in (LIVE WEB, 2026-06-11 deep harvest):** Credly, Accredible (credential.net), Certifier (credsverse), Badgr/Parchment, Sertifier, Microsoft Learn (refs: https://www.credly.com/badges/862230de-19d7-4586-80d9-184a485f9aeb, https://www.credential.net/d4bd834b-0937-4b7c-993e-e923567dc053, https://credsverse.com/credentials/60cd0068-2853-4ac1-ae01-36421c4d6f7f, https://badges.parchment.com/public/assertions/EVRYzlD2RO26uyAKFxkOGQ, https://verified.sertifier.com/en/search/, https://learn.microsoft.com/api/credentials/share/en-us/DieterRauscher/9CAD3CFEBE5DB4A7?sharingId=3C39B423744ABF3C — full anatomy per page in `_raw/live-web-verification.md`)

UPGRADE NOTE: this card was first published as a ⚠️ first-principles candidate (no Mobbin coverage — that remains true). The 2026-06-11 live-web harvest observed six real platforms end-to-end; the card is now OBSERVED. Mobbin-absence note retained in INDEX coverage.

## Flow (observed)
1. **The credential URL IS the verification page** — every platform resolves the shared link to a canonical public page; Microsoft Learn proves the minimal form: no ceremony, trust = domain + "Status: Active" chip + dual identifiers (Credential ID + Certification number) + earned/expires dates.
2. **Manual lookup portal** for typed IDs exists at Sertifier (verified.sertifier.com/en/search) and Accredible (accredible.com/verification); PMI runs a registry. Sertifier's not-found verdict is the only one observed live: "Oops! Sorry, there is no user matching with the given username." + "Report an issue" — a typo gets a neutral not-found, never a fraud accusation.
3. **Verdict structure:** per-fact verification rows are SEPARATE from the overall verdict banner (see verify-ceremony-checklist card). Credly expired example: every fact still verifies, the "Expired on" row shows "Verification Failed", final banner = "Expired".
4. **Record card below the verdict:** recipient name, credential title, issuer (linked + issuer-verified chip), issue/expiry dates with the no-expiry case explicit ("Expires on: No expiry date" — Sertifier; "Does not expire" — Accredible).
5. **Freshness proof:** Badgr/Parchment shows "Verified — Last verified by Parchment Digital Badges on {today}" + a "Re-verify Badge" button — verification is an event with a timestamp, not a static label.
6. **Machine layer:** Badgr exposes "View JSON" (Open Badges assertion) beside the human page; Credly's API returns HTTP 410 Gone for revoked assertions.
7. **Error-report affordance on the public page:** "Want to report a typo or a mistake? → Contact Issuer" (Certifier) — the public page doubles as the correction intake.

## PII norms (observed across all six)
Full name: always public. Email: never. Credly/Accredible/Sertifier link to the recipient's full credential wallet; Accredible exposes recipient LinkedIn; Certifier is the most minimal (name only). Badgr's consent line: "Awarded To — You need this Recipient's permission to verify their identity."

## Use when
Every issued certificate — the URL printed on the artifact lands here; employer, council officer, and recipient all use the same page.

## Avoid when
Don't gate the verdict behind login; don't expose wallet/other-credentials links for medical delegates without an explicit recipient opt-in (follow Certifier-minimal, not Credly-maximal, as the privacy default).

## Sad paths observed (LIVE)
- **Expired (Credly, live):** "Expires:" label flips to red "Expired: June 08, 2023"; Celebrate button disappears; og:title gains "(Expired)" so the state leaks into link previews on LinkedIn/Slack.
- **Not found (Sertifier, live):** neutral message + "Report an issue" — distinct from any negative verdict.
- **Revoked: NOT observed live on any platform** (only Credly docs: revoked assertion → HTTP 410; issuer guidance "revoking leaves a record"). Public revoked-state rendering remains first-principles for EventState — pathways already pin it (verify-result-revoked, PATH-certificates-003).

## Accessibility
Verdict as text + chip, never color alone (all observed); record card is real text duplicating everything printed on the artifact image.

## Default verdict for our stack
RECOMMENDED — now with observed anatomy: canonical page + per-fact rows + overall verdict + freshness timestamp + neutral not-found + Contact Issuer intake; revoked rendering designed first-principles (legacy already has the data). EventState still EXCEEDS the corpus by showing the revoked verdict publicly with supersession pointers.
