# Pattern: Sample/demo data prefill in the empty tenant
**Surface:** first-run-onboarding · **Observed in:** Webflow, Mixpanel, folk, Productboard, n8n, Maze (refs: [Webflow "Create sample items"](https://mobbin.com/screens/7929daa6-f7ba-409e-822c-3e96b9cced25), [Mixpanel demo banner](https://mobbin.com/screens/7ca71eaa-ed58-4abc-87ad-94f2545e3a84), [Mixpanel no-data warning](https://mobbin.com/screens/d25e3630-abec-48eb-81ad-97c90419cc2a), [folk flow](https://mobbin.com/flows/d6cccc15-0fd8-4412-9b19-d6a00993978d), [Productboard sample boards](https://mobbin.com/screens/e0bebb50-4971-4b97-b510-2b601086cd43), [n8n](https://mobbin.com/flows/243292b2-c4f5-45aa-9c64-13963a516cf0), [Maze demo study](https://mobbin.com/screens/88414f24-a07a-45be-a8ea-6d3dc6b24772))

## Flow
1. The empty surface offers sample content as an explicit, opt-in choice: Webflow's empty CMS collection shows "Create sample items — Add 5 / Add 10 / Add 20" with rationale copy "Sample items can help you start designing faster"; folk's empty CRM offers "Start with 10 sample contacts" as the first of three entry cards.
2. Alternatively the workspace arrives pre-seeded: n8n ships a "Simple Workflow" tagged `dummy data`; Maze's team home lists a "Demo Maze" with DEMO status badge; Productboard sidebar contains "Feature planning (sample)" boards; Notion ships a pre-built "Getting Started" page.
3. Sample content is clearly labeled as such (dummy-data tag, DEMO badge, "(sample)" suffix, "[example channel]" in Slite) so it can't be mistaken for real data.
4. A persistent banner reminds the user this isn't their data and points to the real path: Mixpanel "Welcome! You're viewing a Mixpanel demo... Implement Mixpanel / Watch Tutorial".
5. User explores fully-populated views (the product looks alive, not dead), then replaces/deletes sample content when real data arrives.

## Use when
- The product's value is only visible with data in it (dashboards, schedules, CRMs — and an event program/agenda is exactly this).
- You can label sample data unambiguously and make deletion one action.
- Users land with nothing to import (greenfield orgs).

## Avoid when
- Sample data could leak into real workflows (comms/email modules — a sample attendee getting a real email is catastrophic in our domain; sample data must be inert).
- Cleanup is manual and multi-step — abandoned demo rows pollute the tenant forever.
- The user signaled import intent; importing real data beats fake data (folk offers sample / sync / import as peer options).

## Sad paths observed
- No data at all and no guidance: Mixpanel's "We don't have any data! Don't worry—it's easy to get implemented" warning banner is the fallback when neither sample nor real data exists.
- Sample data mistaken for real: defended via badges/tags everywhere observed; the pattern collapses without labeling.
- Sample data lingers: no observed app showed an automated "clean up samples" action — only manual deletion; this gap is the pattern's main cost.

## Accessibility
- DEMO/sample badges must be text labels, not color-only chips (all observed use text).
- Banners (Mixpanel) should be dismissible and not steal focus on every load.

## Default verdict for our stack
VIABLE — a labeled "Demo Conference" event would make module exploration (program, people, travel, comms) instantly legible, but it demands hard guarantees: inert comms, one-click teardown, and visible DEMO badges everywhere. Adopt only with those guardrails; otherwise the conference template (template-vs-blank) carries most of the value at less risk.
