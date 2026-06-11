# Pattern: Credential carries its own plan B — offline promise, readable code, gate routing

**Surface:** check-in-qr / attendee credential · **Observed in:** StubHub (refs: https://mobbin.com/flows/bd8bafeb-7a6d-4d9d-9ea3-7033b781f5fe)

## Flow
1. The ticket card states the guarantee up front: "**Available offline** — QR / Barcode" — the attendee knows before leaving WiFi that the code will render.
2. Under the barcode, a **human-readable code** ("8E92-GB9DASV7") — when glass is cracked, print is faded, or the camera refuses, staff types it (pairs with the scanner's keyboard mode).
3. Physical routing on the credential: "**ENTER AT MARINA GATE**" — the ticket tells you WHERE to be scanned.
4. Order number + section/row/seat strip for desk lookups.

## Use when
Any credential that will be presented in a basement conference hall, a parking structure, or a 2,000-person WiFi dead zone — i.e., always.

## Avoid when
The readable code must not be the SAME secret as a long-lived QR token if codes are shoulder-surfable at scale — short display codes that map server-side beat printing the raw token.

## Sad paths observed
- Screenshot fraud: "A screenshot of your ticket will not be accepted" printed on the credential (deterrence by copy even without rotating codes).

## Accessibility
The readable code IS the accessibility fallback (screen-reader users can speak it to staff); ensure it's selectable text, not baked into an image.

## Default verdict for our stack
RECOMMENDED — legacy QR pages render live (no offline statement, census shows no cached credential) and the 32-char token is machine-only (nobody types 32 chars at a door); a short display code + venue/desk hint on the credential is a cheap, high-leverage steal.
