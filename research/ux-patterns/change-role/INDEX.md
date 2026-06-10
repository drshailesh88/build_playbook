# INDEX — change-role (B10)

## Coverage
- Queries run — by-pattern: "change member role confirmation dialog demote admin permissions warning", "cannot remove yourself last owner transfer ownership before leaving workspace warning"; by-app: Notion/Vercel members queries (inline dropdowns surfaced); by-flow: "change a member's role or remove member from team settings" (Whop, Exa, Coda, Visitors flows). Platform: web only.
- Apps swept: Notion, Vercel, Exa, Coda, Sana AI, Current, Whop, ClickUp, Twist, Remote, WhatsApp, Luma, OpenAI Platform, Asana, Mural, Base44, 1Password, Google Workspace.
- NOT found / excluded: no app observed confirming a privilege ESCALATION specifically (all observed confirms are demotions/guest conversions — escalation confirms are our extrapolation of the same dialog); no role-change audit-log UI surfaced in this sweep (Whop had an audit table in the background, not harvested); Luma's "Remove Admin" and OpenAI's role-permission editor were captured but are remove/role-definition surfaces, not member role change — excluded from cards.
- Saturation: the two later queries returned only additional confirm-dialog phrasings; pattern set stable.

## Patterns
- ★ inline-role-dropdown-on-row — role cell as dropdown with descriptions, immediate save + toast, static text when not permitted (Notion, Vercel, Exa, Coda, Sana AI, Current)
- ★ consequence-confirm-dialog — old→new role named, capability deltas listed, checkbox gate for severe demotions (Whop, ClickUp, Twist, Remote, WhatsApp)
- ★ self-and-last-owner-guards — static self-row, hard block with reason, forced ownership succession (Asana, Mural, Sana AI, Vercel, Base44)
- member-detail-panel-role-edit — role select inside person detail with remove quarantined (Whop, 1Password)
- bulk-role-change — selection mode + Change roles menu + count toast (Coda, Google Workspace)

★ = recommended default: inline dropdown as the mechanism, confirm dialog fired only across privilege boundaries, guards enforced server-side and reflected at the control level.
