# Pattern: Expiration dates with multi-party reminder routing + expiring-soon views

**Surface:** certificates / lifecycle · **Observed in:** 7shifts, PandaDoc, Vanta, LinkedIn, Craft, Apple Wallet (refs: https://mobbin.com/flows/7d1cba3c-5ea4-4613-9074-d15d6d4e9bf0, https://mobbin.com/screens/2164216f-e201-4d25-8704-f8e2678c151a, https://mobbin.com/screens/eb1d71b4-2b3c-4a83-8435-bdc0e7cbb9e2, https://mobbin.com/flows/d97a84bf-7296-41d6-847b-34a7b5c016b2, https://mobbin.com/flows/4d59c23f-2a33-4461-9d15-fdd6280a7362)

## Flow
1. Expiry set at upload/issue with reminder lead-time: "Expiration Date (Optional)" + Reminder dropdown ("30 days") (7shifts).
2. Reminder ROUTING stated: "Expiration reminders will be sent to you, the employee, and the account Admin." (7shifts) — multi-party, not just the owner.
3. List-level signals: smart views "Expiring soon" / "Upcoming renewals" (PandaDoc); "Overdue / Due soon" badges with counts (Vanta).
4. The no-expiry case is EXPLICIT, not blank: "This credential does not expire" checkbox (LinkedIn); "Never expires" button (Craft); "Does not expire." sentence on the certificate page (Uxcel).
5. Expired items move to a bucket, not the trash (Apple Wallet "Expired (9 Passes)").

## Use when
Time-bound credentials — CME certificates with validity periods, recurring annual certifications.

## Avoid when
Conference attendance certificates that never expire — then the win is only the explicit "Does not expire." statement; don't build reminder machinery for it.

## Sad paths observed
- Expiry without reminder = silent lapse; every observed system pairs the date with a notification commitment.

## Accessibility
Time-risk badges carry text ("Due soon"), not color alone.

## Default verdict for our stack
VIABLE (V2, CME-triggered) — never attempted in legacy; the LinkedIn schema already expects expiry, so the DATA field is V1 (template-level validity, Deel-style "∞ Unlimited" default), while reminder machinery waits for a real recurring-credential need.
