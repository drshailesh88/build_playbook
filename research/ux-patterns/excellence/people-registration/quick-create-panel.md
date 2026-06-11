# Pattern: Quick-create panel with contact-rule gating and create-and-add-another

**Surface:** people-registration / add person · **Observed in:** Front, Pipedrive, HubSpot (refs: https://mobbin.com/flows/707ab494-e532-423f-b5bf-6e13bade31c7 , https://mobbin.com/flows/522ec9f2-8047-47a9-8c9b-2c32d13431da , https://mobbin.com/flows/1f3ac445-7779-4d76-92a0-a494cea4d38c)

## Flow
1. Create opens as a right side panel / modal over the list — the table stays visible; the new row appears in place on save (Pipedrive count ticks 2→3).
2. Field anatomy: name + avatar slot; contact block labeled "Contact Information * (at least one required)" with email/phone rows (Front — identical rule to GEM's email-or-phone); multi-value contact fields with "+ Add phone" / "+ Add email" and type selects (Work ▾) (Pipedrive); labels/tags as colored multi-select with inline "+ Add label" (Pipedrive); long tail behind "Show more" (Front).
3. Create button disabled until the rule is satisfied; HubSpot adds **"Create and add another"** for batch entry and a success banner "A new contact was created. Go to record ↗".
4. HubSpot's "Edit this form ↗" lets admins tune which fields appear in quick-create.

## Use when
Front-desk-speed entry matters (walk-in registrations, last-minute faculty) and most creates happen mid-task from the list.

## Avoid when
Records require heavyweight mandatory data at birth — then a full-page form with sections beats a panel. Don't put every schema field in quick-create; it exists to be short.

## Sad paths observed
- Validation is structural (button gating + required markers) before submit, not error-toast-after.
- Duplicate handling on create is named explicitly elsewhere (AutoSend: "Your duplicate contacts will override"; GEM's "Person already exists: {name}" message is the same family).

## Accessibility
Panel traps focus; first field auto-focused; required rule announced via described-by on the contact group.

## Default verdict for our stack
RECOMMENDED — the existing add-person modal is close; deltas worth stealing: salutation parity with the edit form (done-spec §9), "Create and add another", and the duplicate-warning row linking to the existing person.
