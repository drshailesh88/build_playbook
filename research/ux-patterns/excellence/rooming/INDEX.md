# Rooming / Accommodation Ops — Excellence Pattern Library INDEX
**Harvested:** 2026-06-11 · EXCELLENCE mode (ceiling, not fidelity) · Mobbin MCP (search_flows + search_screens)

## Coverage note (read first)
- **Modes swept:** by-app (A1–A22), by-flow (F1–F40), by-pattern (P1–P37) — raw notes with every Mobbin URL in `_raw/`. ~70 queries total across web+iOS, each mode run to loop-until-dry (2 consecutive nothing-new queries), with two caveats:
  - The by-app agent crashed after A22, before its final 2 dryness probes — reconstructed coverage note in `_raw/by-app.md`; residual tail risk low but nonzero.
  - The by-pattern session-1 query strings were lost to a crash; they are inferred from recorded patterns and marked as such in `_raw/by-pattern.md`.
- **Rooming itself is thin on Mobbin** — this library is adjacent-logistics harvest by design: consumer hotel booking, trip management, corporate book-for-others (Navan/TravelPerk — closest whole-job analogs), seat-map assignment, shift scheduling, e-sign tracking, CSV ops, hotel-extranet inventory.
- **Absent from Mobbin entirely:** TripIt (proxied via Tripsy/Wanderlog/Pangea), Hilton Honors (proxied via IHG/Marriott/Hyatt), every dedicated PMS/roommate-matching tool. Nine pattern domains have NO precedent → `first-principles-gaps.md`.
- **Not swept:** non-Mobbin sources (live PMS products, vendor docs), per DEC-032 harvest scope.

## Cards (★ = harvester's RECOMMENDED default — candidate, NOT a decision)

### Inventory & blocks
| Card | One-liner | Verdict |
|---|---|---|
| `block-inventory-grid.md` | Per-night × room-type ledger (contracted/assigned/remaining) with weekday-scoped bulk edit | ★ RECOMMENDED |
| `capacity-meters-threshold-alerts.md` | "Assigned 38 OF 50" meters + configurable 80%/100% alerts | ★ RECOMMENDED |
| `block-cutoff-deadline-timeline.md` | Vrbo/Airbnb deadline-tier timeline applied to cutoff/attrition (FP application) | ★ RECOMMENDED |
| `block-sourcing-rfp.md` | RFP → hotel bids → award/stop + shareable attendee page | VIABLE (post-V1 flavor) |
| `scarcity-occupancy-guards.md` | "Only 3 Twins left", capacity guards, displacement warnings | ★ RECOMMENDED |
| `waitlist-on-capacity.md` | Notify-me-on-release converting cancellations into placements | VIABLE |
| `no-availability-recovery.md` | Block-full states that name the cause and offer the next action | ★ RECOMMENDED |

### Assignment
| Card | One-liner | Verdict |
|---|---|---|
| `assignment-grid-draft-publish.md` | People-allocation grid, draft→publish, exception legend | ★ RECOMMENDED (donor for FP gap #1) |
| `unit-picker-person-to-slot.md` | Seat-map grammar: person→slot, turn-taking, "all N have a bed" | ★ RECOMMENDED |
| `conflict-triage-autofix.md` | Conflict chips, fixable-vs-unfixable triage, publish gate | ★ RECOMMENDED |
| `date-range-consequence-picker.md` | "Assign · 3 nights" CTAs, per-night availability in cells | ★ RECOMMENDED |
| `split-and-shared-stays.md` | Split-stay timeline rendering + sharing disclosure language | VIABLE |
| `duplicate-merge.md` | Merge duplicate delegates with booking-consequence statement | VIABLE |

### Changes & cancellations
| Card | One-liner | Verdict |
|---|---|---|
| `change-diff-confirmation.md` | Old→new diff gate, describe-then-publish; the note becomes the notification | ★ RECOMMENDED |
| `change-request-async-confirm.md` | Modify hub + request-needs-confirmation + TravelPerk change tiers | ★ RECOMMENDED |
| `approval-queue-inbox.md` | Ops inbox: inline approve/reject, reason on reject, bulk, both directions | ★ RECOMMENDED |
| `cancellation-consequence-preview.md` | Reason taxonomy + consequence preview + retained record | ★ RECOMMENDED |

### Delegates
| Card | One-liner | Verdict |
|---|---|---|
| `delegate-person-record.md` | No-login person, routed notifications, ID-exact names, profile-vs-stay prefs | ★ RECOMMENDED |
| `arranger-mode.md` | "Acting for Dr. Chen — Exit mode" + dual-ID display | ★ RECOMMENDED |
| `structured-special-requests.md` | Structured prefs (accessibility first-class) + tiered non-guarantee | ★ RECOMMENDED |
| `delegate-response-capture.md` | Tokened Confirm/Request-change/Decline + declared side-effects + email ledger | ★ RECOMMENDED |
| `delegate-voucher.md` | Front-desk voucher: dual IDs, localized, PDF/wallet, visa letter | ★ RECOMMENDED |
| `booked-progress-roster.md` | "Roomed 38/120 · Who's missing?" roster with reminders/revoke | ★ RECOMMENDED |

### Ops surfaces & pipelines
| Card | One-liner | Verdict |
|---|---|---|
| `ops-table-status-views.md` | Status tabs w/ counts, filters, saved views, bulk bar, taught empty states | ★ RECOMMENDED |
| `ops-home-dashboard.md` | Arrivals/Departures/Stay-overs + exception KPIs + setup checklist | ★ RECOMMENDED |
| `reservation-record-anatomy.md` | Canonical record page: status under title, copyable refs, actions | ★ RECOMMENDED |
| `import-mapping-receipt.md` | Mapping w/ typed badges, dup policy, Added/Updated/Skipped/Errors receipt | ★ RECOMMENDED |
| `export-builder-async.md` | Column chooser, scope honesty, async + past-exports ledger | ★ RECOMMENDED |
| `hotel-handoff-tracking.md` | Two-tier share + sent→viewed→acknowledged per hotel | ★ RECOMMENDED (donor for FP gap #3) |
| `notification-tiers-and-composer.md` | Flighty tiers + delta-sentence feed + computed-audience composer | ★ RECOMMENDED |
| `audit-undo-trash.md` | from→to audit w/ Automated actor + undo toast + trash/restore | ★ RECOMMENDED |
| `resend-cooldown.md` | Server-enforced cooldown + last-sent context + channel fallback | ★ RECOMMENDED |

### Gaps
| File | Contents |
|---|---|
| `first-principles-gaps.md` | 9 confirmed no-precedent domains with donor-card assembly kits — each needs an explicit founder DEC |

## Process notes
- Per DEC-032: choices are DECs made by the founder; these cards are evidence. Pathways cite DEC + card, never "something like Navan".
- Raw harvest preserved in `_raw/` (by-app.md, by-flow.md, by-pattern.md) — every claim traces to a Mobbin URL.
