# Pattern: Revoke lifecycle — impact-stating confirm, dependency guard, segregated + reversible

**Surface:** certificates / lifecycle-admin · **Observed in:** Salesforce, Air, Productboard, Zoho, Twingate, Copilot, Vanta, Eventbrite, Slite (refs: https://mobbin.com/flows/ff0fcdb1-6f77-4fa2-b1e8-261395518b2a, https://mobbin.com/flows/92289b0d-b1eb-4e80-a4bd-287af7e45ece, https://mobbin.com/flows/db5f82c9-f4d3-4810-89c8-13cec343ea0c, https://mobbin.com/flows/e02b9b31-d997-4488-a839-8a40c647a951, https://mobbin.com/flows/5f8e0fe0-327b-44da-8ce2-62613c149ab3, https://mobbin.com/screens/7dedb891-b93a-48ad-9e3f-3463ae4064c6, https://mobbin.com/screens/784fd37d-3429-4f47-b58c-0b6fc0ffed07)

⚠️ COVERAGE NOTE: NO app in the corpus captures a revocation REASON — every confirm states impact only. Reason capture (which legacy already has, census #20) exceeds the observed industry; keep it.

## Flow
1. Confirm states the IMPACT in a sentence, not "Are you sure?": "Removing Jane Doe's guest membership will prevent them from accessing 1 board in SLMobbin." (Air); destructive button colored red (Productboard).
2. Dependency guard blocks unsafe deletes: "SLMobbin contains 1 active key that must be revoked or deleted first." — delete button DISABLED until cleared (Twingate). For certificates: can't archive/delete a template-or-event with live certificates without deciding their fate.
3. Soft disable coexists with hard delete; status filter exposes Disabled items (Twingate).
4. Revoked entities are SEGREGATED, not erased: Deactivated tab/section with re-Activate link (Salesforce, Productboard, Air).
5. Artifact-facing result: "Successfully cancelled order" banner atop the now-void ticket (Eventbrite) — the revoked certificate's public face.
6. Granular vs nuclear in one modal: per-token trash icons + "Delete all API Tokens" (Vanta).

## Use when
Every revoke/archive in the module — template archive, certificate revoke, bulk-run cancel.

## Avoid when
Don't offer "reversible" UI for actions that are legally irreversible (a revocation that was publicly visible should not silently un-revoke — reissue instead, keeping the chain).

## Sad paths observed
- Already-revoked re-attempt → no-op with current status (legacy pathway PATH-certificates-003 already asserts this).
- Slite's status set (verified / outdated / verification expired) is the richest observed state vocabulary for credential validity.

## Accessibility
Impact sentence is real text in the dialog; disabled destructive buttons need a visible reason (Twingate shows the inline guard line).

## Default verdict for our stack
RECOMMENDED — legacy revoke-with-reason is KEPT (it beats the corpus); steal the impact-sentence confirm, the dependency guard for template/event deletion, and the segregated revoked/superseded filters on the issued list.
