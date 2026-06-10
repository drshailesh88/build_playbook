# INDEX — pending-invites (B9)

## Coverage
- Queries run — by-pattern: "pending invitations list resend revoke invite expiry"; by-app: Vercel/Linear/Slack members queries (pending tabs and badged rows surfaced there); by-flow: "accepting a team invitation from email notification" (1Password admin-confirm states), "change a member's role or remove member from team settings" (Exa pending rows). Platform: web only.
- Apps swept: Slack, Vercel, Threads, Upwork, 1Password, Cloaked, Linear, Exa, Fibery, Miro, Mural, Visitors.
- NOT found / excluded: no app showed a resend cooldown/rate-limit UI; no expired-invite distinct visual state beyond 1Password's status column; Notion pending-invite UI did not surface (its link-led model may simply lack one); no Raycast/Stripe pending lists captured.
- Saturation: tab vs same-table and resend/revoke shapes repeated across all later queries; final queries added only result-state details (Slack bounced/resent/revoked).

## Patterns
- ★ pending-tab-on-members-page — sibling tab with count, invite-specific columns (Vercel, Threads, Miro, Upwork, 1Password, Slack)
- ★ inline-resend-revoke-actions — resend button + overflow revoke + in-row result/bounce states (Slack, Threads, 1Password, Cloaked, Vercel)
- ★ expiry-display-and-policy — Sent/Expires columns, invited-by attribution, policy copy on the list (1Password, Slack, Upwork)
- same-table-as-members — badged pending rows in the members table; no resend affordance observed (Linear, Exa, Fibery, Visitors)
- admin-confirmation-after-accept — two-sided join with admin Confirm/Reject (1Password) — AVOID for our tier

★ = recommended default: Pending tab + resend/revoke actions + expiry columns compose into one surface; same-table is the documented runner-up.
