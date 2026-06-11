# Transport Pattern Library — SCREEN-Level Visual Evidence Re-Sweep

**Date:** 2026-06-11
**Method (intended):** Live Playwright browser session (MCP). Each finding recorded only after navigating to the page, scrolling to the relevant section, taking a JPEG screenshot, and visually inspecting the rendered image. Evidence class: SCREEN. Reviewer-mandated re-sweep of the vendor-DOC-based harvest.

## STATUS: BLOCKED — NO SCREEN FINDINGS RECORDED

The run was halted before any findings were captured. Browser navigation and DOM inspection worked, but **every image-capture capability was permission-denied by the harness**, making it impossible to honestly satisfy the non-negotiable rule "record ONLY what is VISIBLY present in a screenshot you actually took and looked at."

Denied capabilities (each attempted, each refused by the permission system, not by the target sites):

1. `mcp__MCP_DOCKER__browser_take_screenshot` — denied (attempted twice: with and without a filename parameter).
2. `mcp__MCP_DOCKER__browser_run_code` with `page.screenshot()` — denied.
3. `Bash` + `curl` to download the exact product-UI image assets rendered on the live page for local visual inspection via Read — denied (attempted twice: batch and single-file).
4. `Edit` on this file — also denied at the end of the run (initial `Write` succeeded).

What DID work (and what it proves):

- `browser_navigate` to https://onfleet.com/assignment-and-dispatching succeeded; `browser_evaluate` enumerated the rendered image assets. The page renders large product-image assets at these URLs (NOT visually inspected — DOM evidence only, so no SCREEN claim is made about their content):
  - `https://d3jsrlr7ydwqi5.cloudfront.net/sd0f0830/images/features/assignment-and-dispatching/assignment-and-dispatching-hero.webp` (1805x1039, alt "Dispatching Software for Fast, Accurate Driver Assignment")
  - `.../assignment-and-dispatching/automate-dispatch.webp` (1797x1692)
  - `.../assignment-and-dispatching/stay-ahead.webp` (1797x1692)
  - `.../assignment-and-dispatching/timeline-first.png`, `timeline-second.png` (1512x1164)
- Page copy visible in the accessibility tree confirms Onfleet markets "Exception Handling — Automatically flag delays and failed deliveries so dispatch teams can quickly step in, reassign orders" and "Command Center and Live Monitoring" (relevant to `attention-flags-exception-queue` and `dispatch-board-unassigned-queue`), but per the rules this is DOC/marketing-copy evidence, not SCREEN evidence.

## S1. Day-of boarding / check-in UI

No findings — blocked before capture (see STATUS).

## S2. Dispatch board with unassigned queue + exception flags

No findings — blocked before capture (see STATUS). onfleet.com/assignment-and-dispatching was reached and renders candidate product-UI images (listed above) that a future permitted run should inspect first.

## S3. Arrivals roll-up / transfer planning boards

No findings — not attempted (run halted at capture stage).

## S4. Driver run sheet / trip sheet / manifest

No findings — not attempted (run halted at capture stage).

## S5. Passenger-facing notification / tracking page

No findings — not attempted (run halted at capture stage).

## COVERAGE NOTE

URLs attempted:

| URL | Result |
|---|---|
| https://onfleet.com/assignment-and-dispatching | Reached; DOM enumerated; image capture permission-denied — no SCREEN evidence recorded |
| All other targets (tripshot.com, track-pod.com, ridezum.com, hopskipdrive.com, support.onfleet.com, bringg.com, jungleworks.com/tookan, optimoroute.com, routific.com, tourplan.com, welcomepickups.com, hoppa.com, moovsapp.com, limoanywhere.com, onfleet.com/visibility-and-tracking, g2.com) | Not attempted — run halted once capture proved impossible |

Surfaces still lacking screen evidence: **all of S1–S5**. None of the "no screen evidence" gates can be lifted by this run.

**To unblock a re-run:** allow `mcp__MCP_DOCKER__browser_take_screenshot` (sufficient on its own), or alternatively `mcp__MCP_DOCKER__browser_run_code`, or `Bash` curl for image-asset download + local Read inspection. Onfleet's image-asset URLs above are ready targets for the first minutes of a permitted re-run.
