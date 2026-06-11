# Pattern: Non-blocking scan failure — camera stays live, recovery is named

**Surface:** check-in-qr / scanning errors · **Observed in:** Walmart, Grab, Lyft, Lime (refs: https://mobbin.com/screens/6dd5b013-585a-4a64-827b-2b1ee6972e25, https://mobbin.com/screens/b4ba2d47-f27e-4f83-ad67-119461d5d989, https://mobbin.com/screens/3ce9f604-607c-4a09-9201-da5982e2c7a2, https://mobbin.com/screens/3836a17e-0491-4b66-89ce-fa6172c3ea99)

## Flow
1. Best variant (Walmart): failure renders as a bottom CARD over the live camera — "No matching items found — Try scanning again, or enter the number manually" + [Enter number manually] + [Dismiss]. The scanner keeps scanning; the next attendee's code can be caught immediately.
2. Modal variant (Grab/Lyft): "This QR code is invalid — Please scan another one. [Try again / Cancel]" — acceptable but costs a dismissal tap per failure.
3. Every failure message names the NEXT ACTION (scan again / enter manually / find another vehicle) — never a bare error.
4. Reasoned rejection (Lime): when the system knows WHY ("vehicle under maintenance"), the reason and the alternative are spelled out.

## Use when
Door scanning at volume — failures (faded print, screen glare, foreign codes) are a per-minute event, and each one must cost zero camera restarts.

## Avoid when
Failures that must stop the line (revoked credential, security flag) — those deserve a blocking, visually loud state distinct from soft failures.

## Sad paths observed
This pattern IS the sad path. The distinction worth stealing: soft fail (unreadable/not found → inline card, keep scanning) vs hard fail (ineligible/revoked → blocking state with reason).

## Accessibility
Failure card needs role=alert; with color-coded severity, iconography + text must carry the difference (red/yellow alone fails).

## Default verdict for our stack
RECOMMENDED — legacy has color-coded ScanFeedback cards that auto-dismiss in ~3s (census), which is close; the deltas are the explicit next-action microcopy and the manual-entry button ON the failure card.
