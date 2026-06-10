# Pattern: Email + role row repeater ("Add another")
**Surface:** invite-member · **Observed in:** Vercel, Plane, GitBook, Grok, Perplexity, Attio, Dub, Current (refs: [Vercel create-team](https://mobbin.com/screens/adc1e0e4-5c8f-422f-a361-9bba97fe760f), [Plane](https://mobbin.com/screens/8e8989db-cc2d-4a2d-ae6a-79de9bde1ec4), [GitBook](https://mobbin.com/screens/1944a6f5-6de7-4693-af25-89c86c133fb4), [Grok](https://mobbin.com/screens/c27b69a5-db0a-48fe-9f07-60ae7093b07c), [Perplexity](https://mobbin.com/screens/22be9a34-4b6c-447e-8b44-84d9b643b4d5), [Attio](https://mobbin.com/screens/9afcf1a8-35f2-47c8-a252-f957015ed31f), [Dub](https://mobbin.com/screens/fc305ffc-21f2-4c2b-9804-fecf29bd59a7), [Current flow](https://mobbin.com/flows/a081cb1c-ffb7-436e-b1b1-387a829e9f74))

## Flow
1. 1–3 starter rows, each: email input + per-row role dropdown (defaulting to Member).
2. "+ Add more" / "Add another" / "+ Add email" appends rows; per-row delete icon appears once a second row exists (Grok, Dub trash icon).
3. Current adds "+ Add in bulk" as an escape hatch for paste-many; role dropdowns carry descriptions (Plane: Guest/Member/Admin with permission text).
4. Primary CTA "Invite"/"Continue" disabled until at least one valid email (Plane); skip affordance "I'll do this later" in onboarding contexts.

## Use when
- Different invitees need different roles in one submission (coordinator + ops + read-only in one go — our exact case).
- Onboarding steps, where a structured form reads as a checklist.

## Avoid when
- Pasting 20+ addresses — row-per-email is tedious; pair with a bulk-paste mode (Current's "Add in bulk") or token field.

## Sad paths observed
- Plane: Continue stays disabled on invalid/empty rows; success toast on send.
- GitBook gates premium roles in the picker with "Upgrade" badges instead of hiding them — discoverable but blocked.
- Perplexity states "You will not be charged until invites are accepted" right in the form — billing anxiety handled at compose time.

## Accessibility
- Plain inputs and selects per row — good; per-row delete buttons need accessible labels ("Remove row 2"), not bare icons.

## Default verdict for our stack
RECOMMENDED — as the body of the invite modal: rows of email + per-role select with descriptions, "Add another", and bulk-paste splitting commas/newlines into rows.
