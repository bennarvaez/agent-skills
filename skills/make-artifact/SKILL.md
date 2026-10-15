---
name: make-artifact
description: "Makes a self-contained HTML page (an \"artifact\"): a report, comparison, plan, dashboard, chart or small interactive tool, in one file with inline CSS and JS, light and dark themes, and a layout that works on a phone. Saves each version under ~/artifacts/<slug>/ and opens it in the browser. Use when asked to make a page, an artifact, an HTML report or a dashboard, to visualize this, or to turn notes or data into something to look at rather than read in chat."
---

# Make Artifact

Build one self-contained HTML page, save it as a new version under `~/artifacts/<slug>/`, and open it in the browser. Everything stays on this machine.

## When to use it

Make a page when the answer is better seen than read: a comparison, report, plan, dashboard, chart or timeline, or a small tool with inputs. When a few sentences or one short table would do, answer in chat instead.

Don't use this skill for:
- pages that belong in the user's project; follow that project's stack and conventions instead;
- multi-page sites, or anything that needs a server or a database. Say what it would need rather than faking it.

## Procedure

Track these steps as you go:

```
- [ ] 1. Understand the request
- [ ] 2. Plan the design, then build
- [ ] 3. Check once against the page rules
- [ ] 4. Save
- [ ] 5. Report
```

### 1. Understand the request

Before writing anything, decide:
- **Job:** what the reader should know, or be able to do, after looking at the page.
- **Audience:** who reads it and what they already know. This sets the vocabulary and the level of detail.
- **Kind:** a read-only page (report, comparison, plan) or an interactive tool (inputs, calculations, filters).
- **Slug:** a short hyphenated name such as `q3-hiring-plan`. It names the folder, so reuse the same slug for a new version of an existing page.

**Revising a page you made earlier?** Read `~/artifacts/<slug>/index.html` and build on it rather than starting over. Never edit that file in place, because the save script keeps the old version only when you save a new draft.

Ask the user only when the job itself is unclear. For anything else, pick a sensible default and mention it in step 5.

### 2. Plan the design, then build

Read `references/design.md`, then write a three-line plan in your reply:

```
Palette: ink #1c2321, paper #f5f7f6, rule #d5dcd9, signal #1d7a4f (plus dark values)
Type: system sans for everything, monospace for commands; 1.25 scale
Layout: three git-log panels side by side, then a criteria-by-strategy table
```

Then copy `assets/starter.html` to the draft location and build from it. Keep its theme setup. Replace the palette and the placeholder content.

- **Draft location:** the path the user named. Otherwise, `<slug>.html` in a temporary folder outside the user's project: your scratch folder if you have one, or else the OS temp folder.
- **Content:** use real content, meaning the user's data or facts you've checked. If a tool needs example data, label it as an example on the page.
- **Examples:** when the page is similar to one of these, read it to see how a finished page handles that kind of job:

| Example | Shows |
|---|---|
| `references/examples/merge-strategies.html` | A plain comparison: real command output as the grounding detail, a criteria table that scrolls on phones |
| `references/examples/contrast-checker.html` | A bolder interactive tool: labelled example data, live results, `localStorage` for the last inputs |
| `references/examples/instruction-budgets.html` | A short report with an HTML bar chart drawn to scale from a data array |

### 3. Check once

Read `references/page-rules.md` and go through its checklist against the draft. Fix what's wrong, then move on. Do one pass, not a loop.

### 4. Save

Run the save script from this skill's `scripts/` folder (`<skill>` below is the folder this file is in):

```powershell
# Windows
powershell -NoProfile -ExecutionPolicy Bypass -File <skill>/scripts/save.ps1 -File <draft> -Name <slug>
```

```sh
# macOS / Linux
sh <skill>/scripts/save.sh --file <draft> --name <slug>
```

The script:
- copies the draft to `~/artifacts/<slug>/index.html`;
- keeps the previous version as `index.<timestamp>.html`, and makes no new version if nothing changed;
- copies an `assets/` folder next to the draft, if there is one;
- opens the page in the default browser and prints its path and version number.

Add `-NoOpen` / `--no-open` when there's no desktop, such as in a remote or headless session.

### 5. Report

Reply with one line: the path, plus any default you chose. For example: "Saved ~/artifacts/q3-hiring-plan/index.html (version 2); I assumed the plan covers engineering only."

## Gotchas

- Pages open from `file://`, where `fetch()` of local files and `<script type="module" src="...">` fail. Put data inline in the page, as a JS constant or a `<script type="application/json">` block.
- Browsers may give every `file://` page the same `localStorage`, so prefix every key with the slug.
- CDN scripts and Google Fonts need a network connection. Pin exact versions and give fonts a fallback stack, so the page still works offline, only plainer.
- Hex colours written into SVG `fill` and `stroke` don't follow the theme. Use `currentColor` or `var(--token)`.
- Without `color-scheme`, form controls and scrollbars stay light in dark mode.
- To check both themes, open the page with `?theme=dark` or `?theme=light` on the end of its URL. This works on any page built from the starter.
- On Windows, the execution policy can block scripts, and a user's PowerShell profile can print errors before the script runs. The `-NoProfile -ExecutionPolicy Bypass` command above avoids both for this one run.

## References

| File | Read it |
|---|---|
| `references/design.md` | In step 2, before planning the design |
| `references/page-rules.md` | In step 3, for the checklist; and in step 2 if you're unsure whether something is allowed |
| `references/examples/*.html` | In step 2, when the page is similar to one of them |
| `assets/starter.html` | Copy it in step 2 as the start of every page |
