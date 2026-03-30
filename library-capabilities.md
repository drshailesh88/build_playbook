# Common Library Capability Mappings

Pre-built mappings for libraries frequently found in JS/TS projects. Use these to accelerate Layer 2 enrichment. For libraries NOT listed here, use web search or Context7 MCP.

**Last verified:** 2026-03 (update periodically)

---

## Tiptap / ProseMirror

### @tiptap/starter-kit
Bundles these extensions (ALL active by default):
- **Bold** — Ctrl+B, `**text**` input rule
- **Italic** — Ctrl+I, `*text*` input rule  
- **Strike** — Ctrl+Shift+X, `~~text~~` input rule
- **Code** — Ctrl+E, `` `text` `` input rule
- **Heading** — levels 1-6, `# ` through `###### ` input rules
- **BulletList** — `- ` or `* ` input rule
- **OrderedList** — `1. ` input rule
- **Blockquote** — `> ` input rule
- **CodeBlock** — ` ``` ` input rule
- **HorizontalRule** — `---` input rule
- **HardBreak** — Shift+Enter
- **History** — Ctrl+Z undo, Ctrl+Shift+Z / Ctrl+Y redo
- **Document** — root node (structural)
- **Paragraph** — default block node
- **Text** — inline text node
- **Dropcursor** — visual cursor when dragging content
- **Gapcursor** — cursor placement at otherwise unreachable positions

### @tiptap/extension-table
- Insert table (rows × columns)
- Add row before/after
- Add column before/after
- Delete row, delete column, delete table
- Merge cells, split cell
- Toggle header row/column
- Table cell background color (if configured)

### @tiptap/extension-link
- Set link on selected text (Ctrl+K common)
- Remove link
- Auto-link on paste (URLs become clickable)
- Open link on click (configurable)
- Link editing popup/modal (if UI wired)

### @tiptap/extension-image
- Insert image by URL
- Drag-and-drop image (if configured)
- Image alignment (if configured)
- Image resize (if configured)
- Alt text editing

### @tiptap/extension-placeholder
- Shows placeholder text when editor is empty
- Per-node placeholders (configurable)

### @tiptap/extension-character-count
- Character count display
- Word count display
- Limit enforcement (if max configured)

### @tiptap/extension-color
- Set text color
- Remove text color

### @tiptap/extension-highlight
- Highlight/mark selected text (with color options if configured)
- Ctrl+Shift+H (common shortcut)

### @tiptap/extension-text-align
- Align left, center, right, justify
- Ctrl+Shift+L/E/R/J (common shortcuts)

### @tiptap/extension-underline
- Underline text — Ctrl+U

### @tiptap/extension-subscript
- Subscript text — Ctrl+, (common)

### @tiptap/extension-superscript
- Superscript text — Ctrl+. (common)

### @tiptap/extension-task-list + @tiptap/extension-task-item
- Checkbox/task list items
- `[ ] ` input rule
- Toggle checkbox on click

### @tiptap/extension-font-family
- Set font family on selected text
- Remove font family

### @tiptap/extension-text-style
- Base extension for text styling (color, font, size)
- Usually combined with color/font-family extensions

### @tiptap/extension-typography
- Smart quotes: "text" → "text"
- Em dash: -- → —
- Ellipsis: ... → …
- Arrows: -> → →, <- → ←
- Fractions: 1/2 → ½

### @tiptap/extension-bubble-menu
- Floating toolbar appears on text selection
- Shows formatting options contextually
- Position follows cursor/selection

---

## React PDF

### @react-pdf/renderer
- Generate PDF documents from React components
- Page sizing, margins, orientation
- Text, Image, View, Link components
- StyleSheet for PDF styling
- Download/stream PDF

### react-pdf
- Display PDF files in React
- Page navigation (next/prev/goto)
- Zoom in/out
- Text selection and copy
- Text search within PDF
- Page thumbnails (if configured)
- Annotation rendering (if configured)

---

## Clerk Auth

### @clerk/nextjs
- Sign-in page/modal (email, OAuth providers)
- Sign-up page/modal (with verification)
- User button/dropdown (profile, sign-out)
- Session management (auto-refresh)
- Organization switching (if multi-org)
- Middleware route protection
- useUser(), useAuth(), useClerk() hooks
- Custom sign-in/sign-up flows

---

## File Handling

### react-dropzone
- Drag-and-drop file upload zone
- Click to browse files
- File type filtering (accept prop)
- Multiple file selection
- File size validation
- File rejection with error messages
- Drag active visual feedback
- Disabled state

---

## Data Visualization

### recharts
- LineChart, BarChart, AreaChart, PieChart, RadarChart, ScatterChart
- Tooltip on hover
- Legend
- Responsive container
- Animated transitions
- Customizable axes
- Grid lines
- Reference lines/areas
- Brush for zoom/filter (if configured)

### react-plotly.js / plotly
- 40+ chart types
- Interactive zoom, pan, hover
- Export as PNG/SVG
- Responsive sizing
- Animation frames
- 3D charts (if configured)

---

## AI/Chat

### ai (Vercel AI SDK)
- useChat() — streaming chat messages
- useCompletion() — streaming text completion
- useAssistant() — assistant thread management
- Streaming text rendering
- Stop/cancel generation
- Error handling and retry
- Tool/function calling (if configured)

---

## Editor / Code

### mermaid
- Flowchart rendering
- Sequence diagram rendering
- Gantt chart rendering
- Class diagram rendering
- State diagram rendering
- Entity relationship diagram rendering
- SVG output
- Theme customization

---

## Export / Document Generation

### pptxgenjs
- Create PowerPoint presentations
- Add slides with layouts
- Text, images, shapes, tables, charts
- Slide masters/templates
- Export as .pptx file

### docx (npm package)
- Create Word documents
- Paragraphs, headings, tables, images
- Page breaks, headers, footers
- Numbered and bullet lists
- Table of contents
- Export as .docx file

---

## Tables

### @tanstack/react-table
- Column sorting (single/multi)
- Column filtering
- Global search/filter
- Pagination
- Row selection (single/multi)
- Column resizing
- Column reordering
- Column visibility toggle
- Row expansion
- Grouping
- Export data

---

## Notes

- This is NOT exhaustive. Many smaller libraries exist. For unlisted libraries, use web search.
- Library capabilities depend on version. Check the installed version in package.json.
- "If configured" means the capability exists in the library but requires explicit setup. Check Layer 1 for configuration evidence.
- Keyboard shortcuts vary by OS (Ctrl on Windows/Linux, Cmd on Mac). List the Ctrl version; the framework usually handles Cmd mapping.
