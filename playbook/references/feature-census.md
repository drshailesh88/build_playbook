---
name: feature-census
description: "Extract the COMPLETE capability surface of any module or app — including features that came in through libraries you never explicitly asked for. Uses 3 layers: code extraction, library enrichment, and runtime crawl. Use BEFORE writing any test specs, QA documents, or feature docs. Use when you need to know everything a module can do. Use after building any feature."
---

# Feature Census — Complete Capability Extraction

Extract every capability a module has — what you explicitly built, what came bundled through libraries, and what actually renders in the browser. Three independent layers that cross-verify each other. Zero hallucination.

Produces a feature inventory that becomes the source of truth for QA testing, E2E specs, and self-healing loops.

## The Three Layers

```
LAYER 1: CODE EXTRACTION (deterministic, from source files)
  What the CODE does — handlers, state, conditionals, API calls, 
  library registrations with their configuration
  
LAYER 2: LIBRARY CAPABILITY ENRICHMENT (deterministic, from documentation)
  What INSTALLED LIBRARIES bring — every extension's features,
  keyboard shortcuts, toolbar actions, node types, output formats
  
LAYER 3: RUNTIME CRAWL (empirical, from the running app)
  What the USER ACTUALLY SEES — every button, menu, input, tooltip,
  keyboard shortcut, drag target, context menu, modal, and panel
  in the live application

MERGE: Cross-reference all 3 layers
  → Features in code but not visible at runtime = dead code or conditional
  → Features visible at runtime but not in code = framework default or inherited
  → Features in library docs but not in code or runtime = not configured/enabled
```

## Prerequisites

- The app must be buildable and runnable locally (for Layer 3)
- Node.js project (Layer 1 patterns are JS/TS-focused; adapt grep patterns for other stacks)
- Playwright installed (for Layer 3): `npx playwright install chromium`

## Process

### Step 0: Identify the Target

Determine what we're censusing. The user provides either:
- A module name (e.g., "editor", "dashboard", "slides")
- A URL path (e.g., "/editor/123", "/dashboard")
- A file path (e.g., "src/app/(app)/editor/page.tsx")

Resolve to:
- **Entry file(s)**: the page/component root files
- **Route URL**: the path to visit in the browser
- **Module boundary**: what's in scope vs out of scope

---

### Step 1: Layer 1 — Code Extraction

**Goal:** Extract every interactive pattern from source code with file:line references.

#### 1a: Build Import Tree

Trace all imports from the entry file(s). Every transitively imported local file is in scope.

```bash
# Find all local imports recursively from entry point
grep -rn "from ['\"]@/\|from ['\"]\./" <entry-file>
```

Or use a dedicated tracer (ts-morph, madge, dependency-cruiser) if available in the project.

Record: list of all files in scope, and list of all files NOT in scope (exist in codebase but not imported by this module).

#### 1b: Extract Interactive Patterns

For every file in scope, extract these categories. Use grep, ast-grep, or direct file reading. For EVERY match, record: **category, description, file path, line number, code snippet**.

**Category: Event Handlers**
```bash
grep -rn "onClick\|onSubmit\|onChange\|onKeyDown\|onKeyUp\|onKeyPress\|onFocus\|onBlur\|onMouseEnter\|onMouseLeave\|onDragStart\|onDragEnd\|onDrop\|onScroll\|onResize\|onPaste\|onCopy\|onCut\|onDoubleClick\|onContextMenu" <files>
```

**Category: State Variables**
```bash
grep -rn "useState\|useReducer\|useContext\|createContext\|useStore\|create(\|createStore\|createSlice\|useAtom\|atom(" <files>
```

**Category: Conditional Rendering**
```bash
grep -rn " && <\| ? <\|isVisible\|isOpen\|isLoading\|isError\|isDisabled\|isActive\|isSelected\|isExpanded\|show\|hide\|toggle\|setShow\|setOpen\|setVisible" <files>
```

**Category: API Calls**
```bash
grep -rn "fetch(\|axios\.\|\.get(\|\.post(\|\.put(\|\.patch(\|\.delete(\|useSWR\|useQuery\|trpc\." <files>
grep -rn "api/\|/api/" <files>
```

**Category: Keyboard Shortcuts**
```bash
grep -rn "onKeyDown\|hotkey\|shortcut\|Mod-\|Ctrl-\|Alt-\|Meta-\|useHotkeys\|addEventListener.*key\|Keyboard\|keymap\|addKeyboardShortcuts" <files>
```

**Category: UI Elements**
```bash
grep -rn "<button\|<Button\|<a \|<Link\|<input\|<Input\|<select\|<Select\|<textarea\|<Textarea\|<form\|<Form\|<dialog\|<Dialog\|<Modal\|<Drawer\|<Popover\|<Dropdown\|<Menu\|<Tab\|<Tooltip" <files>
```

**Category: Disabled/Error States**
```bash
grep -rn "disabled=\|disabled:\|isDisabled\|\.error\|Error\|catch(\|ErrorBoundary\|fallback=\|loading=\|skeleton\|Skeleton\|emptyState\|EmptyState\|noResults\|placeholder=" <files>
```

**Category: User-Visible Strings**
```bash
grep -rn "placeholder=\"\|title=\"\|aria-label=\"\|tooltip\|label=\"\|alt=\"\|helperText\|errorMessage\|successMessage\|toast\|Toast\|notify" <files>
```

**Category: Navigation & Routing**
```bash
grep -rn "router\.push\|router\.replace\|useRouter\|useNavigate\|<Link\|href=\"\|window\.location\|redirect" <files>
```

**Category: File Operations**
```bash
grep -rn "download\|upload\|export\|import\|FileReader\|Blob\|createObjectURL\|readAsDataURL\|readAsText\|react-dropzone\|Dropzone\|accept=\|fileType" <files>
```

#### 1c: Extract Library Registrations (Critical)

Find where third-party libraries are initialized with their configuration. This is how you discover emergent features.

```bash
# Editor frameworks
grep -rn "useEditor\|createEditor\|Editor(\|EditorContent\|extensions:\[" <files>

# Any .use() or plugin registration
grep -rn "\.use(\|plugins:\[" <files>

# Component library imports (each import = a capability)
grep -rn "from ['\"]@" <files> | grep -v node_modules

# Store/state management setup
grep -rn "createStore\|configureStore\|create(\|Provider" <files>
```

For each registration found: **read the full configuration object**. If Tiptap's `useEditor` is called with `extensions: [StarterKit, Bold, Italic, Table, ...]`, list every extension in that array.

Save Layer 1 output as: `feature-census/<module>/layer-1-code.json`

---

### Step 2: Layer 2 — Library Capability Enrichment

**Goal:** For every library and extension found in Layer 1, enumerate all capabilities it brings — including features the developer never explicitly asked for.

#### 2a: Build the Library List

From Layer 1's library registrations, create a list of every third-party library and extension in use. Also read `package.json` for the module's direct dependencies to catch libraries used without explicit registration.

#### 2b: Look Up Capabilities

For each library/extension, fetch its documentation and extract capabilities.

**Use web search or Context7 MCP:**
```
Search: "[library-name] API reference features"
Search: "[extension-name] what it does keyboard shortcuts"
```

**What to extract per library/extension:**

| Extract | Example |
|---------|---------|
| **User-facing actions** | "Toggle bold on selected text" |
| **Keyboard shortcuts** | "Ctrl+B for bold, Ctrl+I for italic" |
| **Toolbar/menu items** | "Adds a 'Table' menu with insert/delete row/column" |
| **Node/block types** | "Adds 'codeBlock' node type with syntax highlighting" |
| **Input rules** | "Typing '## ' auto-converts to heading level 2" |
| **Paste rules** | "Pasting a URL auto-creates a link" |
| **Output formats** | "Can export to HTML, JSON, Markdown" |
| **Configuration options** | "Supports 'levels: [1,2,3]' to limit heading levels" |
| **Default behaviors** | "Undo/redo enabled by default in StarterKit" |

**What to SKIP (not user-facing features):**
- CSS/styling libraries (Tailwind, styled-components)
- Icon packs (Lucide, Phosphor, Heroicons) — they provide icons, not features
- Utility libraries (lodash, date-fns, clsx) — no user-facing capabilities
- Type libraries (@types/*)
- Build tools (webpack, vite, postcss)
- Testing libraries (vitest, playwright, jest) — unless they add runtime features

#### 2c: Cross-Reference with Layer 1

For each library capability found:
- **CONFIGURED**: The extension is registered AND the capability is documented → feature exists
- **AVAILABLE BUT UNCONFIGURED**: Library is installed in package.json but extension is NOT in the registration array → feature is available but likely not active
- **DEFAULTS**: Part of a bundle (like StarterKit) that includes it automatically → feature exists even though developer never asked for it

Save Layer 2 output as: `feature-census/<module>/layer-2-libraries.json`

---

### Step 3: Layer 3 — Runtime Crawl

**Goal:** Walk through the running application and catalog every interactive element the user can actually see and use.

#### 3a: Ensure the App is Running

```bash
# Check if dev server is running
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 || echo "NOT_RUNNING"
```

If not running:
```bash
npm run dev &
# Wait for server to be ready
npx wait-on http://localhost:3000 --timeout 30000
```

#### 3b: Navigate to the Module

Use Playwright to open the target page:

```javascript
const { chromium } = require('playwright');
const browser = await chromium.launch();
const page = await browser.newPage();
await page.goto('http://localhost:3000/<route>');
await page.waitForLoadState('networkidle');
```

If the page requires authentication, handle login first (check for Clerk or other auth patterns in the codebase).

#### 3c: Extract the Accessibility Tree

The accessibility tree is the complete inventory of what a user (or assistive technology) can interact with:

```javascript
const tree = await page.accessibility.snapshot({ interestingOnly: true });
```

This returns every:
- Button (with label)
- Link (with text and href)
- Input/textbox (with label and placeholder)
- Checkbox/radio (with label and state)
- Menu/menuitem
- Tab/tabpanel
- Dialog/alert
- Toolbar
- Tree/treeitem
- Heading (with level)

Record the full tree with roles, names, and states.

#### 3d: Enumerate Interactive Elements via DOM

The accessibility tree sometimes misses custom interactive elements. Supplement with DOM queries:

```javascript
// All clickable elements
const clickables = await page.$$eval('[onclick], [role="button"], button, a, [tabindex]', 
  els => els.map(el => ({
    tag: el.tagName,
    text: el.textContent?.trim()?.slice(0, 100),
    role: el.getAttribute('role'),
    ariaLabel: el.getAttribute('aria-label'),
    title: el.getAttribute('title'),
    href: el.getAttribute('href'),
    disabled: el.disabled,
    className: el.className?.slice?.(0, 100)
  }))
);

// All inputs
const inputs = await page.$$eval('input, textarea, select, [contenteditable]', 
  els => els.map(el => ({
    tag: el.tagName,
    type: el.type,
    placeholder: el.placeholder,
    label: el.getAttribute('aria-label') || el.labels?.[0]?.textContent,
    required: el.required,
    disabled: el.disabled
  }))
);

// All tooltips, menus, dropdowns (often hidden)
const hiddenElements = await page.$$eval('[data-state], [data-tooltip], [role="menu"], [role="dialog"], [role="tooltip"]',
  els => els.map(el => ({
    role: el.getAttribute('role'),
    state: el.getAttribute('data-state'),
    text: el.textContent?.trim()?.slice(0, 100)
  }))
);
```

#### 3e: Discover Hidden Interactions

Many features are behind clicks, hovers, or keyboard shortcuts. Probe for them:

```javascript
// Right-click context menus
await page.click('<target-element>', { button: 'right' });
// Capture any new elements that appeared

// Toolbar buttons — click to reveal dropdowns
// Hover states — menus that appear on hover
// Keyboard shortcuts — try common ones and see what happens
const shortcuts = ['Control+b', 'Control+i', 'Control+u', 'Control+z', 'Control+y', 
                   'Control+s', 'Control+k', 'Control+shift+l', 'Tab', 'Escape'];
for (const shortcut of shortcuts) {
  await page.keyboard.press(shortcut);
  // Check if any new element appeared (modal, toolbar, panel)
  await page.waitForTimeout(200);
}
```

#### 3f: Capture Visual State

Take screenshots for reference:

```javascript
await page.screenshot({ path: `feature-census/<module>/screenshot-full.png`, fullPage: true });
```

Save Layer 3 output as: `feature-census/<module>/layer-3-runtime.json`

---

### Step 4: Merge and Cross-Reference

Combine all three layers into a unified census. For every feature, record which layers confirmed it:

| Feature | Layer 1 (Code) | Layer 2 (Library) | Layer 3 (Runtime) | Status |
|---------|:-:|:-:|:-:|--------|
| Bold text toggle | ✅ handler found | ✅ StarterKit docs | ✅ button visible | **CONFIRMED** |
| Table insert | ✅ extension registered | ✅ Table docs | ✅ menu item visible | **CONFIRMED** |
| Superscript | ✅ extension registered | ✅ extension docs | ❌ no button found | **CODE-ONLY** (might be keyboard-only) |
| Print | ❌ | ❌ | ✅ button visible | **RUNTIME-ONLY** (browser default?) |
| Undo/redo | ❌ no explicit handler | ✅ StarterKit default | ✅ shortcut works | **EMERGENT** (from library) |

**Status categories:**
- **CONFIRMED**: Found in 2+ layers. Highest confidence.
- **CODE-ONLY**: In code but not visible at runtime. May be conditional, behind a flag, or dead code.
- **LIBRARY-ONLY**: Documented in library but not configured and not visible. Probably not active.
- **RUNTIME-ONLY**: Visible in app but no code or library match found. Could be a browser default or framework behavior.
- **EMERGENT**: Not in your code, but provided by a library and visible at runtime. These are features you got "for free."

---

### Step 5: Produce the Feature Census Document

Generate the final document with ALL features organized by category.

#### Output: `feature-census/<module>/CENSUS.md`

```markdown
# Feature Census: [Module Name]

**Generated:** [date]  
**Entry points:** [file paths]  
**Files in scope:** [count]  
**Route URL:** [url]  
**Method:** 3-layer extraction (code + library + runtime)

## Summary

| Metric | Count |
|--------|-------|
| Total features | [N] |
| From your code | [N] |
| From libraries (emergent) | [N] |
| Confirmed (2+ layers) | [N] |
| Code-only (not visible) | [N] |
| Runtime-only (no code match) | [N] |

---

## Features by Category

### Text Formatting
| # | Feature | Shortcut | Source | Code Ref | Status |
|---|---------|----------|--------|----------|--------|
| 1 | Bold text | Ctrl+B | StarterKit | src/components/editor/Editor.tsx:45 | CONFIRMED |
| 2 | Italic text | Ctrl+I | StarterKit | — (library default) | EMERGENT |
| ... | | | | | |

### Editor Actions
| # | Feature | Shortcut | Source | Code Ref | Status |
|---|---------|----------|--------|----------|--------|
| ... | | | | | |

### Navigation
| # | Feature | Trigger | Source | Code Ref | Status |
|---|---------|---------|--------|----------|--------|
| ... | | | | | |

### API Interactions
| # | Feature | Endpoint | Method | Code Ref | Status |
|---|---------|----------|--------|----------|--------|
| ... | | | | | |

### State & Data Display
| # | Feature | State Variable | Initial | Code Ref | Status |
|---|---------|---------------|---------|----------|--------|
| ... | | | | | |

### Error & Empty States
| # | Feature | Condition | Message | Code Ref | Status |
|---|---------|-----------|---------|----------|--------|
| ... | | | | | |

### File Operations
| # | Feature | Trigger | Format | Code Ref | Status |
|---|---------|---------|--------|----------|--------|
| ... | | | | | |

---

## Discrepancies

### Code-Only (found in code, not visible at runtime)
_These may be behind feature flags, conditional on user role, or dead code._

| Feature | Code Ref | Possible Reason |
|---------|----------|----------------|
| ... | | |

### Runtime-Only (visible in app, no code match)
_These may be browser defaults, framework behaviors, or injected by parent components._

| Feature | Where Seen | Possible Source |
|---------|-----------|----------------|
| ... | | |

### Library Capabilities NOT Active
_These are documented in libraries you have installed but are not configured or visible._

| Library | Capability | Why Not Active |
|---------|-----------|---------------|
| ... | | |

---

## QA Test Targets

_Every CONFIRMED and EMERGENT feature is a QA test target._

Total testable features: [N]

- [ ] [Feature 1] — [how to test it]
- [ ] [Feature 2] — [how to test it]
- [ ] ...
```

Also save the raw data:
```
feature-census/<module>/
  ├── CENSUS.md              # Human-readable document
  ├── layer-1-code.json      # Raw code extraction
  ├── layer-2-libraries.json # Library capability data
  ├── layer-3-runtime.json   # Playwright crawl data
  ├── merged.json            # Cross-referenced data
  └── screenshot-full.png    # Visual reference
```

### Step 6: Commit

```bash
git add feature-census/<module>/
git commit -m "census: complete feature extraction for <module> — [N] features ([N] emergent)"
```

---

## Portability

This skill works on any JavaScript/TypeScript project. To use in a new repo:

1. Copy this skill to `.claude/skills/feature-census/SKILL.md`
2. Run: `/feature-census <module-name>`
3. The skill adapts grep patterns based on what framework it detects

For non-JS projects, the grep patterns in Layer 1 need adjustment, but the three-layer approach still applies:
- Layer 1: Find handlers and registrations in whatever language
- Layer 2: Look up library docs (universal)
- Layer 3: Playwright crawl (universal — works on any web app)

## Rules

- **NEVER infer features from component names** — "CitationPanel" doesn't mean citations work. Read the handlers.
- **NEVER skip Layer 3** — code analysis misses runtime-composed features, framework defaults, and inherited behaviors. The browser is the final truth.
- **NEVER hallucinate features** — if it's not in any layer's data, it does not exist. Say "not found" rather than guessing.
- **ALWAYS include file:line references** for Layer 1 features — unverifiable claims are not features.
- **ALWAYS include documentation URLs** for Layer 2 features — the source must be traceable.
- **ALWAYS include screenshots** from Layer 3 — visual evidence supports the census.
- Each feature in the final CENSUS.md must be tagged with which layers confirmed it.
- The QA Test Targets section at the bottom is the handoff to your testing workflow.
