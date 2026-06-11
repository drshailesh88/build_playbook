# Pattern: Temporal segmentation — Live Now / Upcoming / Replay as the top-level switch

**Surface:** sessions-program / attendee-program · **Observed in:** ESPN, Unity, Peanut, Peacock, DICE (refs: [ESPN segments](https://mobbin.com/screens/1b763dfd-ff20-4011-a97c-8cdcc9f26413), [Unity tabs](https://mobbin.com/screens/0d59fbdc-b2d3-4530-bced-188f1d5a4881), [Peanut tabs](https://mobbin.com/screens/1c6b86fc-8b0d-4599-a575-f74f1a791150), [Peacock Replay badges](https://mobbin.com/screens/f015d9ed-304e-4a96-91c2-879af3cb3f4c), [DICE This-week shelf](https://mobbin.com/screens/3e633d5d-94b6-41ff-a7c3-b78ebe88fa64))

## Flow
1. Top-level segmented control by time-relation, not category: "Live Now / Upcoming / Replay" (ESPN), "LIVE NOW ● / UPCOMING" (Peanut), "Open for registration / Previously recorded" (Unity).
2. Faceted filters live BELOW the temporal switch — time-relation is the primary axis.
3. Past items aren't hidden: "Replay" corner badges (Peacock), "Previously recorded" tab (Unity).
4. DICE variant for casual browsing: time-scoped shelves instead of controls — "This week — Happening in the next 7 days.", "New Shows Thursday — Just announced."

## Use when
The program spans live, future, and past content with different available actions per state (join vs remind vs watch-recording).

## Avoid when
A single-weekend conference with no recordings — day strip alone is the temporal axis; segments add an empty Replay tab.

## Sad paths observed
- ESPN's empty filtered segment names all three exits: "There are currently no upcoming events for this selection. Please check live now or replay or clear all filters."

## Accessibility
Segments are labeled text; live state carries a red dot PLUS the word "LIVE".

## Microcopy worth stealing
"Open for registration" / "Previously recorded" · "Happening in the next 7 days."

## Default verdict for our stack
VIABLE — relevant the moment session recordings or live-streams exist; for the physical-first medical conference, the day strip remains primary and "happening now" is an indicator (see live-now-indicators card), not a tab.
