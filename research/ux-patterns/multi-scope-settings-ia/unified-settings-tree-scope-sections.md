# Pattern: Unified Settings Tree with Scope Sections
**Surface:** multi-scope-settings-ia · **Observed in:** OpenAI Platform, Amplitude, Linear, Retool, Notion (refs: [OpenAI org+project tree](https://mobbin.com/flows/ecb4c992-e6b5-48a4-86fc-5075f2a8b450), [Amplitude org settings](https://mobbin.com/flows/cc3228ea-dbbc-47a2-9991-794d30f23ca9), [Linear settings sidebar](https://mobbin.com/screens/1d9fbb8e-66b3-4809-a2ed-8f9d514753c7), [Retool settings](https://mobbin.com/flows/4cbc1e95-32d8-4141-96b9-13717b3f4eab), [Notion settings modal](https://mobbin.com/screens/733d7981-311a-487d-a0b3-fc30511763ae))

## Flow
1. One settings destination holds ALL scopes; the sidebar is partitioned by labelled sections — OpenAI: "Organization / Mobbin" (General, Members, Billing, Limits) followed by "Project / Default project" (General, Members, Limits) plus "+ Create project" inline.
2. Jumping from a project setting to an org setting is one sidebar click — no exit, no re-entry, no context loss.
3. Linear extends it to three scopes in one tree: Workspace section, "My Account" section, and a "Teams" section listing each team with its own sub-pages, plus "< Back to app" to exit settings entirely.
4. Amplitude/Retool/Notion run the two-section variant: "Organization settings" + "Personal settings" (Amplitude), "Account / User management / Organization / …" (Retool), "Account" + "Workspace" groups in a modal (Notion).
5. The content header re-states the active scope ("Organization settings", "Limits" under Project) so the section label isn't the only cue.

## Use when
- Cross-scope hops are frequent (admin configuring org defaults then a specific event) — this is the strongest answer to sub-area (b), scope switching inside settings.
- The number of child resources visible in the tree stays small (OpenAI shows ONE project at a time with a switcher; Linear lists only your teams).

## Avoid when
- Tenants have many events — a tree listing every event's settings does not scale; you would need an in-tree event switcher like OpenAI's, at which point per-resource entry (separate card) may serve better.
- Permission boundaries differ sharply per scope; one tree invites members to see admin sections they can't edit (must then be hidden/locked per item).

## Sad paths observed
- OpenAI: selecting Limits on the default project yields "You cannot set limits on the default project — Create a new project to set limits" — an inline empty/blocked state instead of hiding the page.
- Amplitude shows plan quota ("MTU Quota 0 of 100,000") with an Upgrade Plan CTA inside org settings — billing sad paths surface in place.

## Accessibility
- Labelled sidebar sections create a navigable hierarchy; Linear additionally provides an explicit "Back to app" escape hatch (predictable focus exit).
- Notion's modal variant traps settings in a dialog — heavier focus-management burden than full-page settings.

## Default verdict for our stack
VIABLE — strong for Org zone vs Account zone in one tree (already our DEC-038/043 shape), but it does not scale to per-event settings for many events; keep events out of the global tree.
