# INDEX — invite-error-states (C1 expired · C2 revoked · C3 already-a-member)

**Coverage note.** Queries run — by-pattern: "invitation link expired error page request a new invite", "invite link no longer valid or revoked contact admin error state", "this invitation has expired ask the person who invited you to send a new one", "you are already a member of this workspace open it instead"; by-app/by-flow coverage came via the B7/B8 sweeps (Linear, Clay, Supabase surfaced there too). Apps swept: Linear, Clay, Supabase, Squarespace, Fresha, NordVPN, Jitter, Sentry, Whereby, Frame.io, Perplexity, sweetgreen (OTP-error adjacents, excluded), Skiff/Grok (recovery-link adjacents, noted under expired card only). NOT found anywhere: a screen explicitly worded "this invite was revoked" — every app collapses revocation into not-found/invalid/no-longer-active copy; that absence is itself a finding. No Slack/Notion/Vercel/Stripe invite-error screens surfaced. Final round was majority duplicates — stopped at saturation.

- ★ expired-link-with-recovery-cta — plain failure headline + exact path to a fresh link + back-to-login + support ID (NordVPN, Jitter, Sentry)
- invite-not-found-dead-end — bare "Not Found, maybe already used?" with zero escape hatch; harvested as anti-pattern (Clay)
- already-member-redirect — "Invitation already accepted / you already have permissions" with logged-in-as, admin/support escalation, or best: just open the org (Linear, Squarespace, Frame.io)
- error-with-auth-escape-hatch — org context preserved, inline error cause, Sign in / Create account buttons that keep the invite pending (Supabase)
- blocked-invite-human-escalation — rule stated in plain language + named human/admin repair path + CTA to where the fix happens; covers revoked-without-saying-revoked (Whereby, Fresha, Linear)

★ marked default: expired-link-with-recovery-cta — it is the only observed error pattern that always pairs the failure with a self-serve repair, and its skeleton (headline · why · next step · secondary exit · support ID) generalizes to all three C-cases; compose with already-member-redirect (C3) and blocked-invite-human-escalation copy (C2).
