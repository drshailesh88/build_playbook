# Pattern: Narrative reporting overview (sentences + charts)

**Surface:** dashboard-reports / reporting hub · **Observed in:** Stripe, Amplitude (refs: https://mobbin.com/flows/29a0bba1-f256-494d-9756-77cb7bb2ef4f, https://mobbin.com/screens/72da281c-87c1-45b6-a9ff-32b917844fbd)

## Flow
1. Stripe's Reporting overview opens with prose: "Here's an overview of your key metrics over the last 12 months." Each section leads with a plain-language finding — "Gross volume for the month of December so far is MYR 2.00", "The country with the largest share … was Singapore" — followed by the supporting chart with an "Expand" button.
2. A right rail offers "More reports" jump-offs (Sigma custom reports, Revenue recognition, "Explore all reports").
3. Amplitude renders auto-generated trend sentences on metric previews: "Current uniques are trending upwards by >1000% since Nov 17."

## Use when
The reader is a stakeholder who wants conclusions, not chart-reading homework — conference chairs and committee members fit exactly. Sentences are templatable from the same aggregates the charts use ("Registrations are up 34 this week; 86% of faculty have confirmed").

## Avoid when
Numbers are too sparse for honest sentences (a 12-person workshop's "trend" is noise) — gate narrative lines behind minimum-sample thresholds, or the prose reads as machine-generated filler.

## Sad paths observed
- Stripe still writes the sentence at zero volume ("so far is MYR 2.00") — degraded but never broken; the template must read naturally at zero.

## Accessibility
Best-in-class by construction: the finding exists as text, so screen-reader users get the conclusion without parsing a chart.

## Default verdict for our stack
VIABLE — high charm per unit effort for a "Reports" landing page; needs the trend aggregates to exist first (see kpi-cards-period-comparison).
