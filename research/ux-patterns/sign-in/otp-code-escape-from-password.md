# Pattern: One-time-code escape from the password form
**Surface:** sign-in · **Observed in:** WorkOS, OpenAI Platform, Expedia, Workable (refs: [WorkOS](https://mobbin.com/screens/812592ce-380a-4998-a10e-55ac97d12858), [OpenAI flow](https://mobbin.com/flows/f71e1240-7085-49ec-8c3c-3181381039a3), [Expedia flow](https://mobbin.com/flows/61cba8c4-db06-4483-8df8-597a22ad3d0c), [Workable](https://mobbin.com/screens/df32220a-c1ed-4500-b92b-88a19ff32eff))

## Flow
1. Password login form carries a secondary action offering an emailed code/link instead: "Email sign-in code" button under an OR divider (WorkOS), "Log in with a one-time code" (OpenAI), "Send a secure code via email" (Expedia), "Email me a link to sign in instantly" (Workable).
2. Selecting it emails a code/link to the already-entered address and swaps the card to a code-entry state.
3. Crucially, it remains visible alongside credential errors — acting as the recovery ramp for forgotten passwords without the full reset ceremony.

## Use when
- Password-primary login (our case) — this is the canonical "forgot password but need in NOW" relief valve.
- Reducing password-reset support load.

## Avoid when
- Email delivery is slow/unreliable — a broken escape is worse than none.
- You already offer magic-link-primary (redundant duplicate channel).

## Sad paths observed
- WorkOS presents the escape directly under an active "Invalid email or password" error — error and exit in one view ([ref](https://mobbin.com/screens/812592ce-380a-4998-a10e-55ac97d12858)).
- Workable same pairing: error banner up top, instant-link button at the bottom of the form.

## Accessibility
- Escape is a real button/link with explicit consequence text, not an icon; remains in form tab order after error re-render.

## Default verdict for our stack
VIABLE — Better Auth's emailOTP plugin makes this cheap; strong candidate for v1.1 as the soft recovery path beside classic reset.
