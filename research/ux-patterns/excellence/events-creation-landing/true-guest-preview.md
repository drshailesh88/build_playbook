# Pattern: Preview as a true guest-state switch (not a screenshot)

**Surface:** events-creation-landing · **Observed in:** Partiful web (https://mobbin.com/flows/43868d0a-8ad0-4969-a386-5852a8705d53), Eventbrite web (https://mobbin.com/screens/2a7256f2-133e-49cf-8146-a2b9d91cda87), X web — transferable (https://mobbin.com/flows/2fea1547-ee84-47c4-a6b7-d16534721864), Square web (https://mobbin.com/screens/d554aeed-a3ae-43fc-8242-557f1f40be52)

## Flow
1. PREVIEW renders the page exactly as a guest sees it: edit chrome vanishes, empty optional rows disappear entirely (no "TBD junk" leaks), and access-gated content shows its gated form — "🔒 Restricted Access — Only RSVP'd guests can view event activity & see who's going" (Partiful).
2. Device truth: Eventbrite's "Event preview" mode renders the page inside a phone frame with desktop/mobile toggles and a banner "Need to make some updates? Edit event".
3. Unpublished previews are labeled so screenshots can't be mistaken for live: dismissible banner "Only you can view this unpublished Article." + persistent "Draft" pill (X — transferable).
4. Square keeps a live phone-frame preview permanently beside the form (preview-as-you-type rather than preview-on-demand).

## Use when
Anything is conditional on the page (gated sections, optional rows, role-dependent banners) — preview is the organizer's trust check before sharing. Mobile preview matters because most guests open event links on phones.

## Avoid when
True WYSIWYG editing (the form IS the page, all content public) makes a separate preview redundant — then a simple "view as guest" link suffices.

## Sad paths observed
- The preview itself is sad-path discovery: it reveals exactly what's hidden behind RSVP and which rows won't render.
- Without a "private preview" label, drafts get screenshotted and shared as if live (the X banner exists to prevent this).

## Accessibility
Preview banner is text + dismiss button; device toggles are labeled buttons, not icon-only.

## Default verdict for our stack
RECOMMENDED — the old app had NO preview at all; coordinators published blind. V1: "Preview as attendee" from the workspace rendering the real public route in draft mode with a labeled banner + mobile frame toggle.
