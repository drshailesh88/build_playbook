# Pattern: Three-state RSVP with lightweight identity (re-editable)

**Surface:** sessions-program / speaker-lifecycle · **Observed in:** Partiful, Apple Invites, GroupMe, LINE, KakaoTalk (refs: [Partiful RSVP flow](https://mobbin.com/flows/746c6688-1714-4ca0-8e30-01311aaf2ec5), [Apple Invites](https://mobbin.com/screens/5a5a0fdb-b99a-4352-bd57-80680ca6862d), [GroupMe](https://mobbin.com/screens/b699aec3-92c9-4579-af4e-820156a72176), [LINE](https://mobbin.com/screens/15c13dba-b760-4068-acd1-f96be30dda12), [KakaoTalk](https://mobbin.com/screens/3342ee2a-1e0f-4ce1-acfc-3f3e2319436a))

## Flow
1. Three equal-weight response pills: "I'm Going / Maybe / Can't Go" (Partiful emoji+label; Apple Invites "Going / Not Going / Maybe").
2. Identity captured minimally at response time: name + phone with trust copy "Just for event updates. No spam."; party size; optional comment (LINE pairs response + free-text message in one gesture).
3. Host-set conditions can gate confirmation: rules card + single "ACCEPT & CONTINUE" (Partiful).
4. KakaoTalk keeps the choice re-editable after responding — changed-mind is just tapping another pill; GroupMe shows Pending as a first-class visible bucket ("Going (1) / Not Going (0) / Pending (1)").

## Use when
Capturing the negative and uncertain signals matters as much as yes — and respondents may legitimately change their minds.

## Avoid when
The coordinator needs a binary commitment to print a program — "Maybe" from a session chair is operationally useless; faculty confirms should be accept/decline only.

## Sad paths observed
- Capacity decrements visibly ("8/10 spots left").
- Pre-confirm conditions gate blocks confirmation until accepted.

## Accessibility
Emoji always paired with text labels; response controls in a bottom thumb row on mobile; tabs show counts.

## Microcopy worth stealing
"I'm Going / Maybe / Can't Go" · "Just for event updates. No spam." · "ACCEPT & CONTINUE"

## Default verdict for our stack
VIABLE (selectively) — keep faculty accept/decline binary, but steal: re-editable response before a lock date, pending-as-visible-bucket, and the conditions gate (e.g. "I agree to the AV/recording policy" before confirm).
