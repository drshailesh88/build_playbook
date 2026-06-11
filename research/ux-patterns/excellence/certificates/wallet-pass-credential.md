# Pattern: Email + Download + Apple Wallet trio (credential in pocket)

**Surface:** certificates / recipient-receive · **Observed in:** BlaBlaCar, Apple Wallet, Luma, Eventbrite, StubHub, Qantas, American Airlines, GetYourGuide (refs: https://mobbin.com/screens/0a14903d-3da6-4336-aad6-be549790e2c8, https://mobbin.com/flows/7bd95ae6-065a-4ccd-977e-61cf4c01a913, https://mobbin.com/screens/aa52fbb3-9cc8-40e8-a47c-d50ccc906558, https://mobbin.com/screens/1488a72e-daa5-4ae8-9013-36fdd4d944a7, https://mobbin.com/screens/4f677b75-1423-427d-bb62-eba32b6b0c2c)

⚠️ EXTRAPOLATION FLAG: only tickets/boarding passes/loyalty cards observed as passes; certificate-as-wallet-pass is inferred (Apple Wallet's "Expired" bucket does contain "Vaccination Certificate" entries — the one direct credential precedent).

## Flow
1. Delivery trio on confirmation: "We just sent a confirmation email with your ticket attached to {email}. If you can't find the ticket please check your spam folder" + [Download the ticket] + [Add to Apple Wallet] (BlaBlaCar).
2. Async generation handled honestly: wallet button disabled with "Apple Wallet tickets are being generated. Please wait a moment." (BlaBlaCar).
3. Pass anatomy: holder name, QR, metadata, official black "Add to Apple Wallet" badge; "Accessible Offline" badge (GetYourGuide); anti-fraud copy "A screenshot of your ticket will not be accepted" + serial under QR (StubHub).
4. Wallet lifecycle: Automatic Updates / Allow Notifications / Suggest on Lock Screen / Remove Pass; expired passes move to an "Expired (9 Passes)" bucket rather than deleting (Apple Wallet).

## Use when
The credential must be PRESENTED in person (conference re-entry, CME sign-off desks) or survive offline.

## Avoid when
A certificate that is only ever printed/framed/uploaded — a wallet pass adds an entire PassKit pipeline for no presentation moment; also skip if Android parity (Google Wallet) can't be funded, or half the audience is excluded.

## Sad paths observed
- Generation latency state; cancelled-order banner over a now-void ticket (Eventbrite) — the revoked-pass precedent.

## Accessibility
Passes inherit OS accessibility; the QR's manual fallback code must be on the pass face.

## Default verdict for our stack
AVOID for V1 / VIABLE for V2 — never attempted in legacy, real pipeline cost, and the attendance/check-in module already owns in-person QR presentation; revisit if certificates gain an on-site presentation job.
