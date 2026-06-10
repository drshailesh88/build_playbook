# INDEX — accept-invite-new-user (B7)

**Coverage note.** Queries run — by-app: "Slack join workspace invitation sign up", "Notion Linear Figma accept invitation to join team landing page"; by-pattern: "you've been invited to join a workspace create account sign up", "log in to accept your invitation organization name shown"; by-flow: "accept a team invitation from email and create a new account", "existing user signs in and joins a workspace they were invited to". Apps swept: Slack, Notion, Zeplin, Optimal Workshop, Air, ClickUp, Charma, Attio, Retool, Slite, Dropbox, Square, Sprout Social, Clay, Fibery, Bonsai, Steep, Basecamp, HubSpot, WorkOS. NOT found despite targeting: Raycast, Vercel, Stripe, Figma invite-accept screens (no results on web); Linear surfaced only in error states. Last two query rounds returned >70% already-seen screens — sweep stopped at saturation.

- ★ locked-email-invite-signup — full signup form with invite-bound read-only email and combined "sign up and accept" CTA (Retool, Dropbox, Air, Optimal Workshop, ClickUp, Charma, Zeplin)
- single-field-completion — invite link authenticates email; user supplies one field (name or password) and lands in the workspace (Slack, Square, Sprout Social, Fibery)
- oauth-one-click-accept — "Sign up with Google and accept" above the email form (Optimal Workshop, HubSpot, Steep, Slack, Charma, Air, Fibery)
- org-context-header — "X invited you to Y" headline + inviter avatar/social proof + expiry shown upfront (Slack, Charma, Clay, Fibery, Basecamp, Retool)
- passwordless-otp-accept — verify emailed code to accept; resend cooldown (Notion)
- auto-join-with-progress — membership granted on signup success with visible "Joining team…" state, lands inside the org (Notion, Retool, Clay, Bonsai)

★ marked default: locked-email-invite-signup, composed with org-context-header, oauth-one-click-accept on top, and auto-join-with-progress on submit — together they form the candidate default stack; treat the four as one composite recommendation, not alternatives.
