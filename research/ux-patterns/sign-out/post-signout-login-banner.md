# Pattern: Post-sign-out confirmation on the login page
**Surface:** sign-out · **Observed in:** Intercom, Gamma, Mailchimp, Docusign (refs: [Intercom](https://mobbin.com/screens/bb64cb96-75db-483b-99af-c30fb69ccd7c), [Gamma](https://mobbin.com/screens/128b9985-637b-420d-bcf5-7384f28a718d), [Mailchimp](https://mobbin.com/screens/17299fe4-8a3f-46d4-993b-4fd7d11481e0), [Docusign](https://mobbin.com/screens/a3958355-8d10-4997-b6b2-3d65181000a6))

## Flow
1. After sign-out, user lands on the login page.
2. The page acknowledges the action: Intercom inline banner "Signed out successfully."; Mailchimp banner "You've been logged out. Don't worry, you can log back in below"; Gamma toast "You've been signed out."; Docusign dedicated headline "You've been securely logged out."
3. Re-entry is pre-greased: email field prefilled with the previous account (Intercom, Docusign).

## Use when
- Always after explicit sign-out — closes the loop ("it worked") and distinguishes intentional sign-out from an error or session expiry on the same login screen.

## Avoid when
- Shared/public devices: prefilling the previous email leaks the account identifier to the next user — make prefill removable ("Not you?" / clear button) or skip it for privacy-sensitive products.

## Sad paths observed
- Mailchimp's copy pre-empts user worry ("Don't worry, you can log back in below") — reassurance that nothing was lost.

## Accessibility
- Persistent inline banner (Intercom, Mailchimp) is screen-reader reliable; Gamma's auto-dismissing toast risks being missed — prefer banner.

## Default verdict for our stack
RECOMMENDED — render /login with a "Signed out successfully" inline banner (via query param or flash cookie) and prefill email with an easy clear affordance.
