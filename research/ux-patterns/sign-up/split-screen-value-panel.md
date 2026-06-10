# Pattern: Split-screen sign-up with value/social-proof panel
**Surface:** sign-up · **Observed in:** Stripe, Intercom, TheyDo, Outseta, Notion, Grain, Oyster, Profound (refs: [Stripe](https://mobbin.com/screens/c360e87e-9ced-4410-a594-38da5638c8fd), [Intercom](https://mobbin.com/screens/9361bd82-0473-4976-9e38-7aadb32fa72b), [TheyDo](https://mobbin.com/screens/1805b668-16d4-4901-96a8-fe4fe8943573), [Outseta](https://mobbin.com/screens/bcd67c9b-e81f-4400-a323-dfd043afb70b), [Notion](https://mobbin.com/screens/2f8a40a2-20ff-467f-a818-77cb90bedbcc), [Grain](https://mobbin.com/screens/8217b823-96c9-4f22-a472-aa9f75c7e742), [Oyster](https://mobbin.com/screens/3b614711-2da4-444e-a92b-e76b552d9e48), [Profound](https://mobbin.com/screens/ec586558-5d1e-4686-9eee-0b41779069cb))

## Flow
1. Two-column desktop layout: form card on one side, persuasion panel on the other.
2. Panel content variants observed: checkmark value props (Stripe "Get started quickly / Join millions"), trial pricing summary + customer quote (Intercom), "Your plan includes" feature list (TheyDo), customer testimonial card (Grain, Outseta, Profound), product screenshot (Notion), photo + free-plan list (Oyster).
3. Panel is purely informational — no interactive controls; form column keeps a fixed narrow width.
4. Collapses to form-only on narrow viewports (panel is the sacrificial column).

## Use when
- Desktop-web-first products (our case) where the empty half of a centered-card page is free real estate.
- Trial/paid signups that benefit from restating value at the commitment moment.

## Avoid when
- The auth card already carries heavy content (5-provider stacks + form) — two busy columns compete.
- Post-click contexts (e.g., invite acceptance) where the user is already committed; a plain centered card (Linear, Vercel) reads calmer and is cheaper.

## Sad paths observed
- None specific to the panel; error handling lives entirely in the form column (Profound shows its password error with the testimonial panel intact).

## Accessibility
- Panel should be skippable decoration in DOM order (form first); testimonial text remains real text, not image, in Stripe/TheyDo/Grain.

## Default verdict for our stack
VIABLE — pure presentation-layer polish for later; centered single card (Linear-style) hits the quality bar with less to maintain at launch.
