# Pattern: Post-auth workspace setup step
**Surface:** sign-up · **Observed in:** Linear, Slack, Dovetail, Productboard, Fibery, Equals (refs: [Linear](https://mobbin.com/screens/cb22741c-b840-445b-b8ea-88d1fb94d89f), [Linear region select](https://mobbin.com/screens/e822cf1a-eb1a-4eb7-89c5-a6b7e657b24b), [Slack step 1 of 3](https://mobbin.com/screens/59cf344d-f40d-4522-9f05-a65a6da21185), [Slack domain-join checkbox](https://mobbin.com/screens/111752d0-c9b7-4d13-a0bb-e8a973dd9ec2), [Dovetail flow](https://mobbin.com/flows/5afc337b-50b5-4c11-8152-11ed8db44014), [Productboard flow](https://mobbin.com/flows/54bce0a9-613c-4770-85e0-92c09b001e90), [Fibery flow](https://mobbin.com/flows/381b62cc-9b4d-48a2-9c62-42d996a81ce7), [Equals flow](https://mobbin.com/flows/374db6fd-7e5b-4e66-8da3-caf401350deb))

## Flow
1. Immediately after credential creation/verification, a separate "Create your workspace" screen — account and tenant creation are decoupled.
2. Core fields: workspace name + URL slug with live prefix preview "linear.app/slmobbin" (Linear, Productboard, Fibery ".fibery.io").
3. Optional enrichment on the same or next screen: company size, role dropdowns (Linear, Dovetail), data-hosting region with "cannot be changed later" warning (Linear, Dovetail "Workspace data location").
4. Progress signal when multi-step: Slack's "Step 1 of 3" label; logged-in identity shown corner-pinned with "Log out" escape (Linear).
5. Growth toggle: "Let anyone with an @domain email join this workspace" checkbox (Slack).

## Use when
- Multi-tenant products — every observed B2B reference treats tenant creation as its own post-auth step, never crammed into the signup form.
- Slug/URL must be validated live against collisions.

## Avoid when
- Invited users joining an existing tenant — they must skip straight to the join flow (Slack's invite path collects only display name: [ref](https://mobbin.com/screens/bd245218-9369-45e1-a333-babb075db360)).
- Single-tenant/personal tools.

## Sad paths observed
- Linear region picker warns irreversibility inline before commit ([ref](https://mobbin.com/screens/e822cf1a-eb1a-4eb7-89c5-a6b7e657b24b)).
- Equals shows in-button spinner during workspace creation ([ref](https://mobbin.com/flows/374db6fd-7e5b-4e66-8da3-caf401350deb)).
- Logged-in-as + Log out escape prevents creating a tenant under the wrong account (Linear).

## Accessibility
- One question block per screen with explicit step counter (Slack) aids orientation; dropdowns are native selects in Linear/Dovetail.

## Default verdict for our stack
RECOMMENDED — our multi-tenant model needs exactly this seam: Better Auth organization creation as a dedicated screen after signUpEmail, with name + slug and "logged in as" escape.
