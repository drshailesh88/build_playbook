# Pattern: Tenant-Scoped Sign-In Wall on Deep Link
**Surface:** cross-tenant-deep-link · **Observed in:** Slack (refs: [flow "Logging into another workspace"](https://mobbin.com/flows/65baa7a3-036a-4578-b0e8-b929ebe4f6d4), [Sign in to your workspace + "already signed in to"](https://mobbin.com/screens/975fe359-2a9c-41f3-8f4c-32a271156e32))

## Flow
1. User opens a deep link into workspace ASMobbin without a session for that workspace.
2. Page-top banner states the reason: "You need to sign in to see this page."
3. Sign-in form is scoped to the target tenant: heading "Sign in to ASMobbin", subtext shows the workspace URL (asmobbinworkspace.slack.com) — the user knows exactly which org the link belongs to before entering credentials.
4. SSO buttons + email field for that workspace's allowed methods.
5. Below the form, "You're already signed in to... SLMobbin [Open]" — an escape hatch acknowledging the user's other live session without hijacking the link's intent.
6. On success, user lands on the originally requested resource inside ASMobbin (deep-link continuation), then sees normal workspace content.

## Use when
- Combination (3): logged-out user opens an org-scoped link — name the org on the sign-in screen and preserve the destination through auth.
- Combination (1) at session level: signed in elsewhere but no session for the target org — the "already signed in to..." block lets them bail to a known org instead of authenticating.

## Avoid when
- The org's existence is itself sensitive (private tenant names): naming the tenant on a public URL leaks existence. Use a generic sign-in + post-auth resolution instead.
- The resource is shareable to anonymous viewers — don't wall what link-sharing settings say is public.

## Sad paths observed
- Wrong-account sign-in attempt: the same Slack flow routes through workspace-URL entry ("your-workspace.slack.com") with "Don't know your workspace URL? Find your workspaces" — recovery for users who can't remember which tenant the link belongs to ([ref](https://mobbin.com/screens/975fe359-2a9c-41f3-8f4c-32a271156e32)).
- Session exists for a different workspace only: shown as a parallel "already signed in to" option, not an error.

## Accessibility
- The reason banner is plain text at the top of the document (first thing read by screen readers), not a toast.
- The target tenant is stated in the page heading — context is in the accessibility tree, not just a logo.
- Single-column form, labeled inputs, real buttons for SSO providers.

## Default verdict for our stack
RECOMMENDED — for combination (3): Better Auth redirect to sign-in with `callbackUrl` preserving the deep link, page headed with the target org's name; on success set activeOrganizationId to the link's org before redirecting back.
