# Pattern: Danger-zone delete with type-org-name-to-confirm modal
**Surface:** delete-org · **Observed in:** PlanetScale, Clerk, Supabase, Campsite, TheyDo (refs: [PlanetScale](https://mobbin.com/screens/2731c38b-ba36-4854-801c-470b3907942f), [Clerk](https://mobbin.com/screens/9405fde8-45e2-4259-afb9-14e00173cf28), [Supabase](https://mobbin.com/screens/7ad2c208-a597-4b6c-9290-eca8daf1622a), [Campsite](https://mobbin.com/screens/3f2972d0-9595-4b0c-9b1d-efa140b01424), [TheyDo](https://mobbin.com/screens/a6aa10aa-484d-4911-b934-41aedcc229c0))

## Flow
1. Org settings page ends in a visually distinct Danger Zone section/card: "Delete organization — There's no going back. Deleting a organization is permanent." (Campsite) with a red Delete button.
2. Modal opens with: (a) the question naming the org, (b) consequences — Campsite: "All posts will be permanently deleted. All people will be removed."; Clerk: "This organization and all associated data will be deleted."; Supabase: "will permanently delete the X organization and remove all of its projects", (c) retention statement — "This action cannot be undone / is irreversible / permanent" (all five; PlanetScale styles it red).
3. Labeled type-to-confirm field: "Enter the organization name <name> to confirm" / "Type 'SLMobbin' to confirm". Supabase requires typing a random generated string instead of the org name.
4. Destructive button, disabled until match (Campsite's "Delete forever" shown disabled pre-typing); Supabase labels it "I understand, delete this organization".

## Use when
Deleting the whole tenant and everything in it; this is the de-facto standard across infra-grade tools (the reference-quality cohort).

## Avoid when
The thing deleted is recoverable from trash (then say so instead — see GitBook "Delete space … can be restored from trash for up to 7 days", https://mobbin.com/screens/fcf03801-3bbf-4f2b-b9dc-bdc5dcf2e066 — type-to-confirm would be dishonest there); avoid Supabase's random-string variant unless org names are untypeable (emails/UUIDs).

## Sad paths observed
Disabled-until-exact-match button prevents reflex confirmation; irreversibility is stated in-modal in every example, never only in docs.

## Accessibility
Type-to-confirm inputs are explicitly labeled with the exact expected string; destructive buttons carry verbose labels ("I understand, delete this organization") rather than bare "OK".

## Default verdict for our stack
RECOMMENDED — Danger Zone card + AlertDialog with consequences list, "cannot be undone" retention line, type-org-name gate, disabled destructive button; exact match to Clerk/PlanetScale-grade expectations.
