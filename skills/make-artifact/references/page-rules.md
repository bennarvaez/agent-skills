# Page rules

Every page follows these rules. Step 3 of the procedure checks the draft against the checklist at the end of this file.

## One self-contained file

- The page is a single `.html` file, with all CSS in a `<style>` block and all JS in inline `<script>` blocks.
- External scripts come only from cdnjs.cloudflare.com or cdn.jsdelivr.net, pinned to an exact version (`chart.js@4.4.1`). Never use `@latest` or an unversioned URL. Most pages need no library at all: plain CSS, SVG and JS cover tables, bar charts and small tools.
- Fonts come only from Google Fonts, and every font is followed by a fallback stack: `font-family: "Inter", system-ui, sans-serif;`.
- Images are `data:` URIs or files in an `assets/` folder next to the page; the save script copies that folder. Never hotlink images from other sites.

## Title

`<title>` is the page's name in 2-4 words: `Q3 Hiring Plan`, not `A page showing the hiring plan for Q3`. The `<h1>` can be longer and say more.

## Themes

- Every colour used for styling is a CSS variable defined on `:root`, and those values are the light palette. No colour literals elsewhere in the CSS, the SVG or the JS. Colours that are the page's data, such as a swatch the user entered, are the exception.
- The dark palette redefines the same variables twice: once under `@media (prefers-color-scheme: dark)`, guarded by `:root:not([data-theme="light"])`, and again under `:root[data-theme="dark"]`.
- `color-scheme` matches each palette, so form controls and scrollbars follow the theme.
- `body` always has an explicit background colour.

```css
:root { color-scheme: light; --bg: #f6f7f9; --text: #1b1e24; }
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) { color-scheme: dark; --bg: #14171c; --text: #e6e8ec; }
}
:root[data-theme="dark"] { color-scheme: dark; --bg: #14171c; --text: #e6e8ec; }
body { background: var(--bg); color: var(--text); }
```

The media block follows the OS setting unless the page is forced light. The last block forces dark whatever the OS says. `assets/starter.html` already has all of this.

- In both themes, text has at least 4.5:1 contrast with its background. Large text, input borders and chart marks need at least 3:1.

## Phone width

- The page works at about 400px wide: a 16px gutter on each side and no horizontal scrolling of the page.
- Only wide tables and code blocks may scroll, and they scroll inside their own container (`overflow-x: auto`).
- Images and SVGs get `max-width: 100%`, and grids collapse to one column. Don't put `overflow-x: hidden` on `body` to hide a layout that's too wide.

## Complete when loaded

- Everything is visible as soon as the page loads. Nothing fades or slides in when it's scrolled into view, and nothing that could simply be on the page waits for a click.
- No empty states. A tool opens with example data, labelled as an example on the page, so its output shows straight away.

## Nothing that gets in the way

- No emojis as decoration, whether as icons, bullets or section markers.
- No `alert()`, `confirm()` or `prompt()`. Show messages in the page.

## Accessible

- Every form control has a `<label>`. Use `aria-label` only when a visible label really doesn't fit.
- Keyboard focus is visible in both themes (`:focus-visible` with an outline). Never remove an outline without replacing it.
- `prefers-reduced-motion` turns off animations and transitions that aren't essential.
- Use the real element: `<button>` for actions, `<a>` for links, and `<table>` with `<th>` headers for tabular data. Colour is never the only way meaning is shown; add a word, a label or a shape.

## Saved data

- Data that must persist goes in `localStorage`, and only for one viewer's conveniences: last inputs, a chosen tab, a collapsed section.
- Wrap every read and write in `try/catch`. The page must work when storage is empty or blocked.
- Prefix every key with the page's slug (`q3-hiring-plan:filters`), because pages opened from `file://` can share one storage area.
- If the page needs data stored anywhere beyond this browser (for other people, other devices or a database), say that it needs a backend. Don't fake one with `localStorage`.

## Checklist

- [ ] One file; any CDN script pinned to an exact version; fonts have fallbacks; no hotlinked images
- [ ] `<title>` is a 2-4 word name
- [ ] Colours are variables; dark mode defined in both places; `color-scheme` set; `body` has a background colour; contrast holds in both themes
- [ ] At about 400px: 16px gutter, no horizontal page scroll, wide tables and code scroll in their own container
- [ ] Everything visible on load; a tool opens with example data that's labelled as an example
- [ ] No decorative emojis; no `alert`, `confirm` or `prompt`
- [ ] Every control has a label, focus is visible, reduced motion is respected, meaning isn't shown by colour alone
- [ ] `localStorage` holds only conveniences, inside `try/catch`, with keys prefixed by the slug
