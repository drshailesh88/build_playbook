# Pattern: Blocking OTP code-entry gate after signup
**Surface:** email-verification · **Observed in:** ClickUp, Cycle, Contra, Databricks, Frame.io, Canva, Krea AI (refs: [ClickUp](https://mobbin.com/screens/c4844fa1-05ef-49b2-ad1c-767cd675165d), [Cycle](https://mobbin.com/screens/4e4fa9f4-a36c-4d1d-97f9-7b9d093da000), [Contra](https://mobbin.com/screens/a6d6d07e-1cbb-4fa7-8dd8-24862fe0ffa8), [Databricks](https://mobbin.com/screens/d2bf25c5-982d-4a90-ac7e-1397d6e833d6), [Frame.io](https://mobbin.com/screens/537ca3c6-d5dd-4945-a785-0449998c2e40), [Canva](https://mobbin.com/screens/144d9924-b5ea-40f9-92ae-66d45621fe05), [Krea AI](https://mobbin.com/screens/ff199aab-ba4d-4d44-afac-02168570115c))

## Flow
1. Immediately after signup, a full-screen (or modal — Canva) gate: "We just emailed you. Please enter the code we emailed you" (ClickUp), "Confirm your email — We've sent an email with a code to <email>" (Cycle).
2. The submitted email is always displayed; Contra and Krea add an edit/change affordance next to it.
3. Code input: segmented boxes (ClickUp 4, Cycle 5, Databricks/Frame.io 6 with hyphen grouping) or single field (Krea "6-digit code").
4. Resend with cooldown: "Resend code in 29" (Databricks), "Didn't get the code? Resend in 29 seconds" (Canva), "You can resend the code in 0:54" (Frame.io); plain "Send new code" (Cycle).
5. Escape hatches: "Logout" (ClickUp), "Back" (Cycle), "Go to Gmail" deep link (Frame.io).
6. Verify → user lands in the product, fully verified.

## Use when
- You want verification completed in-place with no tab switching or cross-device link problems; code typing works even when email is read on a phone.
- Signup is the only entry point being gated (the code screen IS the rest of signup).

## Avoid when
- Users arrive via invitation links where the email is already trusted — gating an invited user on OTP doubles their work.
- You can't enforce code expiry + attempt limits server-side (see Binance sad path in rate-limit surface).

## Sad paths observed
- Height: "Oops. The email code is invalid" + Chat with support ([ref](https://mobbin.com/screens/ed9241ab-c1fc-4bbf-b600-c9e0f7c20082)).
- Contra mounts Cloudflare Turnstile inside the gate — bot check before code verification ([ref](https://mobbin.com/screens/17d54d42-ffdb-4631-b7df-7af9e042c435)).
- Amazon: resend throttle "Please wait 53 seconds before requesting another code" + "try a different way" ([ref](https://mobbin.com/screens/a392358c-1227-4197-a16c-e4daf603e958)).

## Accessibility
- Segmented inputs need paste support and `inputmode="numeric"`; Linear's single-field variant is the screen-reader-safest. Frame.io's "Go to Gmail" reduces motor load.

## Default verdict for our stack
RECOMMENDED — Better Auth `emailOTP` plugin maps directly; in-place code entry beats link-clicking for a desktop-web B2B tool and matches the ClickUp/Canva convention.
