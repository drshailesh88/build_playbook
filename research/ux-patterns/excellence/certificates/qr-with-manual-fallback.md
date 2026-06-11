# Pattern: QR always paired with a human-typable fallback code + URL

**Surface:** certificates / artifact + verify · **Observed in:** Zapier, IFTTT, OpenAI, Kajabi, Udemy, Uxcel, Skillshare, StubHub (refs: https://mobbin.com/screens/e1db9e52-110b-49b4-9d0a-1fcd881c19b3, https://mobbin.com/screens/1b4d06e6-2413-4c14-b7a8-c543075bb3ec, https://mobbin.com/screens/811a4fa6-865c-4a41-9385-b8995e326ba7, https://mobbin.com/screens/6f26edde-fdbb-4cbd-aace-e3161e09fe04, https://mobbin.com/screens/1488a72e-daa5-4ae8-9013-36fdd4d944a7)

## Flow
1. Every observed QR ships an escape hatch: "Can't scan this barcode? Copy code instead." (Zapier); "Can't scan QR codes? You can manually enter this text code into your app. KAV4 5CNW W7EQ MENP" (IFTTT — grouped 4-char chunks); "Trouble scanning?" link (OpenAI/Kajabi).
2. On certificate artifacts the equivalents are printed beside/instead of the QR: short URL "ude.my/UC-…" + cert number (Udemy); "ID: 854VANBUFU" + QR (Uxcel); serial under the barcode (StubHub).

## Use when
Any QR on a printed or PDF certificate — print kills scannability (low-res, photocopies, B&W) and verifiers may be on the same device as the image.

## Avoid when
N/A — pure additive; the only failure is an UNGROUPED 40-char token as the "fallback" (make IDs short and chunked, IFTTT-style).

## Sad paths observed
- The fallback IS the sad-path handling for camera-less/print contexts.

## Accessibility
The typed code + URL is the accessible alternative to the QR image — mandatory, not optional.

## Default verdict for our stack
RECOMMENDED — legacy prints a certificate number (census #12) but no QR/short-URL on the artifact is recorded; print number + short verify URL + QR together, ID chunked for typing.
