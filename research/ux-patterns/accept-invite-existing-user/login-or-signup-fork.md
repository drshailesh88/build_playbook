# Pattern: Login-or-Signup Fork on Invite Landing
**Surface:** accept-invite-existing-user · **Observed in:** Basecamp, Clay, Frame.io, WorkOS (refs: [Basecamp](https://mobbin.com/screens/c821113f-2a61-4da7-954a-a99e7536c967), [Clay flow](https://mobbin.com/flows/c633c6c4-340d-4ba9-84ca-161c0d546a21), [Frame.io](https://mobbin.com/screens/04cb2804-b240-4a19-b934-73f5617d08f1), [WorkOS](https://mobbin.com/screens/529e0cdb-4c09-4df7-86ab-837e59076811))

## Flow
1. Signed-out user hits the invite link; landing shows org context plus an explicit two-way fork instead of assuming new-user.
2. Basecamp: "Join JD Mob on Basecamp 4" → "Make a new login with my email" / "Or, if you've used Basecamp before: Log in and join with my account".
3. Clay phrases it inline: "Sign in or Sign up to accept your invite from Sam Lee to Workspace Sam's Workspace".
4. Frame.io detects an existing account for the invited email and leads with it: "You've already been invited!" + account card + "Join" with "Create my own account" as the alternate.
5. WorkOS pre-fills the invited email with "Continue" (auth method resolved after) + "Continue with Google".
6. Either branch returns to the same accept/join completion.

## Use when
Invite links are opened signed-out and you cannot know if an account exists — the fork must be on-screen; best version (Frame.io/WorkOS) looks up the invited email and pre-selects the right branch.

## Avoid when
You can reliably detect account existence server-side — then route directly instead of asking (show the fork only on ambiguity); avoid burying "log in instead" in fine print on a signup-first page (Zeplin-style small link underperforms an explicit fork for B2B re-invites).

## Sad paths observed
Bonsai variant: hitting the invite while signed-out bounces to login with toast "You need to sign in or sign up before continuing", then returns to the invite — works, but the toast is the only context, weaker than Basecamp's self-explaining fork ([Bonsai flow](https://mobbin.com/flows/174c5855-65a9-4360-8caf-cfadac836bd3)).

## Accessibility
Two clearly-worded buttons beat a form plus a low-contrast link; keep both in tab order with full-sentence labels.

## Default verdict for our stack
RECOMMENDED — invite landing checks whether the invited email has an account: existing → login prefilled with org context; none → B7 signup; ambiguous → Basecamp-style explicit fork.
