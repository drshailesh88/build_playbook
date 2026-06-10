# Pattern: Sign-out confirmation dialog (only with a stated consequence)
**Surface:** sign-out · **Observed in:** WhatsApp Web (refs: [log out? dialog](https://mobbin.com/screens/df887a48-8bc6-4feb-9c86-9f7efac49be9))

## Flow
1. User clicks "Log out" (red, last item in settings list).
2. Dialog: "Log out?" — body explains the concrete consequence: "App lock will reset if you log out. Do you want to lock WhatsApp Web instead?"
3. Three options: alternative action ("Lock app"), "Cancel", destructive-red "Log out".

## Use when
- ONLY when sign-out has a real, stated cost (losing local state, resetting device pairing/app lock) — and ideally offer the lighter alternative the user may have actually wanted (lock vs log out).

## Avoid when
- Plain web SaaS sign-out with no data loss — every B2B app observed (Vapi, Pitch, Runway, Origin, YouTube, Notion) signs out with zero confirmation; an empty "Are you sure?" is pure friction.

## Sad paths observed
- The dialog itself IS the sad-path handler: it pre-empts accidental loss of app-lock state and routes users to the non-destructive alternative.

## Accessibility
- Three-button dialog: destructive action is rightmost and color-differentiated; Cancel available — standard dialog keyboard semantics required.

## Default verdict for our stack
AVOID (as default) — we have no sign-out cost that warrants it; reserve this pattern for the future case where signing out would discard unsaved tenant work, and then name the consequence in the dialog body.
