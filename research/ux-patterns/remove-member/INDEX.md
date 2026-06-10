# remove-member — pattern index

**Coverage note.** Queries run — by-app: "Slack remove member from workspace confirmation dialog"; by-pattern: "remove teammate from team confirmation modal what happens to their data", "last member leave workspace will be deleted owner cannot leave" (returned additional remove-member screens); by-flow: "remove a member from team settings". Apps swept: Slack, Canva, Runway, Amplitude, Deputy, Krea AI, Whop, Clay, Visitors, Notion, Cohere, Mural, Assembly, Charma, Current, Churnkey, Lyssna. NOT found: type-to-confirm for member removal (no web example surfaced — type-to-confirm appears only on org/team deletion and ownership transfer); bulk-remove confirmation UX beyond Amplitude's "Remove 1 team member?" counter. Deputy's "Delete team member" (hard data deletion with acceptance button) was excluded as an HR-records pattern, not org membership.

- ★ `confirm-with-consequence-line.md` — small AlertDialog naming the person + one truthful data-fate sentence + red Remove (Slack, Whop, Clay, Notion, Assembly, Current, Charma, Churnkey, Krea)
- `consequences-bullet-list.md` — enumerated fates per data class when content splits shared/private (Runway, Cohere)
- `content-transfer-on-remove.md` — transfer leaver's content inline checkbox / separate flow / auto-transfer (Amplitude, Canva, Mural)
- `reauth-before-remove.md` — password re-entry gate before removal executes (Lyssna)
- `removal-reason-survey.md` — vendor churn survey interjected before removal (Notion)
