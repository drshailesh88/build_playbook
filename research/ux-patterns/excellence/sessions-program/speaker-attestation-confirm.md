# Pattern: Type-to-sign attestation confirm

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Contra, DocuSign (refs: [Contra sign flow](https://mobbin.com/flows/a0a16055-b922-423f-a52f-82c7410b825e), [DocuSign envelope flow](https://mobbin.com/flows/d0bd4d11-7924-4e3d-8d28-ede69571628a), [DocuSign signing flow](https://mobbin.com/flows/f0615900-2734-4e77-beb3-3ade109092e4))

## Flow
1. Stepper: Proposal → Contract → Review → Sign (Contra). The thing being agreed to is fully visible alongside the sign rail.
2. Typed-name input + first-person attestation checkbox: "I, {name}, have read, understood, and agree to the terms and conditions set forth in this contract…" CTA "Sign and send".
3. DocuSign adds guided required-field navigation ("Start" tag jumps to first field) and a completion gate: "Ready to Finish? — You've completed the required fields. Review your work, then select Finish."

## Use when
The confirmation carries real commitment weight — a faculty member confirming a full responsibility bundle (sessions, roles, dates) where the organizer needs evidence the person actually reviewed it.

## Avoid when
Simple attendance RSVP — attestation friction is hostile there; reserve it for the agreement step only.

## Sad paths observed
- Guided navigation makes missed-required-field impossible rather than erroring after submit.

## Accessibility
Attestation is text + checkbox (no canvas signature required); typed name works with any input modality.

## Microcopy worth stealing
"Type your name below to sign." · the full first-person attestation sentence · "Ready to Finish? You've completed the required fields."

## Default verdict for our stack
VIABLE — overkill for default faculty accept, but the right shape IF an event requires formal speaker agreements (medical-conference compliance). Keep as an optional heavier confirm step layered on the tokened landing.
