# Pattern: Parametric certificate editor (form rail + live sample-data preview)

**Surface:** certificates / template-design · **Observed in:** Teachable, Deel, Kajabi, Podia (refs: https://mobbin.com/screens/141ab4d3-0b79-4666-ba71-a0c493b06a60, https://mobbin.com/flows/e75e5b29-6ae8-4424-ab8f-8c525fdde012, https://mobbin.com/flows/0cef33a3-a1f9-499a-8071-389d598a4719, https://mobbin.com/flows/66885cf7-aaf1-43b1-bf25-db000f521391)

## Flow
1. Left rail is a FORM, not a canvas: Content tab (logo upload with stated constraints "Size: 300x300px (PNG, SVG)", Title, "Awarded To" subtitle, date label, optional signature upload, serial-number label) + Design tab (background/text colors as hex inputs with swatches). (Teachable)
2. Deel variant: 3-step wizard (Certificate details → Design & review → Certificate settings) with radio groups — Orientation (Landscape/Portrait), Layout (Left/Centered/Right), Colors, Logo dropzone ("PNG, JPG; max 10MB").
3. Center/preview canvas renders the FULL certificate live with sample recipient data ("Sam Lee", "John Doe", "Serial No. cert_123456789") — never an empty placeholder layout.
4. Kajabi variant: every content field has its own enable checkbox behind one master toggle ("Provide certificates for this course").
5. Autosave indicator ("• Saved"), Preview, Finish.

## Use when
Most issuers want an on-brand certificate in minutes, not a design tool; layout correctness (nothing overlapping, print-safe) must be guaranteed by the system.

## Avoid when
The org genuinely needs free-form layouts (sponsor logos in arbitrary positions, multi-language dual layouts) — then a canvas editor (see field-palette-merge-editor card) is the escape hatch, not the default.

## Sad paths observed
- Upload constraints stated inline before failure (file type/size limits on every dropzone).
- Kajabi shows literal "[Name of Student]" placeholder in preview — weaker than Teachable/Deel sample-name rendering; avoid bracket placeholders in preview.

## Accessibility
Form-rail editing is fully keyboard/screen-reader accessible by construction — a major advantage over canvas editors.

## Default verdict for our stack
RECOMMENDED as the default template path — the legacy pdfme free canvas (census #47) becomes the "advanced" mode; parametric covers 90% of conference certificates with zero layout defects.
