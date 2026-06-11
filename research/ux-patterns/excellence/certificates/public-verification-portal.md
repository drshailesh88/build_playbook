# Pattern: Public verification portal (enter ID / scan → valid · revoked · expired verdict)

**Surface:** certificates / public-verify · **Observed in:** ⚠️ **NOT OBSERVED — FIRST-PRINCIPLES CANDIDATE** composed from adjacent anatomy: Luma scan result, Slite verification states, Eventbrite cancelled ticket, Binance expired QR, Aboard code-gated lookup, Udemy/Uxcel artifact trust marks (refs: https://mobbin.com/screens/d3777ec9-8cb9-412f-a4a6-cb5046285df8, https://mobbin.com/screens/784fd37d-3429-4f47-b58c-0b6fc0ffed07, https://mobbin.com/screens/7dedb891-b93a-48ad-9e3f-3463ae4064c6, https://mobbin.com/screens/92c083bc-d3d5-40ce-9146-5049c02e14b0, https://mobbin.com/screens/f1adec7e-f866-42d4-859a-8346297880b9)

HARVEST HONESTY: three dedicated queries across two agents found NO Credly/Accredible-style "verify this credential" page on Mobbin. The anatomy below is synthesized from cited adjacents, not observed end-to-end.

## Flow (synthesized)
1. Entry: certificate URL/QR lands directly on the verdict; manual path = code-gated lookup ("Please provide the access code…" — Aboard) for typed certificate numbers.
2. Verdict first, glanceable, in words + color: green "✓ Check In Successful"-style toast/banner (Luma) → for certificates: VALID / REVOKED / SUPERSEDED / EXPIRED as labeled states (state vocabulary from Slite: verified / outdated / expired).
3. Below the verdict, the record card: recipient name, certificate type, event, issue date, issuing org — Luma's three-column meta (Status / Registered / Checked In) is the template.
4. Revoked state shows the FACT plainly without leaking the reason publicly (reason is admin/audit data); Eventbrite's "Successfully cancelled order" banner over a voided ticket is the visual precedent.
5. Stale-QR sad path: "QR code expired — Refresh" inside the frame (Binance) for time-limited verification links.

## Use when
"Anyone verifies authenticity" is a stated job — employers, councils, audit bodies — and the URL is printed on every artifact.

## Avoid when
Never omit for credentials; but avoid exposing PII beyond the claim (no email, no phone) and avoid a bare JSON/api response standing in for the page.

## Sad paths observed (adjacent)
- Unknown/garbled ID → not-found state must be distinct from REVOKED (don't accuse a typo of fraud). [first-principles]
- Verification of a SUPERSEDED certificate should point to "a newer certificate exists" without exposing the new holder data. [first-principles, legacy supersession chain]

## Accessibility
Verdict as text + icon, never color alone; record card is plain text.

## Default verdict for our stack
RECOMMENDED — legacy already HAS verify-by-token + counter (census #42–43) and pathways assert verify-result-revoked (PATH-certificates-003); this card defines the page those mechanics deserve. EventState can EXCEED the observed industry here.
