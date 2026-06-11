# Pattern: Publish-gate diff + named-version restore (adjacency — not calendar-native)

**Surface:** sessions-program / coordinator-scheduling · **Observed in:** ElevenLabs, Linear (refs: [ElevenLabs review changes](https://mobbin.com/screens/ff16450b-9de9-4c60-8738-770be8df0a5c), [Linear version history](https://mobbin.com/screens/6c14e085-9ff5-4e61-9a21-b04f1b0a3433))

## Flow
1. Publishing opens "Review Changes": two columns — "Published version" vs "Current changes" — with red/green diff highlighting and collapsers ("Expand 77 lines…").
2. An optional "Version description — Describe what changed in this version" field names the version before Publish.
3. Version history: right-rail list (author + timestamp, "Latest"), "Highlight changes" toggle, a "1 of 3" change stepper, and "Restore version".

## Use when
A versioned-publish model (exactly this module's program_versions) — the coordinator reviews WHAT changed before notifying anyone, and can restore a prior version.

## Avoid when
Treating this as a solved pattern for schedules — NO calendar-native agenda diff was found anywhere (first-principles candidate); these are generic-document diffs to adapt, with sessions as the diff unit (added / removed / moved / assignment-changed), not lines.

## Sad paths observed
- None captured; the restore affordance is itself the recovery path for a bad publish.

## Accessibility
Diffs pair color with strikethrough/highlight + the change stepper (navigable change-by-change).

## Microcopy worth stealing
"Version description — Describe what changed in this version" · "Highlight changes" · "Restore version"

## Default verdict for our stack
RECOMMENDED (adapted) — the module already computes added/removed at publish and stubs moved/assignment buckets; the missing UX is exactly this: a pre-publish "Review changes since v{n}" listing per-session diffs + optional version description, with version history + restore as the V2 extension.
