# Pattern: No-show as a guided protocol — grace timer, attempted contact, reason, correction path

**Surface:** transport · **Observed in:** HopSkipDrive, Uber, ADA paratransit practice, Onfleet, Via, Zūm, Limo Anywhere
(refs: P7, F15, F16, F17, A8, A43, A42, A45 — URLs in `_raw/`; key: https://help.hopskipdrive.com (\"I Can't Find Rider\"), https://dredf.org/ADAtg/noshow.shtml)

## Flow
1. No-show is a WIZARD, not a button: drivers tap "I Can't Find Rider" and "the app will guide them through the necessary steps to look for the rider, alert the appropriate people if they can't find them, or report that the ride isn't needed" (HopSkipDrive).
2. Grace timers precede it: Uber 2 min (X) / 5 min (premium) from driver arrival; paratransit waits the policy window; Limo Anywhere drivers start a wait timer at "Arrived".
3. Attempted contact is mandatory before declaring: "dispatchers should attempt to contact the rider, using any telephone number(s) in the trip record" (DREDF); HopSkipDrive escalates through "the other contacts listed on the rider's account", auto-cancelling after 20 minutes.
4. The outcome is a structured record: a reason from a configurable taxonomy, with notes requirable per reason (Onfleet custom completion reasons; Via "require a reason for a no-show"; Zūm cancel-with-reason).
5. Mis-marks are correctable: "If a task is marked as failed incorrectly, a dispatcher would have the ability to edit the status to 'Succeeded'" (Onfleet).
6. Passenger self-cancel upstream prevents the no-show — with the explicit caveat that transport cancellation does NOT auto-update the upstream system of record (Zūm: notify the school separately).

## Use when
A passenger isn't at the hub at departure. The protocol releases the vehicle defensibly: timer → contact attempts → structured no_show → batch departs.

## Avoid when
Fee-centric consumer mechanics (Uber/HopSkipDrive charges) — conference attendees aren't charged; the record-and-escalate paratransit model fits, the fee model doesn't.

## Sad paths observed
- No-shows outside the rider's control shouldn't count against them (DREDF) — reason taxonomy needs an "our fault / flight late" category.
- The dispatcher-side countdown + structured attempted-contact log UI is NOT documented anywhere — FIRST-PRINCIPLES candidate (see first-principles-candidates.md #5).

## Accessibility
Not observable from documentation sources.

## Default verdict for our stack
RECOMMENDED — legacy `no_show` was a bare server-side status with no UI and no protocol. Steal: grace expectation, attempted-contact step with the passenger's phone surfaced, required reason, dispatcher correction path (status machine already allows pending→boarded override; add the failed-mark fix).
