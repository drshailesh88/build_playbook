# Pattern: Deliberate issuance — preview the generated artifact before commit

**Surface:** certificates / issuance · **Observed in:** Cake Equity, Deel, Wix, Squarespace, Uber, Docusign (refs: https://mobbin.com/flows/3017c449-6337-48b0-849e-a99b30e8bdda, https://mobbin.com/flows/9ca0fc19-6356-44ef-b2cb-d55c68213c9a, https://mobbin.com/flows/406936be-9cd8-4c55-adc1-a2dbfc1edf00, https://mobbin.com/screens/f24411d3-7582-42ae-aa4e-ec5048e21564)

## Flow
1. Issue form names the consequential fields: Certificate number (ⓘ), Issue date, checkbox "**Notify shareholders of new certificate**" (Cake Equity) — notification is a CHOICE at issue time, not an automatic side effect.
2. Generated preview before commit: "We are generating a certificate preview, so you can double check everything before sending the certificate to your stakeholder. Please be patient, this may take a while." → rendered artifact → [Issue certificate] (Cake Equity).
3. Bulk variant — final review checkpoint summarizing who/what/from: Subject (Edit), Sender details, "Estimated recipients count: 2" (Edit), preview thumbnail, then Send (Wix "Campaign Overview"); validity window with timezone for the batch ("Vouchers can't be used after the expiration date." — Uber) and live summary rail (count × value → total).
4. Customizable email envelope at send: recipient rows + "Add message" Subject/Message (Docusign).
5. Staged completion feedback: "Issuing certificate" → "Share certificates have been issued. You can access the certificate in the documents section…" → "Share certificate issuing complete!" (Cake Equity toasts).

## Use when
Issuance is consequential and semi-rare (conference certificates: one batch per event) — a 10-second preview beats a 200-recipient mistake.

## Avoid when
High-frequency low-stakes issuance (auto-issue on completion, Teachable-style) — there the active template IS the standing approval; don't interrupt automation with previews.

## Sad paths observed
- Preview latency is named honestly ("Please be patient, this may take a while") instead of a frozen button.

## Accessibility
Preview is a rendered image of the PDF — must carry alt text naming recipient + type; stacked toasts need an aria-live region.

## Default verdict for our stack
RECOMMENDED — legacy issues blind (census #16, #27). Insert one preview step in single issuance and a review checkpoint (recipients count + template + notify channels) before bulk generation.
