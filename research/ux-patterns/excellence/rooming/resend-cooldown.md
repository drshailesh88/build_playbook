# Pattern: Resend with visible cooldown (disabled control + countdown + last-sent context + channel fallback)
**Surface:** rooming · **Observed in:** Databricks, Coinbase, Wave, Bonsai, Nextdoor, OpenPhone, Uvodo
(refs: https://mobbin.com/screens/d2bf25c5-982d-4a90-ac7e-1397d6e833d6 , https://mobbin.com/screens/b1efdd50-e43f-4ab8-a95c-4156fc01c717 , https://mobbin.com/screens/cfdf8235-6a71-4857-ac58-5dace902f6d3 , https://mobbin.com/screens/5c7c3e25-76b5-4c4b-b18f-31cf578a34fc ; raw: `_raw/by-pattern.md` §P18, plus per-guest delivery ledger §P37 and "Successfully resent invite email." §A17)

## Flow
1. The resend control stays VISIBLE but disabled, with the countdown inside it: "Resend code in 29" (Databricks); separated label variant "Resend in 00:44" beside a disabled button (Profound).
2. Worry pre-empted in words: "Don't see it? Send a new code in 00:15" (Wave); destination + validity stated: "We sent a code to your email (j…@gmail.com)… valid for 10 minutes." (Bonsai).
3. Channel fallback offered: "Try another method" / "Try another way" + "Edit your number" (Nextdoor/Coinbase).
4. On success: explicit toast ("Successfully resent invite email." — Navan §A17) and the send recorded in the per-person delivery ledger (Luma §P37).

## Use when
Resending delegate confirmations or rooming lists to hotels — anywhere a stuck double-click could spam a recipient.

## Avoid when
Cooldown theatre on actions with no spam risk.

## Sad paths observed
The pattern IS the sad path (message didn't arrive): control never hidden, reopening time exact, alternate channel offered.

## Accessibility
Countdown lives in the button's accessible label so state changes are announced.

## Default verdict for our stack
RECOMMENDED — the old app's resend dialog shows "Last sent X ago" but enforces nothing server-side (a known NEVER-ATTEMPTED). The complete steal: server-enforced cooldown + "Resend — available again in 0:59" + "Last sent Oct 3, 4:12 PM to reservations@hilton.com" + channel fallback (email → WhatsApp).
