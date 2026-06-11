# Pattern: Template detail with lifecycle metadata + issued-instance separation

**Surface:** certificates / template-management · **Observed in:** Deel, Teachable (refs: https://mobbin.com/flows/e75e5b29-6ae8-4424-ab8f-8c525fdde012, https://mobbin.com/screens/a0d68988-e0a5-4b6a-9b9f-2f4c9249347c, https://mobbin.com/flows/21f569ff-7862-482d-85e8-3f33d1d25c22)

## Flow
1. Template detail page: large preview + metadata row — Status badge (Draft), Created by, Last edited on, **Validity ("∞ Unlimited")**, **Issuing Authority**, **Endorsed by** (Deel).
2. Tabs separate the template from its instances: "Awarded certificates (0)" / "Resources (0)" (Deel).
3. List view states the activation rule in plain words: "You can only have one active certificate at a time. The active certificate will be issued automatically when a student completes a course." (Teachable)
4. Per-template usage stat on the card: "Issued 0 times" + "Last time updated Jan 7 2025" (Teachable).

## Use when
Templates and issued certificates are different objects with different lifecycles — i.e., always, for credential systems.

## Avoid when
Never for this module; only collapse template/instance if certificates are pure one-off downloads with no registry.

## Sad paths observed
None in-flow; the pattern itself is the guard — the visible one-active rule prevents the "which template will fire?" surprise.

## Accessibility
Status communicated as labeled badge + sentence, not color alone.

## Default verdict for our stack
RECOMMENDED — legacy already has draft→active→archived + one-active-per-type (census #4/#8/#9); steal the SURFACING: rule stated as a sentence on the list, "Issued N times" per template, validity + issuing-authority metadata fields (new for CME credibility).
