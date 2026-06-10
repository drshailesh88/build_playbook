# INDEX — accept-invite-existing-user (B8)

**Coverage note.** Queries run — by-pattern: "accept invite confirmation while signed in join this workspace yes or no", "invitation was sent to a different email address signed in with wrong account switch account", "log in to accept your invitation organization name shown", "you are already a member of this workspace open it instead"; by-flow: "existing user signs in and joins a workspace they were invited to"; by-app terms folded into the above (Slack/Notion/Linear/Figma named in B7 sweep). Apps swept: Attio, Plane, Intercom, Clearbit, Descript, Asana, Better Stack, Basecamp, Clay, Frame.io, WorkOS, Notion, Synthesia, Steep, Otter.ai, Whereby. NOT found: Raycast, Vercel, Stripe, Linear accept screens; generic Google "Choose an account" OAuth chooser screens (Grain, Cron, mymind, Google Meet) were excluded as provider chrome, not product UX. Final query round was >60% duplicates — stopped at saturation.

- ★ join-confirmation-interstitial — org card + one explicit "Accept & Join" with decline/defer secondary for signed-in users (Attio, Plane, Intercom, Clearbit)
- identity-check-in-accept — "Joining as {email} · Not the right account?" inline identity display + escape hatch (Descript, Asana, Intercom, Plane)
- switch-account-chooser — wrong-session interrupt with two email-labeled buttons: switch vs stay (Better Stack)
- login-or-signup-fork — signed-out landing forks "log in and join" vs "make a new login", best with invited-email account detection (Basecamp, Clay, Frame.io, WorkOS)
- pending-invites-picker — post-auth list of all pending invites with per-row Join, Accept all, joined badges, decline X (Notion, Synthesia, Steep, Otter.ai)

★ marked default: join-confirmation-interstitial — for a multi-tenant events SaaS, one explicit consent click with the org card, visible acting identity (compose with identity-check-in-accept), then auto-switch to the new org is the Linear-grade behavior; switch-account-chooser is the designated mismatch branch.
