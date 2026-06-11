# Pattern: Claim ceremony — confirm name BEFORE the artifact is generated

**Surface:** certificates / recipient-claim · **Observed in:** Uxcel, Udemy, Cake Equity, Discord, Fey, Dub (refs: https://mobbin.com/flows/a2e3dcaf-c6ed-4bbc-af0a-818f566e1c33, https://mobbin.com/flows/775f06a4-0ee4-4375-b844-6e01746f095d, https://mobbin.com/flows/1d1def13-36fb-4ae9-b391-be3e28bbe85b, https://mobbin.com/flows/078707ba-5e65-400c-a207-486f2077e223, https://mobbin.com/flows/927fb29a-162e-489f-8cc8-0c3abdd17c9e)

## Flow
1. Earned-but-locked state builds the moment: blurred certificate + padlock, "Ready to unlock", headline "Unlock your certificate — …share this achievement with the world." [Unlock] (Uxcel).
2. Name gate before generation: modal "Add your full name — Please add or review your name and then we'll generate your shareable certificate." → button enters "Generating…" → toast "Generating certificate, please be patient." (Uxcel)
3. Lands on the certificate page (see certificate-page-trophy-proof).
4. Claim variants: claim-by-code with visible deadline ("Gift is available to claim until April 16, 2025") + code echoed to email (Discord); identity-bound code ("Make sure you match the same invitation e-mail") with "Change account" escape hatch (Cake Equity); passwordless magic-link claim (Fey); in-app invitations inbox (Dub).

## Use when
The recipient's display name comes from registration data of unknown quality (typos, ALL CAPS, missing honorifics — endemic in conference imports) — confirm once, generate once.

## Avoid when
Names come from a verified registry (medical council ID) where self-editing would FORGE the credential — then show name read-only with a "report a problem" path instead of an input.

## Sad paths observed
- Claim deadline surfaced before claiming (Discord).
- Wrong-account claim blocked with explicit identity match requirement + account switch (Cake Equity).
- Generation latency named honestly ("please be patient") instead of a dead button.

## Accessibility
Single-field modal, default-filled — minimal burden; "Generating…" state must be announced.

## Default verdict for our stack
RECOMMENDED — never attempted in legacy (admin issues directly; name fixes happen AFTER as supersession churn, census #17–18). A claim-time name check converts the #1 reissue cause into a zero-cost confirmation. NOTE: delegate-facing claim/download surface is module external-links (DEC-062) — the ISSUANCE MODE decision (issue-on-claim vs issue-then-notify) belongs to certificates.
