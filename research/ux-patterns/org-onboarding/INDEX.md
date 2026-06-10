# org-onboarding — pattern index

## Coverage
- **Queries run:** by-app: "Notion create workspace onboarding first run", "Linear onboarding create workspace invite teammates step", "Slack create a new workspace setup steps"; by-pattern: "no workspace left forced to create or join organization after leaving"; by-flow: "create a new workspace during signup onboarding". Platform: web only.
- **Apps swept:** Notion, Linear, Slack, Fibery, Frame, Air, Cycle, monday.com, Coda, Typeform, Airtable, Base44 (incidental).
- **NOT found / excluded:** Raycast (no web org-onboarding screens surfaced — desktop-centric), Stripe and Vercel first-run org creation (only switcher "Create Team" entry observed, no dedicated wizard screens), no direct capture of the *last-org-deleted → forced gate* moment (closest evidence: Linear's full-screen create with only "Log out", Notion's join-or-create gate). The dedicated sad-path query returned only empty-workspace states — treated as dry.

## Patterns
- ★ `single-card-create-form` — one centered card: name + auto-slug (+ region), single submit (Linear, Frame, Notion). **Recommended default.**
- `join-or-create-gate` — full-screen blocking state for zero-org users listing pending invites + create CTA (Notion, Slack, Linear, Cycle). RECOMMENDED as the routing shell around the ★ card.
- `inline-invite-step-with-skip` — post-create invite step: multi-email + copy link + "I'll do this later" (Linear, Slack). RECOMMENDED as step 2.
- `stepper-wizard-profiling` — full-screen multi-step wizard with segmentation questions and skips (Slack, Air, Fibery, Linear, Notion). VIABLE only capped at 2–3 steps.
- `email-domain-autojoin` — domain-based workspace discovery/auto-join (Slack, Notion). VIABLE, post-v1.
- `template-seeding-step` — starter templates at first run or point of emptiness (Notion, monday.com). VIABLE at point of emptiness.
