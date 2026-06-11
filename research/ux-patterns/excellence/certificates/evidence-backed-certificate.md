# Pattern: Evidence-backed certificate (artifact paired with the work it certifies)

**Surface:** certificates / recipient + public · **Observed in:** Skillshare, Uxcel, Coursera (refs: https://mobbin.com/screens/06a6f901-f956-4fc4-89f8-fe9673a4361b, https://mobbin.com/screens/7d1055dd-affd-463a-b61c-f11d2f2bf1b7, https://mobbin.com/screens/811a4fa6-865c-4a41-9385-b8995e326ba7, https://mobbin.com/flows/d96738cf-f47a-494c-88b1-57402164db45)

## Flow
1. Certificate page pairs the artifact with proof-of-work cards: "Class Completed" (class, duration, teacher) + "Project Submitted" (project thumbnail + likes) (Skillshare).
2. Uxcel: "Course completed" card + issue-date block beside the certificate.
3. The claim is therefore inspectable: a verifier sees not just "completed" but WHAT was completed and the underlying record.

## Use when
The certificate asserts participation that the system actually recorded — sessions attended, papers presented, credit hours earned. For CME this is the difference between a decoration and a defensible credential.

## Avoid when
The backing data is private (attendance patterns may be sensitive) — show evidence ONLY at the granularity the certificate already claims (e.g., "Attended: 14 of 16 sessions · 12 CME credit hours" but never the session-by-session log publicly).

## Sad paths observed
- None in-flow; the implicit guard is that evidence comes from system records, not self-attestation.

## Accessibility
Evidence cards are real text — they double as the accessible description of the image artifact.

## Default verdict for our stack
VIABLE — legacy never attempted; the attendance module (census: attendance) already holds the records. Rendering "based on N sessions / X credit hours" on the verify page makes EventState certificates audit-grade for CME.
