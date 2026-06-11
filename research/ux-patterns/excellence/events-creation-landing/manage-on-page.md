# Pattern: Management lives on the page (host dock, manager banner, edit drawer over live context)

**Surface:** events-creation-landing · **Observed in:** Partiful web/iOS (https://mobbin.com/screens/f239caae-1113-4626-ae1f-435334bed2fa, https://mobbin.com/flows/a35cf433-e4cb-487f-9f73-fba032b906e1), Luma web (https://mobbin.com/screens/29b6c4c9-223c-4d42-a632-cbfdf78de2bb, https://mobbin.com/flows/319afbe7-1939-4ada-ae3c-61a3b4d61bf0, https://mobbin.com/flows/503f562f-e287-4127-99b0-a38cdaa5fd6c)

## Flow
1. **Host dock on the public page:** floating pill dock — Edit / Text Blast / [live counter "2 Going"] / Invite / "···" overflow — the counter sits in the CENTER slot, making distribution progress the focal point; it flips context ("1 Invited" after sending) (Partiful).
2. **Overflow holds the long tail:** Event Settings / Generate Flyer / Questionnaire / Clone Event / Contact Us / Cancel Event (destructive, red, last) (Partiful).
3. **Manager banner:** a manager visiting the public URL sees "You are a manager of this event." + "Manage Event" button inline — no confusion about which view they're in (Luma).
4. **Edit-in-context:** "Edit Event" opens a right-side drawer OVER the manage page (Basic Info / Appearance / Time / Location) with sticky "↻ Update Event"; the page stays visible behind (Luma). Partiful goes further: the live page itself is the editor (inline fields with "Press ENTER to confirm ↵" hints).
5. **Privacy expectation-setting where data shows:** "The address is shown publicly on the event page." note inside the manage view (Luma).
6. Series-edit guard: "Time and Location — Update the time and location of this event series on the Sessions tab." — single edits can't silently fork a series (Luma).

## Use when
The host's core loop is watch-the-count + tweak + distribute. The manager banner is universal — any system where staff hit the public URL.

## Avoid when
Complex admin (RBAC'd team, payouts, multi-module config) can't all live on the page — keep the deep workspace; the dock handles only the hot loop. Inline-edit-on-live-page risks accidental edits for multi-admin tenants; prefer the drawer.

## Sad paths observed
- Destructive action (Cancel) styled red and placed last behind the overflow — friction by placement.
- Edits to live events apply immediately (no observed "pending changes" state) — for high-stakes pages consider explicit save.

## Accessibility
Dock buttons have text labels under icons; counter is text; drawer keeps focus management within (modal pattern).

## Default verdict for our stack
RECOMMENDED (banner + drawer) — manager banner on the public landing page and edit-drawer-over-workspace are direct V1 steals; the old app's workspace and public page are completely disconnected today. The consumer host-dock on the public page is AVOID for a multi-role conference SaaS (workspace is the control plane).
