---
name: repo-bootstrap
description: "Sets up or audits a repository for AI coding agents (GitHub Copilot in VS Code, Claude Code, or both). Every run starts by auditing what exists, so re-running it refreshes a repo. Reads the repo and the user's environment (agents, OS, git platform), then plans and writes AGENTS.md, agent rules, skills and agents, project docs (README status table, roadmap, changelog, decision log), .gitignore, CONTRIBUTING.md, personal git-ignored notes, and optional repository settings (groups, branch rules, CODEOWNERS, labels, security). Works on empty repos too. Use when asked to bootstrap, set up, initialize, onboard, audit or refresh a repo for AI agents."
disable-model-invocation: true
---

# Repo Bootstrap

Analyze the current repository and the person running this, work out what AI setup already exists, and create only what is missing. Everything written into the repo must come from what is actually in it. Personal and machine-specific facts never go into shared files.

## How a run works

There's one flow for every repo:
- **New or empty repo:** the audit finds little, so the interview does more of the work.
- **Already set up:** the audit finds drift, so the plan is mostly fixes.
- **Audit only** (the user says "audit", "check" or "refresh"): run Phases 0-3, present the findings and plan, and stop there unless asked to continue.

**Track progress visibly.** At the start, create a todo list with the agent's built-in todo tool, one item per phase (Claude Code's task list, Copilot's todo list), and tick each off as it finishes. If no such tool exists, print the checklist at each phase change.

## Hard rules

1. **Plan first, write second.** Complete Phases 0-3, present the plan, and STOP until the user approves. Create no files and change no settings before approval.
2. **Never overwrite or delete.** If a target exists, propose additions as a diff in the plan. Don't rename or migrate legacy files without approval.
3. **Ground everything.** Every command, path, version and convention must come from a file you read or a command you ran. If you can't determine something, write `TODO(verify): <question>` instead of guessing.
4. **One source of truth, no CLAUDE.md.** `AGENTS.md` holds the shared project facts, and every agent reads it directly, Claude Code included. Don't create `CLAUDE.md` or `CLAUDE.local.md`: either one makes Claude Code stop reading `AGENTS.md`. Claude-specific notes go in `.claude/rules/`. Other files point to `AGENTS.md` or add tool-specific, path-specific or personal detail; don't copy the same content into several files.
5. **Shared vs. personal.** Facts about the project go in committed files. Facts about one person or one machine (OS quirks, local paths, preferences, credentials locations) go in the `.local` files or user-level files described in `references/environment.md`. Never the other way round.
6. **Stay lean.** Size budgets:
   - `AGENTS.md` <= 150 lines
   - `copilot-instructions.md` <= 40 lines
   - each rule <= 60 lines; each skill the user calls <= 40 lines; each agent <= 80 lines
   - each `SKILL.md` <= 300 lines, with the rest in `references/`
7. **No secrets.** Never write credentials, tokens, keys, connection strings or vault contents. Point to where secrets come from instead (Key Vault, variable group, env var name, vault file name).
8. **No emojis** in generated files. Exception: a status table may keep the symbols a repo already uses. New status tables use words: Done, In progress, Planned, Idea.
9. **Platform changes are shared changes.** Repository settings, teams, branch policies and labels affect other people. List each one with its exact command in the plan, apply only the approved ones, check whether each already exists first, and never delete or loosen an existing setting.
10. **CLI syntax drifts.** Before running any `gh`, `az` or `glab` command you haven't run in this session, confirm its flags with `--help`.

## Gotchas

- `/init` always creates a `CLAUDE.md`, which silently stops Claude Code reading `AGENTS.md`. Flag one that appears.
- `*.local.md` does not match `personal.local.instructions.md`; the `.gitignore` block needs its own line for it.
- A new `.gitignore` entry can match files already committed, and git keeps tracking those. Check with `git ls-files -ci --exclude-standard`.
- Copilot can't import other files, so a note both agents need lives in both personal files.
- GitHub teams exist only in organizations; on a personal account use collaborators. Branch rules on private repos need a paid plan.
- Azure DevOps has no CLI command for environment approvals; list them as manual steps.
- VS Code workspace settings are committed; personal VS Code settings go in user settings.

## References

Read the matching file before the phase that needs it:

| File | Use it for |
|---|---|
| `references/environment.md` | Phase 0: detecting agents, OS and shell; the personal `.local` file system; `.worktreeinclude`; user-level files |
| `references/stack-signals.md` | Phase 2: recognising the stack and its commands, with a fallback for unknown stacks |
| `references/memory-docs.md` | Phases 2 and 4: README status table, roadmap, changelog, decision log, releasing doc |
| `references/special-files.md` | Phase 2: files that platforms treat specially (README, LICENSE, CODEOWNERS...) |
| `references/templates.md` | Phase 4: which skills, agents and rules to include, and templates for every generated file |
| `references/platform-github.md` | Phase 5 when the remote is GitHub |
| `references/platform-azure-devops.md` | Phase 5 when the remote is Azure DevOps |
| `references/platform-other.md` | Phase 5 for GitLab, Bitbucket, or no remote |
| `references/standards.md` | Phase 3: default standards (repository settings, contributing, files every repo gets). Each section is proposed once, then saved to the user's personal copy at `~/.agents/repo-bootstrap/standards.md` |
| `references/local-notes.md` | Recording personal or machine-specific notes in the right git-ignored or user-level file |

## Phase 0 - Read the environment

Follow `references/environment.md`. Record, privately:

- **Agents in use**: Claude Code, Copilot in VS Code, Copilot on github.com, others. This sets the harness target (below). Ask only if detection is ambiguous.
- **OS, shell, and installed CLIs** (`git`, `gh`, `az` with the `azure-devops` extension, `glab`).
- **Git platform**: from `git remote -v`. GitHub, Azure DevOps (`dev.azure.com`, `*.visualstudio.com`), GitLab, Bitbucket, other, or none. For GitHub, whether the owner is a user or an organization.
- **The user's standards**: read `~/.agents/repo-bootstrap/standards.md` if it exists. Any section it lacks is proposed from the defaults in Phase 3, when that section is needed.
- **Whether the user's standing preferences exist at user level** (`~/.claude/CLAUDE.md`, `~/.copilot/instructions/`). If not, offer to create them in Phase 3; never put them in the repo.

### Harness target

| Concept | Copilot only | Claude Code only | Both |
|---|---|---|---|
| Shared facts | `AGENTS.md` | `AGENTS.md` | `AGENTS.md` |
| Tool-specific notes | `.github/copilot-instructions.md` | `.claude/rules/claude.md` | both |
| Path rules | `.github/instructions/<name>.instructions.md` | `.claude/rules/<name>.md` | `.claude/rules/` (VS Code reads it) |
| Skills (including ones the user calls as `/name`) | `.github/skills/<name>/SKILL.md` | `.claude/skills/<name>/SKILL.md` | `.claude/skills/` (both read it) |
| Agents | `.github/agents/<name>.agent.md` | `.claude/agents/<name>.md` | `.claude/agents/` (VS Code reads it) |
| Personal notes | `.github/instructions/personal.local.instructions.md` | `.claude/rules/personal.local.md` | both, kept in sync (`references/local-notes.md`) |

- **No `CLAUDE.md`** (hard rule 4). Files in `.claude/rules/` don't count and keep loading alongside `AGENTS.md`, so Claude-only notes go there.
  - If `CLAUDE.md` already exists, propose moving its shared content into `AGENTS.md` and deleting it, only with approval. Keeping it as a one-line `@AGENTS.md` import is the fallback.
  - People who want both files read can set Claude Code's "Project instructions" to `claude-md-and-agents-md` in their own settings. That's a personal setting; never set it in the repo.
- **Slash commands are skills now.** Both agents list skills in the `/` menu, so there are no separate command or prompt files. A skill that should only run when called gets `disable-model-invocation: true`. Existing `.claude/commands/` and `.github/prompts/` files keep working; leave them unless the user wants them converted.
- **Copilot on github.com** (coding agent, code review) reads `AGENTS.md` and `.github/` files, not `.claude/`. If the user uses those features, also write the `.github/` versions of rules and agents, each starting with `<!-- Mirror of <source path>. Edit the source, then re-sync. -->`.

## Phase 1 - Audit what exists

Every run starts here. Record each as exists / missing / empty / stale:

- `AGENTS.md` (root and nested), `CLAUDE.md`, `CLAUDE.local.md`, `.claude/CLAUDE.md`
- `.github/copilot-instructions.md`, `.github/instructions/**`, `.github/prompts/**`, `.github/agents/**`, `.github/skills/**`
- `.claude/rules/**`, `.claude/commands/**` (older form of skills), `.claude/agents/**`, `.claude/skills/**`, `.claude/settings.json`, `.claude/settings.local.json`, `.agents/skills/**`
- Legacy or other-tool files: `.github/chatmodes/*.chatmode.md`, `.cursorrules`, `.cursor/rules/**`, `.windsurfrules`, `GEMINI.md`
- Tool config: `.vscode/settings.json` (any `chat.*` keys), `.vscode/mcp.json`, `.mcp.json`
- `README.md`: exists? Does it say what the project is, how to install or run it, and where the other docs are? Are its commands still real?
- Project memory: see the detection list in `references/memory-docs.md`
- `.gitignore`: does it exist, and are the `.local` patterns present? (`references/environment.md`)
- `.worktreeinclude`: does it list the personal `.local` files? (`references/environment.md`)

Legacy files are source material. Read them and reuse their facts, but don't modify them.

If a setup already exists, also check for drift:

- Commands in `AGENTS.md` that no longer exist in build files, task runners or pipelines
- Globs that match zero files; references to deleted paths
- Rules that restate what a linter already enforces
- Files over their size budgets; mirrors that no longer match their source
- Stale memory docs:
  - roadmap items that are already done;
  - a status table that disagrees with the code;
  - changes since the last release missing from the changelog;
  - decisions referenced in code but absent from the log
- Personal or machine-specific facts that leaked into committed files
- A `CLAUDE.md` or `CLAUDE.local.md` that appeared (often from `/init`), which silently stops Claude Code reading `AGENTS.md`
- Platform settings that drifted from the user's standards

Drift fixes go into the Phase 3 plan as diffs.

## Phase 2 - Analyze the repository

Build a private repo profile (keep it in context; don't write it to the repo):

- **Stack and canonical commands** from `references/stack-signals.md`. For a stack that isn't listed, use its fallback procedure.
- **Top-level directory map** (depth 2), one line of purpose per directory.
- **Build, test, lint, format, run and deploy commands**, copied exactly.
- **Environments**: dev/test/prod folders, config files, pipeline stages.
- **Conventions** sampled from 3-5 representative files per language: naming, layout, error handling, logging.
- **Commit style** from `git log --oneline -30`.
- **Never-touch paths**: generated code, vendored dirs, state files, build output, lockfiles, production inventories.
- **Project memory docs** that already exist, wherever they live (`references/memory-docs.md`).
- **Special files** present or missing (`references/special-files.md`). For public repos, or repos that take outside contributions, offer `CONTRIBUTING.md` (drafted and reviewed with the user in Phase 3) and `SECURITY.md` (templates in `references/templates.md`).

**New or empty repo.** With little to read, ask instead:
- what it will be and who uses it;
- the planned language and tools;
- whether it will build, test, deploy or ship.

Write `AGENTS.md` from the answers. Commands that don't exist yet become `TODO(verify)` lines for the next run to fill in.

Then interview the user for what files can't show. Ask one topic at a time, each with a one-line explainer and a default:

1. **Architecture rules**: what must never happen, and why (layering, dependency limits, where unsafe or privileged code may live).
2. **Compatibility contracts**: does anything persist or get published (file formats, IDs, APIs, CLI flags) that must not break?
3. **Project memory**: which of README status table, roadmap, changelog and decision log they want, and single decision log vs. ADRs. Defaults are in `references/memory-docs.md`.
4. **Build, deploy, ship?** Only if the project has something to build, test or lint does it get a CI workflow (and only if it has none yet). Only if it deploys or ships does it get a deployment or release pipeline and `docs/releasing.md`. Docs-only, notes or config-only repos get no pipeline.
5. **Repository settings?** Should this run also set up groups, branch rules, CODEOWNERS, labels and security on the git platform? These affect everyone on the repo. Default: no. Phase 5 runs only on a yes.

## Phase 3 - Plan and confirm

Present:

1. A short profile: stack, commands, CI, environments, platform, harness target.
2. A plan table covering every file and every platform change:

| Path or setting | Action | Why | Evidence |
|---|---|---|---|
| `AGENTS.md` | create / propose-merge / skip | ... | files that justify it |
| GitHub: team `<repo>-maintainers` | create | user's standards | `gh` org owner |

3. Open questions, plus every `TODO(verify)`.

**The user's standards.** `references/standards.md` holds the defaults, in sections: repository settings (needed when Phase 5 is in scope), contributing (needed when `CONTRIBUTING.md` is in the plan), and files every repo gets. For each section this run needs that `~/.agents/repo-bootstrap/standards.md` doesn't have yet:
1. Propose the defaults as a short summary.
2. Ask whether to accept them as they are, or what to change.
3. Once agreed, add that section to `~/.agents/repo-bootstrap/standards.md`, creating the file if needed. That's the user's own copy: every later run, in any repo, uses it without asking, and updates to this skill never overwrite it.

Sections already saved are used as they are; say so in one line. A team can share one copy by committing it to a repo and pointing to it from the personal file.

**CONTRIBUTING.md.** If it's in the plan, show the draft filled from the repo (template in `references/templates.md`, choices from the user's contributing standards) and ask what to change before writing it.

Then STOP. Apply requested changes to the plan and confirm again.

## Phase 4 - Generate files

Create in this order, because later files reference earlier ones:

1. `AGENTS.md`
2. `.github/copilot-instructions.md`
3. Project memory docs
4. `README.md`: create it if missing (template in `references/templates.md`); otherwise propose only the missing sections as a diff, keeping the existing text and style
5. Rules (including `.claude/rules/claude.md` if there are Claude-only notes)
6. Skills
7. Agents
8. CI / CD workflow, only if Phase 2 found it applies
9. `.gitignore`: create it if it's missing, with the entries the stack needs (template in `references/templates.md`); otherwise add only what's missing. Either way it gets the local-files block.
10. Personal `.local` files, only for the person running this, with their consent
11. `.worktreeinclude`, if the target includes Claude Code and step 10 created a personal file; if it exists, add only the missing lines (`references/environment.md`)


### What goes where

- **AGENTS.md**: project facts every agent needs.
  - purpose, directory map, exact commands, environments;
  - conventions not enforced by tooling, architecture rules with reasons, compatibility contracts;
  - boundaries, definition of done;
  - the project memory section, the local-notes rule.
- **README.md**: for people. What it is, how to install and use it, the status table, and links to the other docs. Agent-only detail (conventions, boundaries) stays in `AGENTS.md`.
- **copilot-instructions.md**: only Copilot-specific behaviour, plus a line pointing to `AGENTS.md`.
- **rules**: path-scoped conventions, one file per language or tool. Each glob MUST match at least one real file. Max 6 on first run.
- **skills the user calls** (`/name`, with `disable-model-invocation: true`): one-shot tasks such as `/plan` or `/review`. Max 6 on first run.
- **skills the agent loads on its own**: multi-step procedures it should pick up when relevant, especially with scripts or reference files. Max 3 on first run.
- **agents**: personas with a scoped tool set. Max 4 on first run.

### What to include

Pick which skills, agents and rules to generate with the selection tables at the top of `references/templates.md`.

## Phase 5 - Configure the git platform (optional)

Only if the user said yes to repository settings (Phase 2, question 5) and approved the items in Phase 3. Follow the matching platform reference and the user's standards.

- Dry run first: list what exists vs. what would change.
- Apply one approved item at a time, and stop on the first error.
- Record what was applied in the decision log, with the date.

## Phase 6 - Validate

Check before reporting. Fix anything that fails, then run the whole checklist again; report only when every item passes or is listed as a `TODO(verify)`.

- [ ] Every frontmatter block parses as YAML and has the required fields.
- [ ] Skill `name` is lowercase-hyphenated and matches its folder.
- [ ] Every `applyTo` / `paths` glob matches at least one existing file.
- [ ] Every command and path mentioned exists, or is marked `TODO(verify)`.
- [ ] No content is duplicated between `AGENTS.md` and other files.
- [ ] Size budgets are respected.
- [ ] No secrets or credentials; no personal or machine-specific facts in committed files.
- [ ] `.gitignore` exists and covers every `.local` file created; `git status` doesn't list them.
- [ ] `git ls-files -ci --exclude-standard` lists no committed files that the new `.gitignore` entries would hide.
- [ ] `.claude/rules/personal.local.md` and `.claude/settings.local.json`, where they exist, are listed in `.worktreeinclude`.
- [ ] No `CLAUDE.md` or `CLAUDE.local.md` was created (unless the user chose the shim fallback).
- [ ] The definition of done names memory docs that actually exist.
- [ ] No existing file or setting was modified without approval.

## Phase 7 - Report

1. A table of created files, merge proposals, skipped files, and applied platform settings.
2. All `TODO(verify)` items, grouped by file.
3. Suggested commit message: `chore(ai): bootstrap agent instructions and project docs`. Don't commit unless asked.
4. How to test: open Chat, run `/plan` on a small task, and check in the chat references that `AGENTS.md` and the matching rule loaded.
5. Anything the user should do by hand (e.g. add members to new teams).

