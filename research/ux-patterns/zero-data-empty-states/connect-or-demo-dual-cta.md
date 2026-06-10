# Pattern: Connect-real-data OR try-demo dual CTA on empty home
**Surface:** zero-data-empty-states · **Observed in:** Steep, Mixpanel, Amplitude (refs: https://mobbin.com/screens/befce3e9-03ba-47d4-b4bc-5ecd3b647d8c, https://mobbin.com/flows/09c8b5b5-9900-4d70-859d-65bd93975bd2, https://mobbin.com/screens/966b2301-6f26-4f65-aa90-a9d2fff5821d)

## Flow
1. The empty home leads with the real-path CTA and offers demo as the explicit secondary: Steep — "Get started! Connect your data source and define your metrics... [Connect data source] [Try demo data]"; Mixpanel Set Up Guide — "[Quick Start] / [Connect Data]" with a "Not ready to start?" row underneath: "View a demo project · Learn how Mixpanel works · Invite a teammate"; Amplitude home quick actions — "Start from a template / Explore Amplitude demo / Invite a new user / Create a chart".
2. Demo choice may branch into a segment picker (Mixpanel "Select Sample Dataset": AI / B2B SaaS / E-Commerce / Finance / Healthcare / Media / Social → [Explore Demo]).
3. Visual hierarchy is consistent: real path = filled primary button; demo = outline/secondary or text link.
4. Steep appends a third tier for the stuck: "Need help getting started? Invite a teammate to collaborate on setup or contact Steep" (invite / contact / schedule demo / help).

## Use when
- Real value requires nontrivial setup (data connection, content creation) and an evaluator needs to see the product working today.
- Sales-led + product-led mix: the "not ready?" tier (demo / docs / invite a teammate who can do the setup) catches evaluators who aren't the implementer.

## Avoid when
- Setup takes under a minute — a demo path competes with just doing the real thing (an Event State tenant can create a real event faster than exploring a fake one).
- You can't keep the demo visibly separated from real data afterward (see isolated-demo-sandbox card).

## Sad paths observed
- Mixpanel's guide has "Skip for Now →" — skipping both paths drops users onto empty reports with only a top banner as recovery.
- Demo as equal-weight CTA risks evaluators never returning to real setup; all three apps mitigate by keeping demo visually secondary.

## Accessibility
- Both observed CTAs are real buttons with text labels, side by side — order matters for keyboard/screen-reader users: real path first in DOM, demo second.
- Steep's tertiary help row is plain links with icons + text, not icon-only.

## Default verdict for our stack
VIABLE — for Event State this fits the analytics-ish surfaces, but at tenant level prefer "create real event" primary + "start from a sample event template" secondary rather than a full demo mode; adopt the hierarchy (real = primary, demo = secondary, help = tertiary) regardless.
