# Pattern: Checklist completion celebration and retirement
**Surface:** first-run-onboarding · **Observed in:** Mailchimp, Graphite, Remote, Outseta, Alan, Linktree (refs: [Mailchimp "ready to fly"](https://mobbin.com/screens/68b7d413-4b48-49e6-b846-28ffce12d2cd), [Graphite confetti 5/5](https://mobbin.com/screens/52700a50-4600-4a27-a467-f3023a8130a0), [Remote 100% complete](https://mobbin.com/screens/8054afb4-36e4-4e84-81e3-c4c6d30380fd), [Remote "You're all set"](https://mobbin.com/screens/d5b8e656-e617-441c-976e-1a56deecb768), [Outseta remove-from-sidebar](https://mobbin.com/screens/b1bcf27d-e787-4a4d-81f7-a1ec5515f5fe), [Alan](https://mobbin.com/screens/123b236c-5a85-4e5d-81df-8ff5f5a317d5), [Linktree](https://mobbin.com/screens/15bce965-033f-424f-ae47-ad9c544cb798))

## Flow
1. Final checklist item completes → momentary celebration: confetti burst over the struck-through list (Graphite "5 of 5 tasks complete"), confetti + check mark (Remote, Alan), full-screen "Looking good!" (Linktree).
2. A completion message reframes graduation, not just completion: Mailchimp "You've completed the checklist. You're ready to fly on your own."
3. The user is given an explicit retirement action: Mailchimp "Dismiss checklist" button in the completion banner; Outseta's completed 8/8 guide ends with a "Remove 'Setup' from the sidebar" link — the checklist asks to be deleted.
4. Next-step handoff replaces the checklist's job: Remote pairs "You're all set!" with "Go to dashboard" plus follow-on suggestion cards ("Finish company verification", "Order equipment"); Alan offers "Add another member / Invite Alex".
5. After dismissal, the checklist entry disappears from nav; no observed app keeps a completed checklist around permanently.

## Use when
- A persistent checklist exists (this is its mandatory exit; a checklist with no retirement becomes permanent UI debt).
- You can name the user's next meaningful action and hand off to it (Remote's suggestion cards).
- Always pair: celebration (momentary) + retirement (explicit user or auto action).

## Avoid when
- Completion is partial/forced — celebrating 5/5 when 2 items were "skipped" reads as hollow; only celebrate genuinely-done states or phrase honestly.
- Confetti on every minor step (reserve for terminal completion; Linktree fires it mid-flow which dilutes it).
- The "celebration" is actually an upsell screen (Slack's "Your workspace is ready to go!" final step is a Free-vs-Pro plan picker — [ref](https://mobbin.com/screens/80d7317a-cf61-4271-ab24-17f6ab129ca8); it works for Slack but reframes the moment as a sales gate).

## Sad paths observed
- Checklist never completed: Mailchimp exposes "dismiss the checklist" even at 4/5 ("If you don't need to see this anymore") — retirement must not require completion.
- Dismissed too early with no way back: Outseta's removal link is one-way on the screens observed; no "restore setup guide" affordance found in this sweep — a real gap to design for.
- Completion with skipped items: Graphite's "Complete setup later" header button coexists with the checklist, acknowledging permanent partial state.

## Accessibility
- Confetti is decorative motion — must respect prefers-reduced-motion and never carry information alone; all observed pair it with a text headline ("Great job!", "100% complete").
- The completion state change should be announced (aria-live) since it appears asynchronously after the last task.
- Dismiss/remove actions are real buttons in all observed apps — keep them so.

## Default verdict for our stack
RECOMMENDED — ship the checklist's exit with the checklist: confetti-light completion state, "You're ready" copy, explicit dismiss, and a restore path in settings (the gap every swept app left open).
