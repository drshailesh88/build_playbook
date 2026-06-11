# Pattern: Stepper composer — Recipients → Content → Review with a blocking review step
**Surface:** broadcast-compose · **Observed in:** Customer.io, Loops, Fresha, Wix (refs: [Customer.io creating-a-broadcast](https://mobbin.com/flows/effe83a3-f78b-4724-95c9-5a3a4944def3), [Loops schedule step](https://mobbin.com/screens/190a9d6e-16ea-4d17-9e9c-3f57d896dd92), [Fresha audience step](https://mobbin.com/screens/e6b3ee02-cbee-45f9-9904-ab6aa9d5c107), [Wix overview](https://mobbin.com/screens/b778c7a8-0471-432c-b25e-8cdf0d10576d))

## Flow
1. Top or side stepper with checkmarked stages — Customer.io: "1. Recipients ✓ 2. Goal ✓ 3. Content 4. Review"; Loops: Compose → Audience → Schedule → Send → Metrics (metrics is a stage of the same object).
2. Each step saves independently (Save / Save & Next / "< Exit" keeps the draft).
3. Content step picks the channel via cards (Email / In-App / Push / SMS / Webhook; unavailable channels greyed).
4. Review step re-states every section with ✓/⚠; missing pieces render a red inline banner ("Please add a subject line and content to your email") and the dead-state line "Can't send just yet… Review and fix your newsletter settings before sending" with Send AND Schedule disabled.
5. Optional Goal step ties the send to a conversion metric; optional Test panel adds up-to-8 A/B variations with a sample-percentage slider and "send winner automatically" toggle (observed, niche).

## Use when
Steps have real dependencies (audience → content variables → schedule) or the team wants one canonical path for less-frequent senders.

## Avoid when
Power users send daily and need random access — forced sequence becomes friction (checklist pattern wins).

## Sad paths observed
- Review is the single enforcement point: nothing sends while any step is invalid; errors name the exact missing field (Customer.io).
- Exit at any step keeps a Draft row in the list with "Continue editing →" (Customer.io broadcasts list).

## Accessibility
Stepper stages are labeled buttons with done-state checkmarks; disabled CTAs carry explanatory text adjacent, not tooltip-only.

## Default verdict for our stack
VIABLE — strongest when audience selection drives template variables; Loops' inclusion of Metrics as a final stage of the same object is worth stealing regardless of which composer shape wins.
