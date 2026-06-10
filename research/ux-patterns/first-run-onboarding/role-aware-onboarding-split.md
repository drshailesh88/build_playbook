# Pattern: Role-aware first-run (admin vs invited member)
**Surface:** first-run-onboarding · **Observed in:** n8n, Charma, Maze, Grain, Notion, Otter.ai (refs: [n8n joining flow](https://mobbin.com/flows/243292b2-c4f5-45aa-9c64-13963a516cf0), [Charma accepting flow](https://mobbin.com/flows/36f978ac-6c87-4633-b9c0-01d390fe67b9), [Maze accepting flow](https://mobbin.com/flows/d179f027-5c6e-443d-81eb-9f9dde70cc65), [Grain join step](https://mobbin.com/screens/1d5d2d52-8f06-4a67-b5b0-e51b8ffbf6ac), [Notion join-or-create](https://mobbin.com/screens/1f794a8f-3b4d-4f47-99a5-158c604317dc), [Otter join teammates](https://mobbin.com/screens/c6a2effd-d510-40e9-8472-8b17689a245b))

## Flow
1. Invitee arrives via invite link/email and gets a PERSONAL setup only — name + password ("Alex Smith has invited you to n8n — Set up your account"), optionally role/company-size profile (Maze "Tell us a bit about yourself").
2. The org/workspace creation wizard is entirely skipped — no workspace naming, no template choice, no customization survey.
3. Invitee lands directly in the populated workspace: n8n drops them into the Overview with the team's existing "Simple Workflow" visible; Maze lands on team home with a "Team joined!" toast.
4. Onboarding content reflects shared state: Maze's "Get started with Maze" checklist on the invitee's home already shows step 1 "Create a study" checked — completed by a teammate; the checklist is per-team, not per-user.
5. Where the invitee gets any guided steps, it's a short personal usage primer, not setup: Charma shows a 3-item "Getting started" (View your Agenda / Add to the agenda / Use for your next 1:1) with a Skip, then lands in a pre-populated 1:1 workspace with a persistent "Quick Start Guide" docked bottom-of-sidebar.
6. Email-domain discovery offers join-before-create for ambiguous arrivals: Notion "Join teammates or create a workspace", Otter "Join your teammates" with Skip, Slack "Is your team already on Slack?".

## Use when
- Always, in any multi-tenant product — an invited member who hits the admin's "create your workspace / first event" wizard is a broken state, full stop.
- The admin checklist contains org-level steps (billing, domains, modules) that members can't and shouldn't see.

## Avoid when
- Never skip the split entirely. But avoid over-building the member side: n8n's near-zero member onboarding (land in the workspace, one "Get started faster with pre-built agents" banner) is observed and sufficient when the workspace already has content to learn from.

## Sad paths observed
- Invitee without an account: Clay requires "Sign up for Clay to accept the invitation" ([ref](https://mobbin.com/screens/c861efe0-7a55-4a5f-8286-f7c6589d0bcd)) and shows invite age + "expires in a month" — expiry is surfaced before effort is invested.
- Shared checklist confusion: Maze's team checklist shows items done by others on a brand-new member's home — efficient, but the member sees "completed" work they never did; label who completed if reusing this.
- Member skips the primer: Charma's Skip lands them in a workspace that is pre-populated, so skipping is safe — the workspace itself teaches.

## Accessibility
- Invite-acceptance pages are form-first; keep them single-column with proper labels (all observed comply).
- Toasts like "Team joined!" (Maze) must be aria-live announced and not the only confirmation — Maze pairs it with the persistent team header.

## Default verdict for our stack
RECOMMENDED — hard-split at DEC-041's gate: org creator → first-event wizard + admin checklist; invited member → profile-only setup, land inside the existing event, member-scoped quick-start (find your tasks, view program) with org-level steps invisible.
