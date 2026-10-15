# Design

This is how to make a page look deliberate rather than generated. The rules in `page-rules.md` still apply.

## Decide the treatment first

| Page | Treatment |
|---|---|
| Docs, plans, reports, comparisons | **Plain and polished.** One accent colour, a system font or one quiet typeface, generous spacing, content first. |
| Landing pages, dashboards, tools | **Bolder.** More use of the accent, a display face, more contrast between type sizes, stronger structure. |

When you're unsure, choose plain.

## Palette

- Use 4-6 named colours, each with one job, such as `ink` for text, `paper` for the background, `surface` for panels, `rule` for borders and `signal` for the accent. Add a second accent only for a second data series.
- Tint the neutrals toward the accent: with a blue accent the greys lean slightly blue, and with a green accent slightly green. Pure greys like `#808080` look unfinished.
- Design the dark palette on purpose instead of inverting the light one. The background is near-black but not black, text is off-white, and the accent is lightened until it reads on the dark background.
- Use the accent sparingly, for what the reader should notice or click.

## Type

- Use at most two typefaces, a display face and a body face, plus a monospace face for code or figures if needed. One face for everything is often the best choice.
- System font stacks are fine and load instantly. If you use Google Fonts, load only the weights the page uses.
- Use a fixed scale and nothing in between, for example a ratio of 1.25: 14, 16, 20, 25, 31 and 39px.
- Set body text at 16px or larger, with a line height of about 1.5 and lines of about 70 characters at most.
- Columns of numbers use `font-variant-numeric: tabular-nums` and are right-aligned.

## Grounding

- Let the subject decide the layout:
  - a timeline for a sequence;
  - a table for options compared on the same criteria;
  - a before-and-after for a change;
  - inputs beside their result for a calculator.
- Include at least one real detail from the subject's own world: the actual command and its output, a real figure, the term practitioners use, or a small diagram of the real thing. A detail like that is what stops a page looking like a template.

## Avoid the generic AI look

Avoid these:
- a cream background with a serif heading and a terracotta accent;
- purple-to-blue gradient heroes;
- everything centred;
- grids of identical rounded cards, each with an icon on top;
- emojis as section markers;
- a large hero that repeats the title before any content.

## Writing

- Write short, plain sentences. Lead with the conclusion, then give the detail.
- Name things from the user's point of view ("Your monthly cost"), not the system's ("computed_total").
- Where it fits, a heading says what the section tells the reader ("Squash merging drops the branch's commits") rather than only naming the topic ("Details").
- Buttons say exactly what they do, such as "Swap colours" or "Copy CSS", never "Submit" or "OK".
- Numbers carry their units, and dates are unambiguous ("4 Oct 2026").

## Charts

- **To scale.** Bar lengths are proportional to the values and start at zero. Compute positions from the data instead of placing them by eye.
- **Labelled from real values.** Put each value directly on its bar or point, rather than making the reader estimate it from gridlines and a legend.
- **One message per chart.** State it in the heading or caption.
- **Readable in both themes.** Colours come from the theme variables (`var(--accent)`, `currentColor`). Colour is never the only way to tell series apart, so add labels.
- **The right technology:**
  - Simple bar charts work well in HTML, as a grid of rows with percentage widths, and stay readable at phone width.
  - SVG suits line charts and diagrams. Give it a `viewBox` and `width: 100%`, and make sure its text is still legible when it shrinks.
  - A chart library is only worth loading for interaction such as zooming, or for many series, and its version must be pinned.
