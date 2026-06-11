# Pattern: Never-blank cover image system (generated default → stock search → upload → focus point)

**Surface:** events-creation-landing · **Observed in:** Luma web (https://mobbin.com/screens/3d836166-0c6c-4e7d-be27-242a20749625, https://mobbin.com/flows/199f089b-0833-48ca-8f85-33ae37046b61), Luma iOS (https://mobbin.com/flows/08f11f1e-3068-45bd-9cb2-1c386f625901), Eventbrite web (https://mobbin.com/screens/be1399ca-37cd-477d-ac5f-e63e0193677d, https://mobbin.com/flows/2bd6dc91-4972-4950-aae9-38aa4ab93cb7, https://mobbin.com/screens/b4a68a09-d3d5-4fe1-ba34-321c1f35389b), Posh web (https://mobbin.com/screens/3f2fbf25-7619-4ff8-a28f-d9670205dc34), Circle web (https://mobbin.com/screens/b618fee6-e741-47cd-8078-039f5f23215b), Notion web — analogous AI (https://mobbin.com/screens/c562f7e8-d22a-45ac-b255-b73d72b34d34)

## Flow
1. New events get a presentable generated cover automatically (abstract gradient / themed poster) with a single overlay button "Change Cover Photo" — the page never looks broken pre-upload (Luma).
2. The picker is search-first, not upload-first: stock search panel with "Upload" beside it (Luma); tabbed Unsplash / Upload / Embed link with photographer attribution (Circle); Images + GIFs tabs (Posh); curated themed poster gallery + "Choose From Library" (Luma iOS).
3. Constraints printed BEFORE upload: "Recommended image size: 2160 x 1080px · Maximum file size: 10MB · Supported image files: JPEG, PNG" (Eventbrite); "…upload a 4:5 flyer — Other sizes will be cropped." (Posh).
4. One upload serves many surfaces via a Focus Point modal: draggable crosshair + live Square (1:1) and Rectangle (2:1) crop previews — "We'll adapt this image for different devices, centering on your focus point." (Eventbrite).
5. Quality is taught, not policed: contrastive good/bad example modal ("Try to avoid using a lot of text on your image") and a stat nudge ("82% of attendees prefer main event images that show an event's vibe and atmosphere."), plus a "Design with Canva" escape hatch for non-designers (Eventbrite).
6. AI generation (analogous, Notion): prompt + style presets (General/Photo/Pattern) in a tab alongside Gallery/Upload/Unsplash — no event-native AI cover generator surfaced this sweep.

## Use when
The landing page leads with imagery (it should) and most organizers have no design resources. Focus point matters once the cover renders in 2+ aspect ratios (page hero, list card, social/OG card).

## Avoid when
Brand-controlled tenants that mandate fixed key visuals — then the default comes from tenant branding, not generated art. Skip GIFs for professional/medical contexts.

## Sad paths observed
- Failed-upload prevention via constraints stated up front; crop warning before upload.
- No-asset organizer: stock search/default art means zero-image events still ship credible pages.

## Accessibility
Cover is decorative (title/date live as text); attribution lines on stock photos; teaching modal uses text labels not color-coding alone.

## Default verdict for our stack
RECOMMENDED — the old app's landing page has NO imagery at all (publicPageSettings never built). Minimum V1: branded default cover derived from tenant branding + upload with stated constraints + single focus point serving hero/card/OG. Stock search VIABLE; AI generation V2.
