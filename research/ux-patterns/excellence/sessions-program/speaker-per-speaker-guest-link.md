# Pattern: Per-speaker tokened guest link — email it or copy it

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Vimeo, Calendly (refs: [Vimeo invite-speaker flow](https://mobbin.com/flows/78084ac1-1dff-40ba-9bf7-0f6bd339c2f3), [Vimeo add-speaker flow](https://mobbin.com/flows/4b285f66-adb9-4655-af50-0fde54ee2f08), [Calendly single-use link](https://mobbin.com/flows/9daab9b9-93c6-4709-aaea-d15e21bc0ed2))

## Flow
1. Speakers panel "+" opens a minimal popover: Name (required), Email, Title — fields validate inline with green checks.
2. Two delivery options side by side: "Generate Invite Link" or "Send invite via email" — the coordinator chooses the channel.
3. Generated guest URL appears with a copy affordance; the speaker lands in the Speakers rail immediately.
4. Calendly variant for token hygiene: "Let this link expire after the first booking" — link regenerates to a one-time URL.

## Use when
Invite delivery can't depend on email landing — coordinators paste the link into WhatsApp/SMS where the relationship already lives (exactly the medical-conference reality).

## Avoid when
Burning the token on first use for links speakers will revisit — the confirm ACTION should be single-use, the status page durable.

## Sad paths observed
- None surfaced in flow; copy-link is itself the email-failed recovery channel.

## Accessibility
Copyable URL as a real text field; validation states shown inline per field.

## Microcopy worth stealing
"Generate Invite Link" · "Send invite via email" · "Let this link expire after the first booking"

## Default verdict for our stack
RECOMMENDED — the old app's invite token exists but is never delivered; the rebuild should ship BOTH channels from day one: send via email/WhatsApp AND copy-link as the out-of-band fallback the old app accidentally proved necessary.
