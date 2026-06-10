# Pattern: Org-Context Header with Inviter Social Proof
**Surface:** accept-invite-new-user · **Observed in:** Slack, Charma, Clay, Fibery, Basecamp, Retool (refs: [Slack](https://mobbin.com/screens/ffe87cb7-2628-4751-a368-9010a5cdead0), [Charma](https://mobbin.com/screens/02a6dc7a-717f-4533-bd8a-b89b8a3ca34c), [Clay flow](https://mobbin.com/flows/c633c6c4-340d-4ba9-84ca-161c0d546a21), [Fibery flow](https://mobbin.com/flows/49bf3863-b754-4a82-be03-bb19182051cb), [Basecamp](https://mobbin.com/screens/c821113f-2a61-4da7-954a-a99e7536c967), [Retool flow](https://mobbin.com/flows/4976cb81-97fd-4bbf-8b43-478e0111c588))

## Flow
1. Page headline names the org: "Join SLMobbin on Slack", "Welcome to Jsmobbin Team" (Fibery), "Join JD Mob on Basecamp 4".
2. Inviter identity is shown: Slack renders the inviter's avatar + "Sam Lee has already joined"; Charma: "join Jane Smith and 2 others at Jane Smith's organization"; Clay: "@samlee.mobbin invited you to join their Workspace Sam's Workspace 3 minutes ago"; Retool: "Sam invited you to make an account!".
3. Clay additionally states invite freshness and lifetime upfront: "This invitation expires in a month."
4. The signup/accept controls render beneath this trust block.

## Use when
Always on invite landings — the "who invited me, to what" answer is the page's primary job and the main defense against phishing-feel; especially when recipients may not know the product.

## Avoid when
Inviter identity is sensitive (external guest invites where exposing member names/avatars leaks org info); then show org name only.

## Sad paths observed
Clay's expiry line doubles as pre-emptive sad-path messaging — the user knows the deadline before it ever errors.

## Accessibility
Headline carries org name as the page h1 so screen readers announce context first; avatars need alt text naming the inviter.

## Default verdict for our stack
RECOMMENDED — org name + inviter name/avatar + "already joined" count is cheap, on-brand for Linear-quality polish, and directly reuses our invitation record fields.
