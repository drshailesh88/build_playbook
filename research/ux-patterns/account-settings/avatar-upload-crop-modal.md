# Pattern: Avatar upload with crop/zoom modal
**Surface:** account-settings · **Observed in:** Linear, Slack, Vercel (refs: [Linear adjust-avatar modal](https://mobbin.com/screens/0499081e-f00f-4f39-ae22-9a15acd422a2), [Slack edit-profile photo](https://mobbin.com/screens/10f59803-4ce6-45ed-b0f8-62a16a48ba85), [Vercel avatar card](https://mobbin.com/screens/27420f1c-ed8e-483f-9336-5722b4850453))

## Flow
1. Entry: click the avatar itself (Vercel: "Click on the avatar to upload a custom one from your files") or an Upload Photo button (Slack).
2. After file pick, a crop modal opens: circular mask preview over the square image + zoom slider + primary "Crop Picture" button (Linear).
3. Slack offers "Remove Photo" alongside Upload — explicit revert to default avatar.
4. Result renders immediately in the settings page preview.

## Use when
- Any user-uploaded avatar — arbitrary aspect ratios make a crop step necessary; circular mask preview matches how the avatar renders in-product.

## Avoid when
- Don't ship upload without remove (users need to revert to initials/default); skip the crop UI only if avatars are sourced exclusively from OAuth providers.

## Sad paths observed
- Vercel sets expectation in the card footer: "An avatar is optional but strongly recommended." — optionality is explicit.
- Remove path observed (Slack) — deletion is a first-class action, not buried.

## Accessibility
- Zoom slider must be keyboard-operable (arrow keys); Linear's modal is single-purpose with one primary action — simple focus order.

## Default verdict for our stack
RECOMMENDED — standard expectation at the Linear bar; pair a click-to-upload avatar target with a crop/zoom dialog and an explicit remove action.
