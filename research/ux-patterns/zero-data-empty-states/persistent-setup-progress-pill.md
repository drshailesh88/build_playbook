# Pattern: Persistent setup-progress pill in chrome
**Surface:** zero-data-empty-states · **Observed in:** Attio, Chatbase, Deputy, Apollo, Assembly (refs: https://mobbin.com/screens/5696d7c4-64a0-47be-9876-3736c6058e36, https://mobbin.com/screens/2fd8ab88-e291-4560-b719-dcaf89d5152a, https://mobbin.com/screens/700344e8-09d2-4025-a00e-1d0a8012510a, https://mobbin.com/screens/4b404d34-01c8-44a0-9e59-2e709a9c4ae1, https://mobbin.com/screens/68a76963-ddce-4cfa-b498-6bf89dc71aca)

## Flow
1. A compact progress indicator lives in persistent chrome — sidebar footer or floating corner pill — independent of which module the user is in: Attio "Help and first steps · 2/6", Chatbase "Getting started · 4/6 completed" with segment bar, Deputy floating "6/7 Setup tasks" pill bottom-right, Apollo "Onboarding hub · 8% Completed" sidebar entry, Assembly "60% Completed · Getting Started" sidebar block.
2. Clicking opens the full checklist (panel or hub page) from anywhere.
3. The counter updates as setup actions complete in any module; pill survives navigation so empty modules everywhere have a recovery path.
4. Pill disappears (or is dismissible) after completion.

## Use when
- Setup steps span multiple modules, so the user will wander away from the dashboard checklist.
- You want every per-module empty state to have a global "resume setup" escape hatch without duplicating guidance.
- Paired with the embedded dashboard checklist (Apollo and Attio run both simultaneously).

## Avoid when
- Chrome is already dense (trial banner + upgrade CTA + invite button); Attio's sidebar footer stacks "Upgrade Attio / Invite teammates / Help and first steps" — three competing persistent CTAs.
- Progress can stall on steps the current user lacks permission for (admin-only steps shown to members).

## Sad paths observed
- Deputy's pill coexists with a trial countdown banner and a webinar prompt on the same screen — zero-data screens accumulate growth chrome.
- Assembly shows "60% Completed" while the analytics module is still fully unusable (no accounts connected) — percent can overstate real activation.

## Accessibility
- Pills are small-text, low-contrast in several apps (Attio's gray "2/6"); the fraction must be readable, not just the progress ring color.
- Floating corner pills (Deputy) can overlap content and chat launchers at small viewports — observed sitting next to a help "?" bubble.

## Default verdict for our stack
VIABLE — good companion to the dashboard checklist for multi-module setup, but secondary; only adopt if the Event State sidebar footer isn't already carrying trial/upgrade chrome.
