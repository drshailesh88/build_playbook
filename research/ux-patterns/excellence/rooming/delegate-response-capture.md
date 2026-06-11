# Pattern: Frictionless delegate response (tokenized RSVP + declared status side-effects + per-guest email ledger)
**Surface:** rooming · **Observed in:** Partiful, Luma, GitHub, Sketch, Eventbrite
(refs: https://mobbin.com/screens/a29986cf-f78b-4fb9-a8a8-466acba9f71e , https://mobbin.com/screens/1cccc0a9-6c99-4842-9f30-8ac575ab9a41 , https://mobbin.com/screens/33958ae6-dc90-4a00-9697-24366acbe5b0 , https://mobbin.com/screens/63ebd23e-0196-400c-8bf7-0b9ee5338476 ; raw: `_raw/by-pattern.md` §P24/P37)

## Flow
1. Three-button response with near-zero identity friction: "I'm Going / Maybe / Can't Go" + name + phone ("Just for event updates. No spam.") — no login wall (Partiful).
2. Tentative-auto-update contract: "When the host picks a time, your RSVP will auto-update." (Partiful Find a Time).
3. Host-side review gate insertable: "Require Guest Approval" between response and confirmed (Partiful).
4. Wrong-identity escape hatch: "Request access with a different email" (Sketch); transparency note about what the org sees (GitHub).
5. Status changes declare their side-effects BEFORE commit: "We will send an email to the guest when you change their status." (Luma).
6. Per-guest communications ledger on the person record: "Registration Confirmation ✓ Delivered … 8 June 2023 at 03:30 GMT-4 / Registration Removed / Event Invitation" with per-item view (Luma).

## Use when
Delegates must confirm/decline a proposed room assignment without accounts; ops needs proof of what each delegate was sent and when.

## Avoid when
Internal ops actions — side-effect declarations matter at status boundaries, not on every edit.

## Sad paths observed
Maybe/Can't-Go are first-class; rejection reversible and explained ("The guest will be able to rejoin."); capacity interlock ("10/10 spots left"); pending-approval guests visibly blocked at check-in.

## Accessibility
Response buttons large, labeled, and reachable from an email link; ledger rows are text with timestamps + timezone.

## Default verdict for our stack
RECOMMENDED — the delegate confirmation page should be Partiful-shaped (proposal at a glance → Confirm / Request change / Decline via tokened link), and Luma's two sentences are the most transferable finds of the sweep: declared side-effects on every status change, and a Communications ledger per delegate record.
