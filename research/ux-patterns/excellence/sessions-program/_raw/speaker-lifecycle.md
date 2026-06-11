# Speaker Lifecycle — Invited to Present, Confirms, Manages Commitments

Job: a speaker/faculty member is INVITED to present, confirms participation via emailed/tokened link, and manages their commitments (assigned sessions, availability, change notifications).
Date: 2026-06-11
Source: Mobbin MCP (search_flows + search_screens, web primary, one iOS probe). Only observed content recorded; every entry cites its mobbin_url. Speaker-portal/CFP-specific coverage on Mobbin is THIN — see Coverage at the end.

## Luma (web)

1. Accepting an invitation (guest) — flow
   - Mobbin URL: https://mobbin.com/flows/28703fea-9a9b-4a8c-aff3-f3946bd89f14
   - Steps observed:
     1. Invite landing page: event detail page with a "Registration" card: "You are Invited — We'd love to have you join us." Invitee's name + email pre-filled (Alex Smith, alexsmith.mobbin+1@gmail.com). Primary button "Accept Invite", secondary "Decline". Host shown ("Hosted By Alex Smith", "Contact the Host" link). "Private Event" badge.
     2. Post-accept state replaces the card: "You're In — A confirmation email has been sent to alexsmith.mobbin+1@gmail.com." Countdown "Event starting in 14h 23m" with "The join button will be shown when the event is about to start." "Add to Calendar" button. Undo path inline: "No longer able to attend? Notify the host by canceling your registration." Below: "Get Ready for the Event — Profile Complete · Reminder: Email" checklist row.
   - Problem solved: zero-friction tokened accept — identity comes from the invite, no login, accept and decline equally visible, with confirmation + calendar + undo all on one page.
   - Sad paths observed: none in this flow (undo path is offered proactively).
   - Microcopy worth stealing (verbatim): "You are Invited"; "We'd love to have you join us."; "You're In"; "A confirmation email has been sent to …"; "No longer able to attend? Notify the host by canceling your registration."; "The join button will be shown when the event is about to start."
   - Mobile/a11y notes: registration card is a single column block; states swap in place (invite → confirmed) so the URL/page stays stable.

2. Coordinator invite funnel + guest list — flow "Guests"
   - Mobbin URL: https://mobbin.com/flows/a8601b45-a4de-450f-8026-8e0b4732872d
   - Steps observed:
     1. Event Overview tab shows an "Invites" panel: "Invite subscribers, contacts and past guests via email or SMS." Funnel stats: "1 / 2 Invites Accepted", "2 Emails Opened", "0 Declined", plus "Recently Accepted" list with name + email.
     2. Guests tab "At a Glance": "1 guest" against "cap 1,000", with breakdown "1 Going · 1 Invited" on a progress bar. Action cards: Invite Guests / Check In Guests / Guest List (with visibility note "Shown to guests" or "Hidden").
     3. Guest List table: searchable, filter "All Guests", sort "Register Time"; rows show name, email, status badge ("Going" green, "Invited" blue) and relative date.
   - Problem solved: coordinator sees the invite funnel (sent → opened → accepted/declined) and per-person status at a glance.
   - Sad paths observed: empty state "No Guests Yet — Share the event or invite people to get started!"
   - Microcopy worth stealing: "Invites Accepted"; "Emails Opened"; "No Guests Yet — Share the event or invite people to get started!"
   - Mobile/a11y notes: status conveyed by colored text badges + word (not color alone).

3. Scheduled emails / reminder audience targeting — screen
   - Mobbin URL: https://mobbin.com/screens/350bc45a-535a-4b72-b165-d39f7acdd270
   - Steps observed: Event "Emails" tab lists Scheduled Emails ("Morning Yoga is starting tomorrow / in 1 hour / in 30 minutes", "Thanks for joining…") each with audience ("To: Approved", "To: Approved, Invited") and send time. Edit panel "Update Reminder Email": date+time picker, "1 day before the event starts." helper, audience chips "Send to guests who are: Approved ×", templated Subject with variable chips ("Event Name is starting Time Until Event"), free Body ("Add your custom message here."), buttons Update Reminder / Send Preview.
   - Problem solved: lifecycle comms scheduled per audience segment (approved vs invited) with variable templating — the chassis for "your session changed" notifications.
   - Sad paths observed: none.
   - Microcopy: "Send to guests who are:"; "Send Preview".
   - Mobile/a11y notes: variable chips are visually distinct from literal text.

## Partiful (web)

4. Attending an event (RSVP) — flow
   - Mobbin URL: https://mobbin.com/flows/746c6688-1714-4ca0-8e30-01311aaf2ec5
   - Steps observed:
     1. Public event page (no login): three emoji RSVP buttons — 👍 "I'm Going", 🤔 "Maybe", 😢 "Can't Go". Scarcity cue "10/10 spots left" (later "8/10 spots left"). Hosted-by, location, description visible.
     2. Choosing an option opens a lightweight identity modal: selected emoji highlighted (can still switch among the three), "YOUR NAME", "PHONE NUMBER" with reassurance "Just for event updates. No spam.", "ATTENDEE COUNT" (e.g. "2 attendees" dropdown), optional "+Post a comment" with GIF picker. Cancel / Continue.
     3. Optional host-set gate: "COVID-19 Safety" modal with rules; single button "ACCEPT & CONTINUE" (accept-conditions-before-confirm pattern).
     4. Page returns to event with your status shown on the button ("Going" badge with count incremented) and animated celebratory background.
   - Problem solved: RSVP with the lightest possible identity (name + phone), party-size capture, and host-defined conditions gate before confirmation.
   - Sad paths observed: none surfaced (capacity display hints at a full-event path, not shown).
   - Microcopy worth stealing: "I'm Going / Maybe / Can't Go"; "Just for event updates. No spam."; "spots left"; "ACCEPT & CONTINUE".
   - Mobile/a11y notes: emoji + label pairs (not emoji alone); modal-based so the flow works at any viewport; heavy animated backgrounds could be a motion-sensitivity concern.

## Substack (web)

5. Accepting an invitation (RSVP-to-a-role) — flow
   - Mobbin URL: https://mobbin.com/flows/32f0c028-f7bc-4418-b27e-c47183b9bffd
   - Steps observed:
     1. Invite link lands on "Set up your profile — Readers will want to know more about you and even follow your writing. Use your profile as a chance to express yourself." Fields: Name (required), Handle, Bio with hint "Tip: this will be shown at the bottom of your guest post". Checkbox "Create a Substack publication for me". Footer escape hatch "Already a writer? Switch accounts".
     2. Single combined CTA: "Update Profile & Accept Invite" — profile completion and acceptance are one action.
     3. Done state: "We'll let you know when your guest post is live — Your profile is set up and good to go!" + "Go to Sam Lee" (back to the inviter's publication).
   - Problem solved: accepting a ROLE (guest author ≈ speaker) collects the profile data the role needs in the same stroke as acceptance — no separate "complete your speaker profile" chase later.
   - Sad paths observed: "Already a writer? Switch accounts" handles wrong-account.
   - Microcopy worth stealing: "Update Profile & Accept Invite"; "We'll let you know when your guest post is live"; "Tip: this will be shown at the bottom of your guest post" (explains WHY each field is asked).
   - Mobile/a11y notes: single-column centered form; required marker on Name only.

## Calendly (web)

6. Coordinator: scheduled events + per-booking management — flow
   - Mobbin URL: https://mobbin.com/flows/e01316eb-c5ef-4106-9e2a-87176c0c8eee
   - Steps observed: "Scheduled events" with tabs Upcoming / Pending / Past + Date Range; filters (Teams, Host, Event Types, Status "Active Events", Tracking ID, Invitee Emails) + Export. Expanded row: Reschedule and Cancel buttons, invitee EMAIL (editable pencil), LOCATION with "Join now", INVITEE TIME ZONE ("Indochina Time"), MEETING HOST, "Schedule Invitee Again", "Add meeting notes (only the host will see these)". Empty state: "No Past Events" with illustration.
   - Problem solved: organizer-side command center per commitment: reschedule/cancel/re-invite from the row, with the invitee's timezone surfaced to prevent miscommunication.
   - Sad paths observed: empty state.
   - Microcopy: "Schedule Invitee Again"; "(only the host will see these)".

7. Canceling an event with reason → annotated history — flow
   - Mobbin URL: https://mobbin.com/flows/b585ee1f-1669-49b5-a8d2-99c3d1f63e63
   - Steps observed:
     1. Cancel opens modal "Cancel Event" restating event (name, person, time): "Please confirm that you would like to cancel this event. A cancellation email will also go out to the invitee." Free-text reason box (typed: "Apologies for this inconvenience, will update with a later time."). Buttons: "No, don't cancel" / "Yes, cancel".
     2. List afterwards: event row stays visible with strikethrough title/time and inline annotation "Canceled by Samantha Lee: 'Apologies for this inconvenience, will update with a later time.'" End-of-list marker "You've reached the end of the list".
   - Problem solved: cancellation always notifies the counterparty, captures a human reason, and leaves an audit trail in place instead of deleting the row.
   - Sad paths observed: this IS the sad path — modeled with notification + reason + history.
   - Microcopy worth stealing: "A cancellation email will also go out to the invitee."; "No, don't cancel" / "Yes, cancel" (explicit verbs, no bare OK/Cancel); "Canceled by {name}: '{reason}'".
   - Mobile/a11y notes: strikethrough is paired with red "Canceled by…" text — not strikethrough alone.

8. Single-use / expiring booking link — flow "Sharing a link"
   - Mobbin URL: https://mobbin.com/flows/9daab9b9-93c6-4709-aaea-d15e21bc0ed2
   - Steps observed: Share modal: "Copy and paste your scheduling link into a message" + toggle "Let this link expire after the first booking". When toggled on, the link regenerates to a one-time URL (…/d/cqgx-xq5-y7q/…) with a "Refresh" affordance after copy.
   - Problem solved: tokened, self-expiring action links — the exact mechanic of a single-use confirm token.
   - Microcopy worth stealing: "Let this link expire after the first booking".

9. Lifecycle email templates incl. reconfirmation — screen
   - Mobbin URL: https://mobbin.com/screens/006469b3-a0ed-405b-bcf7-defb5fd4b40b
   - Steps observed: "Edit: Email to invitee" modal: sender address dropdown (notifications@calendly.com, with "To send from Gmail or Outlook, connect in Integrations"); template dropdown: Custom, Additional resources, Feedback survey, **Reconfirmation**, Reminder, Request follow-up, Thank you; body editor with variable chips ("Event Name", "Event Organizer Name") "+ Variables"; checkboxes "Include reconfirmation button", "Include cancel and reschedule links", "Include cancellation policy".
   - Problem solved: re-confirm and self-service change links embedded in notification emails — exactly the "are you still coming?" nudge for long-lead conferences.
   - Microcopy worth stealing: "Include reconfirmation button"; "Include cancel and reschedule links".
   - Related (workflows gallery, same app): "Email reminder to invitee — Reduce no-shows — send automated email reminders to invitees"; "Send thank you email"; "Text booking confirmation to host" — https://mobbin.com/flows/b3deadf8-ee5e-4d98-9216-dff5cbb30c2d

10. Meeting poll (availability voting) — screen
   - Mobbin URL: https://mobbin.com/screens/c2e9b6cc-5fc6-49e0-8b9b-8850e2f061d2 (and https://mobbin.com/screens/8b81ac40-561d-4f97-8a65-1a720f5f1835)
   - Steps observed: public poll page "MEETING POLL — Select all the times you're available to meet". Timezone selector with live clock ("Eastern Time - US & Canada (11:25pm)"). Slots grouped under "THIS WEEK / Friday, February 24"; each slot chip shows time + thumbs-up vote count ("2:00 PM 👍 2"). Footer: "1 Vote", "1 times selected", Next.
   - Problem solved: availability collection by voting on proposed slots, with social proof per slot and timezone safety.
   - Microcopy: "Select all the times you're available to meet".

## SavvyCal (web)

11. Creating an availability poll — screens
   - Mobbin URL: https://mobbin.com/screens/11935b82-cccc-47e2-b8b9-6b689a390794 (and https://mobbin.com/screens/56e3f1d5-4a18-43b7-8ab0-d3cd3fae6cc6)
   - Steps observed: organizer clicks slots on a week calendar ("Click the time slots you'd like to propose"), with "Overlay my calendar" toggle to see conflicts. Note: "Anyone with this link can vote! You may optionally add attendees to preview their availability." Privacy toggle "Allow others to see who has voted". Duration, location (In-Person + address), "Times shown in (GMT-08:00) Pacific Standard Time" footer. "Publish this poll".
   - Problem solved: link-votable availability poll with vote-visibility control.
   - Microcopy: "Anyone with this link can vote!"; "Allow others to see who has voted".
   - Also seen: Zoom "Availability poll" creator with "Ignore calendar events" toggle — https://mobbin.com/screens/d4aaf42b-3dde-4291-8208-8ad29786b7c1

## Cal.com (web)

12. Requesting a reschedule (organizer asks invitee to re-pick) — flow
   - Mobbin URL: https://mobbin.com/flows/5dca9c69-b27c-4b13-bfca-088efc9d7781
   - Steps observed:
     1. Bookings list with tabs Upcoming / Unconfirmed / Recurring / Past / Canceled; rows show date/time, title, attendee note snippet, Join link, "Cancel event" + "Edit" per row.
     2. "Request reschedule" modal: "This will cancel the scheduled meeting, notify the scheduler and ask them to pick a new time." + "Reason for reschedule request (Optional)" textarea. Buttons Cancel / "Request reschedule".
     3. Toast "Reschedule request sent ✕"; affected booking gets a "Rescheduled" badge.
   - Problem solved: change is delegated back to the invitee with notification + reason instead of silently moving the time — the consent-respecting version of "your session moved".
   - Sad paths observed: "Unconfirmed" tab models bookings awaiting confirmation.
   - Microcopy worth stealing: "This will cancel the scheduled meeting, notify the scheduler and ask them to pick a new time."; "Reason for reschedule request (Optional)"; "Reschedule request sent".

## Navan (web)

13. Declining an event invitation — flow
   - Mobbin URL: https://mobbin.com/flows/4db6e38d-eb3d-4821-a99c-b21253c9a03d
   - Steps observed:
     1. Home shows invitation cards: "Sam Lee invited you" + event + dates + badge "Expires in 104 days" (invite expiry surfaced to the invitee, not just admin).
     2. Invite landing "Sam Lee has invited you to join: New York Team Sync" with location/dates and paired actions "✕ Decline" / "✓ I'm done booking".
     3. Decline confirm modal: "Decline New York Team Sync? — Your organizer will be informed that you can't join this event." single Decline button.
     4. Toast after: "The organizer will be informed that you can't join New York Team Sync."
   - Problem solved: decline is honest about its consequence (organizer gets told) — sets expectations and reduces ghosting.
   - Sad paths observed: invite expiry shown proactively ("Expires in 104 days").
   - Microcopy worth stealing: "Your organizer will be informed that you can't join this event."; "Expires in {n} days".

## Rise (web)

14. Declining / responding inside the calendar — flow
   - Mobbin URL: https://mobbin.com/flows/7a7718c7-1bfa-4da2-b427-ef25bc1cfafb
   - Steps observed: event detail side panel shows participants with response state ("Accepted & organizer", "Waiting for response") and a three-button response bar: "Maybe" / "Decline" / "Accept". Flexible-reschedule options on events ("30 mins earlier or later", "Within the day", "Tuesday, Wednesday, Thursday", "Within the week") — invitee pre-declares movability.
   - Problem solved: per-participant response status + tolerance-for-change captured up front.
   - Microcopy: "Waiting for response"; "Within the day / Within the week".

## Workable (web)

15. Declining a scheduled interview event — flow
   - Mobbin URL: https://mobbin.com/flows/1773c47f-bc4d-4df8-92d4-63a138611778
   - Steps observed: inbox rows for scheduled calls carry inline accept (green check) / maybe (orange) / decline (red X) icons. Expanding shows attendees as chips with per-person status icons (Candidate, Organizer ✓, pending "?"). After declining, row shows a red "DECLINED" pill and the user's attendee chip gets a red ✕.
   - Problem solved: respond-to-commitment without leaving the task inbox; everyone's response state legible per attendee.
   - Mobile/a11y notes: status icons are color + symbol; "DECLINED" also spelled out.

## Docusign (web)

16. Review & sign an envelope (review-and-confirm via emailed link) — flows
   - Mobbin URLs: https://mobbin.com/flows/d0bd4d11-7924-4e3d-8d28-ede69571628a and https://mobbin.com/flows/f0615900-2734-4e77-beb3-3ade109092e4
   - Steps observed:
     1. Agreements list: per-document status with progress bar — "Need to sign" (action on you, primary "Sign" button) vs "Waiting for Alex Smith" (action on them, "Resend" button). Last-change timestamp.
     2. Signing view "Review and complete": "Start" tag jumps you to the first required field; guided tag-to-tag navigation.
     3. Completion bar: "Ready to Finish? — You've completed the required fields. Review your work, then select Finish."
     4. Back in list: status "✓ Completed" + Download.
   - Problem solved: asymmetric status language (who owes the action), resend-as-nudge, and guided completion so the signer can't miss a required step.
   - Microcopy worth stealing: "Need to sign" / "Waiting for {name}"; "Ready to Finish? You've completed the required fields. Review your work, then select Finish."; "Resend".

## Contra (web)

17. Review, sign, and start project (type-to-sign attestation) — flow
   - Mobbin URL: https://mobbin.com/flows/a0a16055-b922-423f-a52f-82c7410b825e
   - Steps observed: stepper Proposal → Contract → Review → Sign. Right rail: "Review, sign, and start project — Make sure you read and understand the terms in the contract. Type your name below to sign." Name input + checkbox "I, Sam Lee, have read, understood, and agree to the terms and conditions set forth in this contract and agree to be legally bound by these terms and conditions by checking this box." CTA "Sign and send".
   - Problem solved: lightweight legally-meaningful confirmation (typed name + attestation checkbox) — the right weight for a speaker agreement/responsibility bundle confirm.
   - Microcopy worth stealing: the full first-person attestation sentence; "Type your name below to sign."

## Vimeo (web)

18. Inviting a speaker to a live event — flow
   - Mobbin URL: https://mobbin.com/flows/78084ac1-1dff-40ba-9bf7-0f6bd339c2f3 (also "Adding a speaker": https://mobbin.com/flows/4b285f66-adb9-4655-af50-0fde54ee2f08)
   - Steps observed: in the event studio, "Speakers" panel "+" opens a Speaker popover: Name (required), Email, Title — fields validate with green checks. Two delivery options: "Generate Invite Link" or "Send invite via email". After generation, a "Guest link" URL (https://vimeo.com/live/guest/…) appears with copy affordance; speaker appears in the Speakers rail.
   - Problem solved: per-speaker tokened guest link, deliverable by email OR copied into any channel — closest observed match to "faculty invite with magic link".
   - Microcopy: "Generate Invite Link"; "Send invite via email".

## Slack (web)

19. Admin pending-invitations console — screen
   - Mobbin URL: https://mobbin.com/screens/d4441a40-cfb0-42b1-aee9-6f2ba84ebad7
   - Steps observed: "Invitations" admin page with tabs Requests / Pending / Accepted / Invite Links; search "Search pending invitations by email"; per-row: email, "Invited by Sam Lee", role/scope ("Single-Channel Guest", "# marketing"), "Sent Jun 24, 2024", auto-expiry note "Deactivate on Aug 31, 2024", buttons "Resend Invitation" / "Revoke".
   - Problem solved: full invite ledger by state with resend/revoke and scheduled deactivation.
   - Microcopy: "Resend Invitation"; "Revoke"; "Deactivate on {date}".

## 15Five (web)

20. Pending + expired invitations with expiry management — screens
   - Mobbin URLs: https://mobbin.com/screens/c2d103be-a9aa-4755-a0bc-8e269678ede5 and https://mobbin.com/screens/8c6008e7-96a7-40ae-b06a-fcbc0f8c7141
   - Steps observed: sections "Pending invitations" (columns: Name, Reviewer, Invitation sent on, **Expires in** e.g. "30 days") and a separate "Expired invitations" section ("There are no expired invitations."). Bulk-select + Actions menu: "Reset expiration date", "Resend invitation", "Deactivate". Success toast: "You successfully reset 1 expiration date." Seat context banner: "3 of 2000 remaining seats available."
   - Problem solved: expiring invites as a first-class lifecycle — countdown column, bulk reset/resend, and a graveyard section for expired ones.
   - Sad paths observed: expired-invitations section; toast confirms expiry reset.
   - Microcopy worth stealing: "Expires in"; "Reset expiration date"; "You successfully reset 1 expiration date."

## 1Password (web)

21. Manage invites with explicit expiry policy — screens
   - Mobbin URLs: https://mobbin.com/screens/abe40bad-1db6-416a-9412-ef8ce5f85318 and https://mobbin.com/screens/76198b80-5ce1-4c8a-8d29-68005bf5e2e5
   - Steps observed: "Manage invites" tab with badge count; policy stated inline: "Invitations can be resent at any time and expire after 5 days." Table: Email, User Type (Team Member/Guest), Expiration Date (+ exact time), Status "Waiting on user", row menu Resend / Delete. Delete confirm modal: "Are you sure you want to delete the selected invitations?" Cancel / "Delete invitation".
   - Problem solved: states the expiry contract where the admin works; status framed as whose move it is ("Waiting on user").
   - Microcopy worth stealing: "Invitations can be resent at any time and expire after 5 days."; "Waiting on user".
   - Also seen: Threads pending-invite tab with "Resend invitation" / "Rescind invitation" — https://mobbin.com/screens/6a8565ed-d3f6-46ce-9706-1bdea8ea0385

## Sad-path gallery (invite/token failures)

22. Supabase — token missing on invite page
   - Mobbin URL: https://mobbin.com/screens/53cc50f8-fdd3-4181-939c-d60006ab5a97
   - Observed: card "You have been invited to join an organization" (org slug shown) with error block: "There was an error requesting details for this invitation. (No authorization token was found)" + "You will need to sign in to accept this invitation" + buttons "Sign in" / "Create an account".
   - Steals: keeps the invitation context visible while explaining the failure and offering both recovery routes.

23. Jitter — invalid/used magic link
   - Mobbin URL: https://mobbin.com/screens/afbfda33-219a-4d01-b1cd-d25b1289c6ca
   - Observed: full-page "Invalid login link." + "This login link is invalid or has been used already, please try again." + lock illustration + "Back to login".
   - Steals: names both causes (invalid OR already used) in one sentence.

24. Clay — invite not found / already used
   - Mobbin URL: https://mobbin.com/screens/4e84282b-5e3d-4cb9-b8b6-6defdc7e8e89
   - Observed: "⏰ Not Found — We could not find this invite. Maybe it has already been used?" (no recovery CTA — weakness worth avoiding).

25. Linear — invitation already accepted
   - Mobbin URL: https://mobbin.com/screens/7a0995a4-f085-45cd-b657-d88269272e9e
   - Observed: "Invitation already accepted — If you think this is a mistake or if you have trouble logging into the workspace, please contact the workspace admins or Linear support." + "Go back". Header shows "Logged in as: alexsmith.mobbin@gmail.com" — helps diagnose wrong-account.
   - Steals: shows current identity on the error page; escalation path named.

26. Squarespace — already have access
   - Mobbin URL: https://mobbin.com/screens/c7957528-2575-4d14-8183-4aa52a5a6c8d
   - Observed: "Unable to Accept Invitation — You already have permissions on this site." + "OKAY".
   - Steals: distinct copy for already-a-member vs already-accepted vs expired.

## Magic-link "check your inbox" interstitials

27. Better Stack — Mobbin URL: https://mobbin.com/screens/891e5c6b-aa8b-4582-abfb-674346e36f5e
   - Observed: "Check your inbox — We've sent you a magic link to jsmith.mobbin2@gmail.com. Please click the link to confirm your address." Quick-open buttons: "Open Gmail / Open Superhuman / Open Outlook". Recovery: "Can't see the email? Please check the spam folder. Wrong email? Please re-enter your address."
28. Qatalog — https://mobbin.com/screens/d080a041-67f7-42df-88a8-b4b9c9fdae32 — "We've sent you a magic link to {email} — Please check your inbox" + "Send again" button; footer "Signing up as {email} (logout)".
29. Current — https://mobbin.com/screens/e818eb8c-3fed-42ea-aa8d-29200b9e3e61 — "Check your inbox" + "Not received the link? Resend email".
30. Felt — https://mobbin.com/screens/67db25a6-d5a2-4382-9cf0-321ab7f32d48 — "Check your email" + Open Gmail / Open Outlook + "Don't see it in your inbox or spam? Send it again".
   - Steals across all: echo the exact email address; provider deep-link buttons; spam-folder + wrong-email recovery on the same screen.

## Reschedule / change-confirmation states

31. Preply — Mobbin URL: https://mobbin.com/screens/ee31c088-516f-4463-81d3-14afe0ca5a99
   - Observed: full-page "We've rescheduled your lesson." + new session line ("Japanese with れあ — Sun, Dec 28 · 08:00–08:25") + "Add to Google Calendar" + Continue.
32. Booking.com — https://mobbin.com/screens/5337fb1f-6fc2-4b70-b923-c9f5a2dcf361
   - Observed: "Change dates" modal: "An updated confirmation has been sent to jdoe.mobbin@gmail.com. Enjoy your stay!" — re-confirmation email on every change.
33. Tripadvisor — https://mobbin.com/screens/4dc8152c-3057-487f-8aff-561fa54de813
   - Observed: "Change Date" page with explicit diff: "Current Date: April 29, 2025 / New Date: Apr 28, 2025"; consequence callout "This activity costs less on the new date you selected." Paid vs New price + "Refund Amount"; primary "Change Date", secondary "Keep date".
34. Airbnb — https://mobbin.com/screens/4fcdc600-a842-4a54-8dbf-a66edcb65cde
   - Observed: "Reservation change request sent to {host} — You will be notified when your host accepts or declines this request." Diff shown ("New guests: 2 guests / Original: 1 guest"), price difference table, "Cancel request" available while pending, toast "Request sent".
35. Fresha — https://mobbin.com/screens/ea94be39-97ee-4763-b0d7-334bc1942a2a — minimal full-bleed "✓ Appointment rescheduled".
36. Cal.com Bookings — https://mobbin.com/screens/97d8904d-eb57-4871-8b82-4d13efce6178 — "Rescheduled" badge on the affected booking row (see entry 12).
   - Steals across all: old vs new shown side-by-side; consequences (price/refund) computed and stated; change-request is itself a stateful object (pending, cancellable, accept/decline by counterparty).

## iOS probe — RSVP ergonomics

37. Apple Invites — Mobbin URL: https://mobbin.com/screens/5a5a0fdb-b99a-4352-bd57-80680ca6862d
   - Observed: invite card with three equal pills "Going / Not Going / Maybe" (icon + label), event details above. Host preview mode: "Invitation Preview — This is what guests will see. You'll publish and invite guests in the next step."
38. GroupMe — https://mobbin.com/screens/b699aec3-92c9-4579-af4e-820156a72176
   - Observed: event page with attendee tabs "Going (1) / Not Going (0) / Pending (1)" and bottom response bar "👍 I'm in" / "😢 Can't go". Pending as a first-class visible bucket.
39. LINE — https://mobbin.com/screens/15c13dba-b760-4068-acd1-f96be30dda12
   - Observed: "Responses" sheet: date row with ✓ / ? / ✕ toggle + free-text comment ("I'll be there") + OK. Response + message in one gesture.
40. KakaoTalk — https://mobbin.com/screens/3342ee2a-1e0f-4ce1-acfc-3f3e2319436a
   - Observed: invitations inbox with tabs "new invites" / "responded"; each card has three inline response buttons (attend / undecided / absent), current choice highlighted — re-editable after responding (declined-then-changed-mind is just tapping another button).
   - Mobile note (all): response controls are thumb-row buttons at bottom; tabs show counts.

## Coverage

Queries run (15 total):
- by-app flows (web): (1) "speaker accepting an invitation to speak at a conference…" → Luma, Substack, Aboard; (2) "Calendly invitee confirming or rescheduling…" → Calendly scheduled events / share-link / workflows; (3) "guest responding to an event invitation accept decline RSVP Luma Partiful" → Luma, Partiful, Luma Guests; (4) "invitee rescheduling or canceling a scheduled appointment with reason" → Cal.com, Rise, Calendly; (5) "declining an invitation with a reason" → Navan, Rise, Workable; (6) "reviewing and signing a document sent for signature" → Docusign ×2, Contra; (7) "submitting a talk proposal call for papers Sessionize" → NO CFP results (Vimeo speaker-invite + Discord stage surfaced instead).
- by-pattern screens (web): (8) availability poll → Zoom, SavvyCal, Calendly; (9) expired/invalid invitation link → Supabase, Jitter, Clay, Linear, Squarespace; (10) pending invitations resend/revoke → Slack, 15Five, Threads, 1Password; (11) "your event time changed / what changed" → only reminder-email config (Luma, Zoom, Cal.com, Calendly) — no diff-summary screen; (12) magic link check-your-inbox → Qatalog, Peec AI, Better Stack, Current, Felt; (13) rescheduled confirmation old vs new → Fresha, Preply, Booking.com, Tripadvisor, Airbnb; (14) speaker portal / my assigned sessions → DRY (User Interviews, Riverside, Lyssna, Cal.com, Otter — adjacent schedulers only).
- iOS probe: (15) "event invitation RSVP accept decline from invite link" → KakaoTalk, LINE, Apple Invites, GroupMe.

Dry areas (FIRST-PRINCIPLES CANDIDATES — Mobbin has no direct coverage; do not fake patterns from it):
1. Speaker/faculty PORTAL showing assigned sessions + responsibility bundles ("you chair session A, speak in B, moderate C"). Nearest analogues: Lyssna/User Interviews session lists, Docusign multi-document action list ("Need to sign" vs "Waiting for…"). Design from first principles using the action-ownership status language + per-item respond pattern.
2. CFP / talk-proposal submission (Sessionize itself absent from Mobbin results).
3. "What changed" diff NOTIFICATION for a program change (session moved rooms/times). Nearest analogues: Tripadvisor Current/New date diff, Airbnb original-vs-new change request, Calendly canceled-row annotation. Compose: diff block + consequence line + re-confirmation email + acknowledge CTA.
4. Decline-then-changed-mind on web (only KakaoTalk iOS showed re-editable responses; Luma's "canceling your registration" link is the reverse direction).

Exclusions: Aboard attend/attending toggle (recorded via flow URL https://mobbin.com/flows/4fa0df58-06ad-4449-8141-952065d330fe but too thin to pattern); Discord stage speaking (live-audio mechanics, not commitment management); Peec AI check-inbox (duplicate of pattern 27-30, kept URL only in query log); Otter/Riverside results (calendar dashboards, off-job).
