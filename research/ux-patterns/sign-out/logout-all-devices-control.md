# Pattern: "Log out of all devices" as a single settings action
**Surface:** sign-out · **Observed in:** Notion, Frame.io, Fireflies, HBO Max, Tripadvisor (refs: [Notion](https://mobbin.com/screens/6e762c68-0171-4bc4-9a2b-614e3c2a54b1), [Frame.io](https://mobbin.com/screens/abc6973b-7c2d-42cb-a555-607ce6d0783e), [Fireflies modal](https://mobbin.com/screens/01cc0f2b-45bb-4628-beaf-e6ffaa3d1f15), [HBO Max flow](https://mobbin.com/flows/ef8fda86-8bcc-41a9-b1ed-ea1cadf466ef), [Tripadvisor flow](https://mobbin.com/flows/fb03239a-7602-4b01-b7c1-2ebc82847656))

## Flow
1. A single row/button in account settings: Notion "Log out of all devices — Log out all other active sessions on other devices besides this one"; Frame.io "Log Out Of All Active Sessions" with a Log Out button; Tripadvisor a text link "Sign out of all other sessions" framed by "Forgot to log out of your account on someone else's computer? Lost your phone?".
2. Variants on scope: "all OTHER devices besides this one" (Notion, Tripadvisor — current session survives) vs "all devices" (HBO Max — current included; its Devices page then shows "Browser is signed out").
3. Fireflies shows the device list in a modal first, with destructive-red "Logout From All" + Cancel.
4. Confirmation after: Tripadvisor success toast "Successfully signed out all other sessions" with follow-up advice ("if you are concerned about someone using your account... change your password").

## Use when
- Complement to the per-session list: the panic button for lost/shared devices. Best placed next to the sessions list and offered again inside password-change (see account-settings card).

## Avoid when
- Ambiguous scope copy — never say "all devices" if the current session survives (or vice versa); skipping a result confirmation leaves users unsure the panic button worked.

## Sad paths observed
- Tripadvisor's entry copy targets the exact fear scenarios (lost phone, someone else's computer) and its success message chains to the next remediation step (change password).
- HBO Max device page links the related risk: "Lost or stolen device? To protect your account, change your password before signing out."

## Accessibility
- Plain button/link with descriptive label; Fireflies' modal confirm gives keyboard users an explicit decision point before mass revocation.

## Default verdict for our stack
RECOMMENDED — one "Log out of all other devices" action beside the sessions list, Notion-style scope copy, with a success confirmation and a pointer to change-password.
