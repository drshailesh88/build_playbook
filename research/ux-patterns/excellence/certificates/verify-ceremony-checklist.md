# Pattern: Verify ceremony — animated per-fact checklist with separate overall verdict

**Surface:** certificates / public-verify · **Observed in (LIVE WEB):** Credly, Accredible, Sertifier, Certifier (refs: https://www.credly.com/badges/862230de-19d7-4586-80d9-184a485f9aeb (verify modal, valid + expired), https://www.credential.net/d4bd834b-0937-4b7c-993e-e923567dc053, https://verified.sertifier.com/en/onboarding-credential/22852900695451/, https://credsverse.com/credentials/60cd0068-2853-4ac1-ae01-36421c4d6f7f — transcripts in `_raw/live-web-verification.md`)

## Flow (observed)
1. "Verify" button on the public credential page opens a modal that runs a visible checklist: rows resolve "Verifying..." → "Verified" one by one (Credly: Issued on / Issued by / Issued using Credly / Issued to / Accepted on / Last updated; Sertifier: "Verifying the Owner…" / "Checking Credential Status…" → "[X] is verified."; Certifier: 4 named checks with sentence results).
2. After the rows, a FINAL verdict banner — separate from the per-fact rows: Accredible "This [Title] Credential is VERIFIED" + "This digital credential was securely issued via Accredible and its information is valid."
3. Trust chain is itemized, not monolithic: "This issuer is verified by Accredible" and "The owner of this credential has been verified" are independent rows — Certifier shows the honest partial-trust state: "The OR Society organization has not been verified by Certifier." WITHOUT failing the overall verdict ("This is the valid credential").
4. Accredible appends a "Full credential history" audit list ("2019-07-30 • Credential Issued") inside the dialog.
5. The split does real work on sad paths: Credly's expired credential shows ALL facts still verifying, only the "Expired on" row reading "Verification Failed", and the banner verdict "Expired" — facts and status are independently legible.

## Use when
The verification moment needs to feel like an act, not a label — third parties (councils, employers) screenshot this modal as their evidence.

## Avoid when
Don't fake the animation latency (the checks are instant server-side; a brief staged reveal is theater that builds warranted trust, but multi-second fake spinners erode it); don't collapse issuer-trust and credential-validity into one bit — the partial-trust state needs to be expressible.

## Sad paths observed
- Per-fact failure with overall verdict intact-but-degraded (Credly expired).
- Unverified-issuer disclosure without verdict failure (Certifier).

## Accessibility
Checklist rows are text; staged reveal needs aria-live polite; final verdict must be the modal's accessible name.

## Default verdict for our stack
RECOMMENDED as the verify-page verdict presentation — per-fact rows (issued-to / issued-by / status / dates) + separate banner verdict maps exactly onto the legacy verify-token data and the revoked/superseded states pathways already assert.
