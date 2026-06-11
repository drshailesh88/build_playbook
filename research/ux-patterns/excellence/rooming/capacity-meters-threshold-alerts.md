# Pattern: Capacity meters with threshold alerts (consumed-vs-contracted)
**Surface:** rooming · **Observed in:** QuickBooks, OpenAI Platform, ElevenLabs, Rox, Deel, Luma
(refs: https://mobbin.com/screens/4dfea91b-6902-4da1-8625-7306df994417 , https://mobbin.com/screens/6f5add46-0508-4eb1-a5de-48011b40fc62 , https://mobbin.com/screens/d05a2f5e-1bfb-421f-8723-dd288e3c92dd ; raw: `_raw/by-pattern.md` §P7, §P14, §P37)

## Flow
1. Per-resource meter rows: "Chart of accounts — 2 OF 250" with a thin bar and caption "The limit for your plan is 250." (QuickBooks).
2. Configurable alerts: "Alert when budget usage exceeds [50] %" + "Also send alerts to — Add email addresses…" (OpenAI); threshold rows with unit dropdown (By credits / amount / percentage) + toggle (ElevenLabs).
3. Over-limit shown as >100% truth, not clamped: "1,535 / 1,000 Actions Used" with a red-full bar + blocking banner "You have no Agent Actions remaining. To continue…, upgrade here." (Rox).
4. Filled-vs-vacant donut: "Total 19 — Filled positions 10 / Vacant positions 9" (Deel).
5. Event capacity glance: progress bar "0 guests — cap 1,000" with status legend (Luma).

## Use when
Any contracted quantity is being consumed: block pickup per hotel/room type, beds in a shared room, import row caps.

## Avoid when
The quantity has no ceiling — a bare count is honest; a meter against a fake max is theater.

## Sad paths observed
- Hard stop with single recovery CTA (Workable "You've reached your search limit. Add more credits…").
- Unmet-precondition stated with exact numbers (Zoho "…must have minimum 5000 records…").
- Over-consumption rendered as data (red, >100%), not an error dialog.

## Accessibility
Always "N of M" as text beside the bar; alert thresholds announced in plain sentences.

## Default verdict for our stack
RECOMMENDED — per-hotel/per-room-type rows "Assigned 38 OF 50 contracted" with 80%/100% email alerts to ops mirrors OpenAI/ElevenLabs exactly; pairs with `block-inventory-grid.md`.
