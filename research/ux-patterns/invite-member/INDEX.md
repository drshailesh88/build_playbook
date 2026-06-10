# INDEX — invite-member (B5)

## Coverage
- Queries run — by-app: "Slack invite people to workspace modal email", "Vercel team members settings page role column" (inline invite surfaced), "Notion workspace settings members list role dropdown" (Add members + link); by-pattern: "invite team members onboarding multiple email addresses bulk add roles"; by-flow: "invite a teammate to workspace by email and assign role" (Clay, Fibery, Sana AI, Current flows). Platform: web only.
- Apps swept: Slack, Stripe, Vercel, Linear, Notion, Fibery, Sana AI, Clay, Current, Plane, GitBook, Grok, Perplexity, Attio, Dub, Cloaked, Airwallex, Visitors, 1Password.
- NOT found / excluded: no CSV-upload bulk invite observed on web in these sweeps (Current's "Add in bulk" was the closest); no Raycast invite screens surfaced; dedicated full-page invite (non-onboarding) only as admin sub-page (Slack admin, 1Password "Send invites" tab) — rare among product-quality references.
- Saturation: repeater + modal + link variants recurred across every later query; no new compose shape after the flow sweep.

## Patterns
- ★ invite-modal-email-role — modal with multi-email tokens + role picker, optional message (Slack, Stripe, Sana AI, Fibery, Clay)
- ★ email-role-row-repeater — per-row email + role dropdown, "Add another", bulk-paste escape hatch (Vercel, Plane, GitBook, Grok, Perplexity, Attio, Dub, Current) — as the modal's body
- ★ role-picker-with-descriptions — every role option carries a one-line permission summary (Vercel, Plane, GitBook, Slack, Stripe, Exa, Notion)
- ★ invite-guardrails-and-confirmation — external-domain confirm, billing/quota disclosure, sent-toast/tracker (Linear, Perplexity, Cloaked, Fibery, Airwallex, Plane)
- inline-invite-section-on-members-page — persistent compose card above the table (Vercel, Visitors, 1Password)
- shareable-invite-link — toggleable link + copy + rotate alongside email invites (Linear, Notion, Slack, Vercel, Fibery, Current)

★ = recommended default: modal compose whose body is the email+role repeater, with described role pickers and Linear-style guardrails; invite link deferred, inline section rejected for viewport cost.
