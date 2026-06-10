# Pattern: Isolated demo sandbox with persistent exit banner
**Surface:** zero-data-empty-states · **Observed in:** Mixpanel, Amplitude, Plain, Causal, Databricks (refs: https://mobbin.com/screens/a49d0d60-5e1e-4b69-8eae-e950634c5e43, https://mobbin.com/flows/42a32cc8-e62f-4b38-b8fb-526822b01213, https://mobbin.com/flows/e3bc795d-7f68-4bb3-8ca6-090d6da968cc, https://mobbin.com/screens/fe5f46be-c681-4492-bb65-5b63f5960ea0, https://mobbin.com/flows/710c15b9-59ac-4596-998c-67b668fa106c, https://mobbin.com/screens/cd9eaaba-1184-4a04-9a3d-7de753b119d3)

## Flow
1. Demo data never mixes with tenant data — it lives in a separate container: Mixpanel demo project (switchable from the project picker), Amplitude Demo environment, Plain "Demo Workspace" chosen at workspace creation, Databricks `samples` catalog beside your own catalog, Causal a cloned "Getting started (Cloned)" model file in your list.
2. While inside, a persistent banner marks the state and carries the exit ramp: Mixpanel — "Welcome! You are viewing a Mixpanel demo. Start building with your own data by clicking 'Implement Mixpanel'. [Implement Mixpanel] [Watch Tutorial]"; Amplitude — top bar "You are currently in the Amplitude Demo. [Start sending data] or [Contact us]" plus a floating "Demo Guide (3)" pill.
3. Demo content is read-only or clearly scoped ("View only" on Mixpanel sample boards); Plain enumerates the tradeoff at creation: "Populated with dummy workspace and customer data" with a red X on "Not suitable for helping live customers".
4. "Removal" requires no cleanup: the user switches to (or creates) the real container; the demo container is simply abandoned or deleted whole. Causal's variant — a cloned sample model — is deleted like any file.

## Use when
- Demo data is voluminous/realistic enough to be mistaken for real records — isolation makes the boundary structural, not cosmetic.
- Multi-workspace architecture already exists (Event State is multi-tenant; a "sample event" container maps naturally).

## Avoid when
- The product's containers are heavyweight (creating a whole tenant for demo is overkill) — prefer a sample entity (one labeled sample event) over a sample workspace.
- Users need to practice destructive actions on demo data but the sandbox is read-only — Mixpanel's view-only boards block exactly the experimentation demos exist for.

## Sad paths observed
- Plain's demo workspace can't be converted to real — work done "testing" is discarded; the creation screen warns, but only in small checklist text.
- Amplitude's demo stacks banner + Demo Guide pill + product chrome — three layers of meta-UI over the actual product.

## Accessibility
- Banners are persistent text bars with real buttons (good); ensure they're landmarks at the top of DOM order, not floating overlays only.
- Color alone never marks demo state in observed apps — there is always a text label. Keep that invariant.

## Default verdict for our stack
RECOMMENDED — if Event State offers sample data, ship it as one clearly-labeled sample event (badge + banner inside it: "This is a sample event — create your real event") that can be deleted whole; never seed sample people/data into tenant-global lists.
