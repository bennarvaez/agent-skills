# Project memory docs

These files let a person, or an agent arriving cold, see where a project stands without reading the history. The habit that makes them work is in `AGENTS.md`: **every session, before finishing, update the docs the work touched.**

| Doc | Answers | Default location | Default |
|---|---|---|---|
| README status table | What works today? | `README.md`, a "Status" section | Yes |
| Roadmap | What's next, later, and still undecided? | `docs/roadmap.md` | Yes |
| Changelog | What changed in each release? | `CHANGELOG.md` | Yes if the project releases versions or ships to users; otherwise ask |
| Decision log | Why is it like this? | `docs/decisions.md` (single log) or `docs/adr/NNNN-title.md` (ADRs) | Single log for solo or small teams; ADRs if `docs/adr/` exists or the team prefers them |
| Releasing | How do we ship, and what happens to users? | `docs/releasing.md` | Only if it ships to users |

## Contents

- Detection of existing docs
- How the docs work together
- Templates: README status section, roadmap, changelog, decision log (single log and ADR), releasing
- The AGENTS.md project memory section

## Detection

An existing doc wins over the default location. Look for, case-insensitively:

- `ROADMAP.md`, `docs/roadmap.md`, `TODO.md`, `PLANS.md`
- `CHANGELOG.md`, `CHANGES.md`, `HISTORY.md`, `NEWS.md`, `RELEASE_NOTES.md`
- `docs/decisions.md`, `DECISIONS.md`, `docs/adr/`, `docs/decisions/`, `adr/`
- `RELEASING.md`, `docs/releasing.md`, `docs/release*.md`
- A table under a "Status" or "Features" heading in `README.md`

Also check whether releases already generate notes: GitHub releases with `generate_release_notes`, release-please, changesets, semantic-release. If so, the changelog should describe that flow rather than duplicate it, or point to the release page. Ask which the team prefers.

Every reference to these docs (definition of done, PR template, `update-docs` command, code-review rule) must use the paths that actually exist in this repo. Never a hard-coded `ROADMAP.md` or `CHANGELOG.md`.

## How they work together

1. **Roadmap**: work starts as an item under "Next up" or "Later". Undecided topics (licensing, naming, pricing) go under "Discussion".
2. **When an item is finished**, it leaves the roadmap. It then shows up as:
   - a status table row, if it's a user-visible capability;
   - a changelog line under `[Unreleased]`, if it's a user-facing change;
   - a decision log entry, if it involved a non-obvious choice.
3. **At release**, `[Unreleased]` becomes the version heading.

## Templates

### README status section

```markdown
## Status

| Area | State |
|---|---|
| <capability, in user terms> | Done |
| <capability> | In progress: <what's left> |
| <capability> | Planned ([roadmap](docs/roadmap.md)) |
```

Use the words Done / In progress / Planned / Idea. Keep a repo's existing symbols if it already uses them.

### docs/roadmap.md

```markdown
# Roadmap

What's waiting, roughly in priority order. Finished items leave this file: user-visible ones go to the README status table and CHANGELOG.md, and non-obvious choices go to the decision log. Newest items at the bottom of each section.

## Next up

- **<Item>.** <One or two sentences: what and why.>

## Later

- **<Item>.** <...>

## Discussion

Undecided questions that need a person's call (licensing, naming, pricing, public/private, architecture forks).

- **<Topic>.** <Options and what each implies.>
```

### CHANGELOG.md (Keep a Changelog format)

```markdown
# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/) <or the project's scheme>.

## [Unreleased]

### Added
### Changed
### Fixed
### Removed
```

Keep only the subsections that have entries. Write entries for users, not developers: "Search now finds browser tabs", not "refactor omni module".

### docs/decisions.md (single log)

```markdown
# Decisions

Non-obvious choices and why we made them. Newest at the bottom. Each entry: the decision, the date, the reason, and what was rejected.

- **<Decision> (<YYYY-MM-DD>):** <What we chose and why. What we rejected and why.>
```

### docs/adr/NNNN-title.md (ADR)

```markdown
# NNNN. <Title>

- Status: Proposed | Accepted | Superseded by NNNN
- Date: <YYYY-MM-DD>

## Context
## Decision
## Consequences
```

### docs/releasing.md (outline)

```markdown
# Releasing

## Cutting a release
<Exact steps: version bump, tag, what CI does. Taken from the release workflow.>

## What users get
<Installer, package, update mechanism; where user data lives and whether updates touch it.>

## Distribution
<Package managers, stores, signing. TODO(verify) anything not yet set up.>
```

### AGENTS.md section

```markdown
## Project memory (update every session)

Before you finish a piece of work, update the docs it touched:
- the status table in `README.md` when a capability lands or changes state;
- `<roadmap path>`: remove finished items, add anything deferred or requested for later;
- `<changelog path>`, under `[Unreleased]`, for user-facing changes;
- `<decision log path>` for any non-obvious choice.
```
