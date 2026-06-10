# Pattern: Domain Verification by Emailed Code (no-DNS first step)
**Surface:** comms-sender-setup · **Observed in:** Mailchimp (refs: [verify-a-domain flow](https://mobbin.com/flows/469fc953-8fb2-4325-9c29-3b92296199bd), [send verification email modal](https://mobbin.com/screens/425ba7c8-c5ce-4e47-8981-bb1d832f29f2), [enter code modal](https://mobbin.com/screens/62b18656-b81d-46a8-a7c2-5d1c83b66f02), [domains page with auth chip](https://mobbin.com/screens/0fc92db3-bd0f-40c9-8e76-0fc1a10b462d))

## Flow
1. Domains page splits "Custom Email Domains" from "Public Email Domains" (gmail.com etc.), the latter annotated with "limitations of using free email" guidance.
2. "Add & Verify Domain" → modal asks for an address AT the domain ("Enter an address that contains the domain you want to verify") → "Send Verification Email".
3. Second modal confirms "Your verification email is on the way!" and accepts the code two ways: click "Verify Domain Access" in the email OR paste the code into the field → Verify.
4. Success toast "Domain successfully verified!" with a "Verify another" shortcut — but the domain row then shows a "Needs authentication" amber chip with a "Start Authentication" button: verification (you control an inbox) is explicitly staged BEFORE authentication (DNS/DKIM).

## Use when
- You want a low-friction proof-of-control step before asking for DNS work — users with no DNS access can still register the domain and send (degraded) while authentication is pending.
- Splitting "verified" from "authenticated" in the data model: Mailchimp's two-chip staging is the only observed UI that names this distinction.

## Avoid when
- Inbox-at-domain doesn't exist yet (new event brands often have no mailbox) — the code email is undeliverable and the flow dead-ends.
- DKIM/SPF is mandatory before any send in your sending policy — the intermediate "verified but unauthenticated" state would be a lie.

## Sad paths observed
- The "Needs authentication" chip persists on the domains roster after the success toast — the system prevents users from mistaking step 1 for done.
- Public/free domains are not blocked but get explicit limitation warnings instead.

## Accessibility
- Code entry offers a typed alternative to the email link (works when the email opens on another device).
- Status chips use text labels ("Needs authentication"), not color alone.

## Default verdict for our stack
VIABLE — useful as an optional pre-step or fallback when DNS is blocked, but DNS-table verification (see domain-dns-verification card) should remain the primary path; adopt Mailchimp's verified-vs-authenticated vocabulary only if we support a degraded sending mode.
