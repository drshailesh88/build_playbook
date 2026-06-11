# Pattern: Empty results name the exact controls to change

**Surface:** sessions-program / attendee-program · **Observed in:** Apple Store, ESPN, Klook, Turo, Swarm, Google Maps (refs: [Apple empty day](https://mobbin.com/screens/66bc8e13-08ed-40f2-a6e2-e92b3cd47dea), [ESPN empty segment](https://mobbin.com/screens/086a98b1-833b-45a1-8dc0-5b7d099fda1f), [Klook](https://mobbin.com/screens/417304ca-b877-42a3-b628-1e871434c7f9), [Turo](https://mobbin.com/screens/be0bd0df-8337-4721-bbfc-d099c25935aa), [Swarm](https://mobbin.com/screens/da0fab26-7010-45c6-b271-5aacdc917b23))

## Flow
1. The empty state NEVER removes the controls — day strip, filter chips, and search stay on screen so recovery is in reach (Apple keeps "Filter(9)" visible, telling the user WHY it's empty).
2. The copy names the specific controls to change: "Try changing your filters, adjusting your dates, or exploring the map" (Turo); "Please check live now or replay or clear all filters." (ESPN — three exits).
3. Apologetic + forward: "Sorry, we couldn't find sessions matching your selection. But there's more to discover here." (Apple).

## Use when
Every filtered/searched program view — filtered-to-zero is the most common "the app is broken" misread.

## Avoid when
Generic copy ("No results found." alone) — observed everywhere to be paired with a recovery verb; a bare statement is the anti-pattern.

## Sad paths observed
This card IS the sad path: zero-result day, zero-result filter combination, zero-result segment.

## Accessibility
Empty-state copy is body text in the content area; controls retain their positions (no layout jump).

## Microcopy worth stealing
"Sorry, we couldn't find sessions matching your selection. But there's more to discover here." · "Try changing your filters, adjusting your dates, or exploring the map."

## Default verdict for our stack
RECOMMENDED — the old app has correct distinct empty states ("No sessions for this day") but none name the recovery control; verb-specific recovery copy is a cheap uplift across admin list, attendee program, and public page.
