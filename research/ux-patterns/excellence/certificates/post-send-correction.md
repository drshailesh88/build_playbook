# Pattern: Post-send correction — change recipient/details with audit trail + resend semantics

**Surface:** certificates / lifecycle-admin · **Observed in:** PandaDoc, Contractbook, Docusign, Navan (refs: https://mobbin.com/flows/d5d129fc-3300-4ead-a25a-d305e555195b, https://mobbin.com/flows/cb98b1d9-490c-4c30-b531-57d1a1ef7bbd, https://mobbin.com/flows/9a50e50a-3620-48ce-a6f2-dab8def61bdb, https://mobbin.com/flows/9d8af34f-5293-47eb-92cd-faba0c6e0dc7)

## Flow
1. Recipient card on a sent artifact opens settings: Edit personal details / **Change signer** / Remove from document (PandaDoc).
2. Swap preserves continuity: "Change signer — Select another signer to replace Jane Doe." + checkbox "**Keep Jane Doe as CC recipient.**" — the wrong recipient keeps visibility instead of vanishing (PandaDoc).
3. Resend semantics are explicit choices: "Resend now and sign later" / "Resend and sign" (Contractbook); "New signees will not have access to the document until you send it for signature."
4. Every correction lands in a Document history audit trail: Created by → Sent to [emails] by → Viewed by → Signed (timestamps + actors) (Contractbook).
5. Backup channel: copyable claim/booking link per recipient when email fails (Navan).

## Use when
"Sent the certificate to the wrong person / wrong email" — the fix must preserve the issuance record, not rewrite it.

## Avoid when
Don't allow in-place recipient swap on an ISSUED certificate — the credential names a person; wrong-person fixes are revoke + issue-new (legacy supersession chain), with this pattern's UI sugar on top.

## Sad paths observed
- Unreachable recipient → copyable direct link as the fallback channel (Navan).

## Accessibility
History trail is a text list with timestamps; correction actions are labeled menu items.

## Default verdict for our stack
RECOMMENDED as UI over existing mechanics — legacy supersession (census #17–18) + revoke handle the data; steal the one-flow "Fix recipient" affordance (revoke old + issue new + resend in one guided step) and the visible history on the certificate detail.
