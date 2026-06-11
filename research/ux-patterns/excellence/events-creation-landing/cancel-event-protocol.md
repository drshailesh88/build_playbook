# Pattern: Cancel-event protocol (notify by default, customizable message, honest tombstone)

**Surface:** events-creation-landing · **Observed in:** Luma web (https://mobbin.com/flows/9f7afd4b-2ccf-44d0-9224-0b3cf1b1eef1, https://mobbin.com/flows/56954a40-0e2f-49b1-a87a-2a2d22eb69bc), Cal.com web (https://mobbin.com/screens/ae2c874a-98e8-4b13-ad9c-9f474a308037, https://mobbin.com/screens/d7e41388-1eea-4ccd-a246-0a73dd6b3efe), WhatsApp web (https://mobbin.com/flows/8c51c83a-4d16-4da1-8fc2-223785cbdc6d), Discord web (https://mobbin.com/screens/af86f40b-3343-4fb3-ad15-33f973aa151a), Peerspace web (https://mobbin.com/flows/834ca9f4-c1b3-4544-b355-896a6243da17)

## Flow
1. The destructive copy itself promises guest care: "Cancel Event — … This operation cannot be undone. If there are any registered guests, we will notify them that the event has been canceled." (Luma).
2. The cancel modal offers a customizable notification: "If you aren't able to host your event, you can cancel and we'll notify your guests." + "Customize Email" toggle revealing Subject ("Tech Meetup was canceled") and Body fields (Luma).
3. A reason is collected and SHARED: "Reason for cancellation" textarea captioned "ⓘ Cancellation reason will be shared with guests"; the safe button is "Nevermind" (Cal.com). Peerspace goes further: required reason dropdown + required personal message to the counterparty + refund math shown before confirm.
4. The dead-link problem is solved with a tombstone: the old URL keeps resolving to "This event is canceled" with the reason, the date STRUCK THROUGH, and the surviving fact sheet (Cal.com). WhatsApp keeps the event card with a red "Event canceled" tag + strikethrough.
5. Less-destructive alternatives are offered inline: "To cancel specific sessions instead of the whole series, please go to the Sessions tab…" (Luma); per-occurrence red "Canceled" tag while the series page lives on (Discord); "Reschedule request sent" as cancel's sibling (Cal.com).
6. Cancel and reschedule are symmetric verbs with an audit trail: paired "Reschedule / Cancel" buttons; both leave who-did-it-and-why lines in the list ("Canceled by Samantha Lee: 'Apologies for this inconvenience…'" / "Rescheduled by {name}: '{reason}'"); reschedule shows "Former Time" struck through beside the new time before commit, then "Event rescheduled. A notification has been sent." (Calendly, https://mobbin.com/flows/b585ee1f-1669-49b5-a8d2-99c3d1f63e63, https://mobbin.com/flows/7869f96f-d291-4c8d-b153-186a237641fc). Skiff gates every date edit through a notify-or-not modal: "Do you want to send an update to other participants?" (https://mobbin.com/flows/51792742-3b11-4828-a750-a0c2b14c2a85).

## Use when
Any event with registrants. The tombstone is non-negotiable once links have been shared — a 404 on a shared link reads as a scam.

## Avoid when
Luma's cancel = permanent DELETE (page gone) — observed, but AVOID for a system of record: medical/academic events need the record and audit trail preserved. Cancel must be a state, not a deletion.

## Sad paths observed
- "Canceled events cannot be restored" warned pre-commit (WhatsApp).
- This whole pattern IS the sad path made first-class; the unhappy variant is the unobserved one (silent cancel, dead link).

## Accessibility
Strikethrough paired with the explicit text "This event is canceled" (not strikethrough alone); destructive button labeled with the consequence.

## Default verdict for our stack
RECOMMENDED — old app's cancel is `confirm()` + status flip with NO guest notification and no distinct cancelled landing state. V1: cancel modal with consequence copy + notification (ties to communications module) + cancelled tombstone state on the public page. Keeps the old app's terminal-state machine; supersedes its silent UX.
