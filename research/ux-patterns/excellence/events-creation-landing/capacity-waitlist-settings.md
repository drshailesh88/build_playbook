# Pattern: Capacity & waitlist settings with inline feature-conflict surfacing

**Surface:** events-creation-landing · **Observed in:** Partiful web (https://mobbin.com/flows/0a82fa08-7f5d-48f1-b27d-d7e3205afe2b, https://mobbin.com/screens/6a0ac189-ab1e-4613-896d-5e7f91992216), Luma web (https://mobbin.com/screens/05ebc46b-2f97-443b-8cd9-71ede5503bdf, https://mobbin.com/screens/905febf2-3c69-4661-91c5-2e5fb338ecef, https://mobbin.com/screens/c63fb370-fe68-4d1d-a699-84e10f1b062e), Eventbrite web (https://mobbin.com/screens/e2123250-ae9b-4714-90ab-6b28daaaf7d6, https://mobbin.com/flows/49bae9fe-bcc3-4daf-91ea-5fc2c7b97de2), Square web (https://mobbin.com/screens/d554aeed-a3ae-43fc-8242-557f1f40be52)

## Flow
1. Capacity defaults to "Unlimited" and is an edit-row, not a required field (Luma create). Setting it is one inline numeric: "(Optional) Max Capacity — 10 spots" with hint "Press ENTER to confirm ↵" (Partiful).
2. Waitlist nests directly under capacity with its behavior spelled out: "Enable Waitlist — Allow guests to join a waitlist once max capacity is reached & automatically update their RSVP and notify them if spots open" (Partiful).
3. Related dials sit adjacent: "Limit +1s — Set how many additional persons each guest may bring" ("Up to 1 ⌄"); "Require Approval" toggle beside capacity (Luma); approval copy explains the consequence: "Guests request to 'Get on the list'. Only guests you approve can see event details." 
4. Incompatible combos are declared ON the control, before failure: "ⓘ Not supported with Guest Approval" (on Max Capacity), "ⓘ Not supported with Chip-in or Find a Time" (on Guest Approval), "ⓘ Not supported when Guest List is hidden" (Partiful) — constraint surfacing as a reusable microcopy pattern.
5. Defaults are disclosed where they bite: "Accept RSVPs — ⓘ By default, RSVPs close 2 hours after the event starts" (Partiful). Eventbrite tracks "Event capacity ⓘ — 0/25 — Edit capacity" against per-ticket allocations.
6. Capacity is a BEHAVIOR, not a number: Luma's popover reads "Max Capacity — Auto-close registration when the capacity is reached. Only approved guests count toward the cap." with paired "Set Limit / Remove Limit" buttons; the Guests tab shows an at-a-glance progress bar ("0 approved guests / cap 50") beside reversible "Close Registration"/"Open Registration" action cards with state restated in three places ("Registration is now closed.").
7. Full waitlist policy machine (Eventbrite): trigger (per-ticket sellout vs total capacity), max size ("Zero for unlimited"), data collected, claim window ("Time allowed for attendees to claim their ticket"), auto-response message — every release rule explicit.
8. Organizer bypass is explicit about side effects and consent: "Add People Directly — They will be marked as approved immediately, without needing to pay or register." + "⚠ Please only add people who have consented to be added." (Luma).
9. Capacity feeds the landing page as designed states: "{n}/{cap} spots left" line, "Near Capacity" chips, "⏳ Limited Spots Remaining — Hurry up and register before the event fills up!" banner (see landing-sad-states.md).

## Use when
Any registration-capped event. The inline-conflict pattern generalizes: ANY pair of mutually exclusive features should declare the conflict on both toggles.

## Avoid when
Hard venue-safety caps that must never be edited downward below registrations — then the edit needs a guard, not a free numeric. Don't show "spots left" scarcity for professional events where it reads as marketing pressure (make it a visibility toggle).

## Sad paths observed
- Capacity reached: "10/10 spots left" + waitlist auto-promotion promise ("automatically update their RSVP and notify them").
- Conflicting toggles: cannot be co-enabled; the note prevents the attempt instead of erroring after.

## Accessibility
Conflict notes are text adjacent to the toggle (ⓘ + sentence), not tooltip-only; counters are text.

## Default verdict for our stack
RECOMMENDED — old app stores capacity in `registrationSettings` JSONB and merely displays a number on the landing page. V1: capacity as an edit-row with waitlist toggle + behavior sentence; adopt inline-conflict surfacing app-wide (e.g. approval vs auto-confirm). Waitlist mechanics execute in the registration module — this card owns only the settings surface and landing-state contract.
