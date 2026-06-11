# Pattern: Share & snapshot (chart image, PDF, scoped links)

**Surface:** dashboard-reports / sharing · **Observed in:** Steep, Maze, Mixpanel, June, Apollo (refs: https://mobbin.com/screens/e40b8a6f-578e-4310-b71f-ef6356ca0c70, https://mobbin.com/screens/6771923c-14cd-45dd-b27c-17f39428e309, https://mobbin.com/screens/076c828b-296f-4388-b7c0-998cd8a9a0b0, https://mobbin.com/screens/0b923cb3-a6fb-4343-bc59-61b1896f6a6b, https://mobbin.com/screens/752592f1-d53f-4fa1-91d3-5556807bbc37, https://mobbin.com/screens/3c63ed63-f9a9-4e5c-be78-ce3469a6e1fb)

## Flow
1. Steep "Share image": any chart renders to a branded PNG card (title, date, value, chart) with Download / Copy — built for pasting into WhatsApp/Slack/slides, the actual medium where conference committees live.
2. Maze "Share report" modal: Share / Embed / **Download PDF** tabs; the PDF tab warns "you are limiting your audience's access to interactive content" — PDF as a deliberate, explained downgrade.
3. Access-scoped links: Apollo visibility dropdown (Restricted → people picker with Can view); Mixpanel adds an explicit "Make Board Public" toggle + Copy URL; June "Share to web — anyone with the link can view this report."
4. Sad path observed live: Maze toast "Download failed. Please try again." — generation failures get a retry, not silence.

## Use when
Reports leave the app — committee decks, sponsor updates, WhatsApp ops groups. A chart that can't be pasted somewhere gets screenshotted badly anyway; owning the snapshot keeps it branded and dated.

## Avoid when
The content carries attendee PII — public links and auto-attached files for PII reports are a breach pipeline; restrict share-to-web to aggregate charts only (the old app's Ops-PII scars triple-underline this).

## Sad paths observed
- PDF generation failure → retry toast (Maze).
- Public-link revocation must kill existing links (verify-in-code; not observable on Mobbin).

## Accessibility
Snapshot images need the headline value in text form alongside (alt text with metric + value + period).

## Default verdict for our stack
VIABLE — chart→PNG snapshot is small and high-charm; PDF report covers the old PRD's never-attempted Excel/PDF promise (done-spec §3.37); public links are V2 and PII-gated.
