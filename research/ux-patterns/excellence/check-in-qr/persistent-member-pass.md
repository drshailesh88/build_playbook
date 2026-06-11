# Pattern: Persistent member pass — one durable identity QR across events

**Surface:** check-in-qr / attendee credential · **Observed in:** Nike Run Club, Shangri-La Circle (refs: https://mobbin.com/flows/4f299f86-1d73-42ba-9e06-cced3b97aaa5, https://mobbin.com/flows/ec56ffda-1174-4b44-849d-7ec42ac5afc6)

## Flow
1. A "Pass" tile in the member's profile opens a full-screen card: name, "Member Since …", giant QR.
2. Purpose copy: "Check in easily and get personalized service at Nike stores and events." — one code, many venues/events.
3. Wallet-addable like any credential.

## Use when
Recurring-audience platforms — the same delegates attend the org's annual conference, workshops, and chapter meetings; scanning the PERSON (then resolving their registration server-side) beats issuing a new code per event.

## Avoid when
Per-event tokens are load-bearing for security or transfer semantics (resalable tickets, one-time guest passes) — identity-level codes can't be revoked per-event without revoking the person.

## Sad paths observed
- None shown; the implied one (pass presented for an event the member ISN'T registered for) must resolve to the standard ineligible outcome, never a crash.

## Default verdict for our stack
VIABLE (V2 candidate) — EventState is multi-tenant with recurring medical societies; a delegate-level pass per org maps cleanly onto the people/person model, but the legacy QR contract is per-registration (census: token on registration), so this is a deliberate architecture choice, not a UI tweak.
