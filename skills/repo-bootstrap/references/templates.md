# Templates

Only use a template for a file that passed the evidence gate. Fill every `<placeholder>` from the repo or the interview. Delete sections that don't apply rather than leaving empty headings. Use `TODO(verify): ...` for unknowns.

Tool names in `tools:` lists change between releases. Confirm them in the tools picker, or leave `tools:` out rather than guess.

Project memory doc templates (status table, roadmap, changelog, decision log, releasing) are in `memory-docs.md`. Personal `.local` file templates are in `environment.md`. Platform settings are in the `platform-*.md` files.

## Contents

- Choosing what to generate: which skills, agents and rules to include
- Agent files: `AGENTS.md`, `.claude/rules/claude.md`, `.github/copilot-instructions.md`, rules, skills the user calls, the `update-docs` skill body, agents, skills
- Copilot on github.com: `copilot-setup-steps.yml`, code-review instructions, agent-task issue form
- Repo files: `README.md`, pull request template, `.gitignore`, `.gitattributes`, `.editorconfig`, `SECURITY.md`, `CONTRIBUTING.md`


## Choosing what to generate

Skills the user calls (include when the signal exists):

| Skill | Include when |
|---|---|
| `plan` | Always. Produces an implementation plan without editing. |
| `review` | Always. Reviews the current diff against `AGENTS.md`, its architecture rules, and the relevant path rules. |
| `update-docs` | Any project memory doc exists. Brings the status table, roadmap, changelog and decision log up to date with the work just done. |
| `pr-description` | Git repo. Drafts a PR description from the diff and commit log. |
| `test` | A test command exists. Runs tests and triages failures. |
| `release` | `docs/releasing.md` exists. Walks the documented release steps without pushing. |
| `adr` | ADRs chosen. Drafts an ADR from the template. |

Agents:

| Agent | Include when | Tools |
|---|---|---|
| `planner` | Always | Read-only (search/read/web). Hands off to the default agent to implement. |
| `reviewer` | Always | Read-only. Loads the architecture rules and compatibility contracts first. |
| `docs` | README or `docs/` exists | Read, plus edits limited to `*.md` and `docs/**` |
| Domain agent | A dominant stack with complex conventions, or repeatable content work (data files, plugins, adapters) | Full; loads the matching rules and skills |

Skills the agent loads on its own (only if the repo has the underlying workflow):

- `<stack>-module-scaffold`: the repo has modules, roles or plugins with a repeatable structure. Base the template on an existing one.
- `pipeline-debugging`: CI config exists. How to read failed runs, and common failures seen in the pipeline files.
- `repo-docs`: generates or refreshes a dependency inventory and a Mermaid architecture diagram.

---

## AGENTS.md

````markdown
# <Repo name>

<One or two sentences: what this repo does and who uses it.>

## Layout

| Path | Purpose |
|---|---|
| `<dir>/` | <purpose> |

## Commands

Run these from the repo root.

| Task | Command |
|---|---|
| Setup | `<exact command>` |
| Lint / format | `<exact command>` |
| Test / validate | `<exact command>` |
| Build / plan | `<exact command>` |
| Run | `<exact command>` |

## Environments

<Which environments exist, where they're defined, and how to select one. Agents never deploy to production.>

## Architecture rules

<Rules that must hold, each with its reason. From the interview; delete if there are none.>
- <Rule>. <Why.>

## Compatibility contracts

<What persists or is published and must not break: file formats, IDs, APIs, flags. How to change one safely (migration, version bump). Delete if none.>

## Conventions

<Only conventions that linters and formatters do NOT already enforce. One line each.>

## Boundaries

Don't edit:
- `<generated / vendored / state / build output / lock paths>`

Ask before:
- Adding dependencies, providers or collections
- Changing CI/CD workflows or repository settings
- Touching production config
- Committing or pushing
- Creating `CLAUDE.md` or `CLAUDE.local.md` (either one stops Claude Code reading this file; use `.claude/rules/` instead)

## Project memory (update every session)

Before you finish a piece of work, update the docs it touched:
- the status table in `README.md` when a capability lands or changes state;
- `<roadmap path>`: remove finished items, add anything deferred or requested for later;
- `<changelog path>`, under `[Unreleased]`, for user-facing changes;
- `<decision log path>` for any non-obvious choice.

## Local notes

Personal and machine-specific notes live in git-ignored files: `.claude/rules/personal.local.md` (Claude Code) and `.github/instructions/personal.local.instructions.md` (Copilot). When you learn something true only for this person or this machine (an OS quirk, a local path, a tool version, a preference), add it to whichever of those the person's agents read, never to this file. One bullet each, written as an instruction, with the reason. Check `git status` doesn't list the file, and never record secrets.

## Definition of done

- `<lint command>` passes
- `<test/validate command>` passes
- The project memory docs above are updated
- Secrets come from <source>, never from code
````

---

## Claude-only notes: .claude/rules/claude.md

Only if there's something that applies to Claude Code and not to other agents. No frontmatter, so it always loads.

````markdown
# Claude Code notes

<Claude-only notes, e.g. what does and doesn't work in cloud sessions.>
````

Don't create `CLAUDE.md`: Claude Code reads `AGENTS.md` directly, and a `CLAUDE.md` (or `CLAUDE.local.md`) would stop that. Personal notes go in `.claude/rules/personal.local.md` (see `environment.md`).

---

## .github/copilot-instructions.md

````markdown
# Copilot instructions

Project facts, commands and boundaries are in [AGENTS.md](../AGENTS.md). Follow them.

## Copilot-specific

- <Only guidance that applies to Copilot and not to other agents.>
````

---

## Rule: .github/instructions/<name>.instructions.md

````markdown
---
applyTo: "<glob that matches real files>"
description: "<When this applies, in one line>"
# excludeAgent: "code-review"  # or "coding-agent"; leave out to apply to all agents
---

# <Topic> conventions

- <Convention observed in the repo or stated in the interview>

Reference example: `<path to a representative file>`
````

Claude version at `.claude/rules/<name>.md`: use `paths:` (a YAML list) instead of `applyTo`, and keep the same body. Add the mirror comment only if both copies exist.

---

## Skill the user calls: .claude/skills/<name>/SKILL.md

Slash commands are skills that only run when called. Copilot-only repos use `.github/skills/<name>/SKILL.md`. Older `.github/prompts/*.prompt.md` and `.claude/commands/*.md` files still work, but don't create new ones.

````markdown
---
name: <name>
description: "<What /name does, in one line>"
disable-model-invocation: true
argument-hint: "<what to pass>"
---

<Task. Link files with Markdown links, for example [AGENTS.md](../../../AGENTS.md). The input is $ARGUMENTS.>

Output format:
- <Exact shape of the answer>
````

---

## Skill body: update-docs

````markdown
Bring the project memory docs up to date with the work in this session (or with the current diff, if this is a fresh session).

1. Read the diff (`git diff` and `git diff --staged`) and the recent commits.
2. README status table: add or change rows for capabilities that landed or changed state.
3. <roadmap path>: remove finished items; add anything deferred or requested for later.
4. <changelog path>: add user-facing changes under [Unreleased], written for users.
5. <decision log path>: add an entry for each non-obvious choice, with the date and what was rejected.
6. If you learned anything personal or machine-specific, put it in the local notes files, not here.

Show the doc changes as a diff summary. Don't commit.
````

---

## Agent: .github/agents/<name>.agent.md

````markdown
---
name: <name>
description: "<Role, and when to pick this agent, in one line>"
tools: ['<confirm names in the tools picker>']
handoffs:
  - label: <Next step>
    agent: agent
    prompt: <Handoff prompt>
    send: false
---

# <Name>

You are the <role> for this repo. Follow [AGENTS.md](../../AGENTS.md).

## Do
- <responsibility>

## Do not
- <limit>

## Output
<Exact format>
````

Claude version at `.claude/agents/<name>.md`: frontmatter is `name`, `description`, `tools: Read, Grep, Glob` (as a comma list) and `model: inherit`. Drop `handoffs`.

The `reviewer` agent's "Do" list always starts with: check the change against the Architecture rules and Compatibility contracts in AGENTS.md first, and report each violation with the file and line.

---

## Skill: .claude/skills/<name>/SKILL.md

````markdown
---
name: <name-matching-folder>
description: "<What it does AND when to use it, including trigger words. This is the only part loaded until the skill runs.>"
# disable-model-invocation: true  # add for anything with side effects, so it only runs when called
---

# <Title>

## When to use
<Triggers>

## Procedure
1. <Step, referencing scripts/ or references/ files by relative path>

## Checks
- <How to verify the result>
````

---

## .github/workflows/copilot-setup-steps.yml

Only if the Copilot coding agent on github.com is used.

````yaml
name: "Copilot Setup Steps"

on:
  workflow_dispatch:
  push:
    paths: [.github/workflows/copilot-setup-steps.yml]
  pull_request:
    paths: [.github/workflows/copilot-setup-steps.yml]

jobs:
  copilot-setup-steps:          # the job name must be exactly this
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v5
      # Install only what the AGENTS.md commands need, pinned to the repo's own versions.
````

---

## .github/instructions/code-review.instructions.md

````markdown
---
applyTo: "**"
excludeAgent: "coding-agent"
description: "Review criteria for Copilot code review"
---

# Review checklist

- Flag changes that break the Architecture rules or Compatibility contracts in AGENTS.md.
- Flag user-facing changes with no entry under [Unreleased] in <changelog path>.
- Flag finished work still listed in <roadmap path>.
- Flag hardcoded secrets, IP addresses, hostnames or subscription IDs.
- Flag personal or machine-specific notes added to committed files.
- <Stack-specific checks from the interview>

Keep comments short. Don't comment on anything that linters enforce.
````

---

## .github/ISSUE_TEMPLATE/agent-task.yml

````yaml
name: Agent task
description: A well-scoped task that can be assigned to an AI agent
labels: [agent-task, needs-triage]
body:
  - type: textarea
    id: goal
    attributes: { label: Goal }
    validations: { required: true }
  - type: textarea
    id: acceptance
    attributes: { label: Acceptance criteria }
    validations: { required: true }
  - type: textarea
    id: scope
    attributes: { label: In scope / off-limits }
  - type: textarea
    id: validation
    attributes: { label: How to validate }
````

---

## Pull request template

GitHub: `.github/pull_request_template.md`. Azure DevOps: `.azuredevops/pull_request_template.md`. GitLab: `.gitlab/merge_request_templates/Default.md`.

````markdown
## Summary

## Validation
- [ ] Lint / validate passes
- [ ] Tests pass

## Housekeeping
- [ ] AI assistance disclosed, if any was used (see CONTRIBUTING.md)
- [ ] <changelog path> updated under [Unreleased] (user-facing changes)
- [ ] <roadmap path> updated if this finishes or defers a roadmap item
- [ ] Decision log entry for any non-obvious choice
````

Delete the housekeeping lines for docs the repo doesn't have.

---

## .gitignore

Create it if it's missing; if it exists, add only the missing lines. Build each part from what Phase 2 found, never from a generic list: the dependency and build-output folders the stack's tools actually produce, env files the repo's config reads, and editor or OS files only if they could appear. For a known stack, GitHub's templates (https://github.com/github/gitignore) are a good starting point; keep only the lines that apply. An empty repo still gets the file, with just the local-files block and the OS lines.

````gitignore
# <Stack>: dependencies and build output
<e.g. node_modules/, dist/, bin/, obj/, .venv/, target/>

# Environment and secrets (examples, never the real values)
<e.g. .env, .env.*, !.env.example>

# OS and editor files
.DS_Store
Thumbs.db

<the local-files block from environment.md>
````

Then check that no committed file is now ignored: `git ls-files -ci --exclude-standard` must print nothing.

---

## .gitattributes

````gitattributes
* text=auto
*.png binary
*.jpg binary
*.ico binary
*.pdf binary
<other binary extensions found in the repo>
<*.sh text eol=lf, if shell scripts exist; *.ps1 text eol=crlf, if the team is on Windows>
````

## .editorconfig

Only if absent, and matching what the existing files already do (indent size, line endings, final newline), sampled in Phase 2:

````ini
root = true

[*]
charset = utf-8
end_of_line = <lf or crlf, matching the repo>
insert_final_newline = true
indent_style = <space or tab>
indent_size = <n>
````

## README.md

For people, not agents. Create it if missing; if it exists, propose only the missing sections and keep its voice. Install and run steps use the real commands from `AGENTS.md` (short here; the full list stays there). Delete sections that don't apply.

````markdown
# <Repo name>

<One or two sentences: what it is, who it's for, and what problem it solves.>

## Status

<Status table from memory-docs.md>

## Getting started

<Requirements, then the few steps to install or run it, with the exact commands.>

## Usage

<The most common task, with an example.>

## Project docs

- [Roadmap](<roadmap path>), [changelog](<changelog path>), [decision log](<decision log path>)
- [Contributing](CONTRIBUTING.md) <if it exists>
- Working with AI agents: see [AGENTS.md](AGENTS.md)

## License

<License name>, see [LICENSE](LICENSE). <If none was chosen: TODO(verify): license.>
````

---

## SECURITY.md

````markdown
# Security

Please don't open a public issue for security problems. Report them <privately via GitHub's "Report a vulnerability" button / to <contact>>. You'll get a reply within <n> days.
````

## CONTRIBUTING.md

Only for public repos, or private ones that take changes from people outside the core team. GitHub links this file when people open issues and pull requests; GitLab and Azure DevOps show it in the repo.

How to fill it:
- **Choices** (AI policy, which sections, tone) come from the contributing section of the user's standards (`standards.md`).
- **Facts** come from the repo:
  - where bugs and ideas go: check whether Discussions are on (`gh repo view --json hasDiscussionsEnabled`); without them, ideas go to issues with a label;
  - the license files (one license, or separate ones for code and docs);
  - the setup commands from `AGENTS.md`;
  - the repeatable work the repo invites (plugins, adapters, data files), each of which gets its own requirements.
- **Show the filled draft in Phase 3** and ask what to change before writing it.

Delete sections that don't apply. Each item under "Not accepting" needs a reason.

````markdown
# Contributing to <Repo name>

Thanks for helping. This explains what we accept, where each kind of contribution goes, and what it needs.

## Types of contributions

**Bug reports.** [Open an issue](<issues link>) with steps to reproduce, what you expected, and what happened.

**Ideas, questions and proposals.** [Start a discussion](<discussions link>); issues are for concrete problems. Proposals should come from a real problem you hit: show the problem and how your change solves it. <If the project keeps a high bar for new features, say why: every addition is something everyone must maintain.>

**Documentation fixes** (typos, clearer wording, better examples) are always welcome as pull requests.

**<Repeatable contribution, e.g. a new plugin>.** <What it needs: files to add or edit, naming, tests, assets with their formats and sizes, and any condition such as "must be publicly available".>

**Security problems:** don't open an issue; see [SECURITY.md](SECURITY.md).

## Not accepting right now

- <Kind of contribution>: <why, e.g. "the core format is still changing">

For anything large, ask in a discussion before putting in a lot of work.

## Getting set up

```sh
<the one or two commands that get a working copy running, from AGENTS.md>
```

<Where to see the result, if there is one, e.g. "then open http://localhost:<port>".> The full list of build, test and lint commands is in [AGENTS.md](AGENTS.md#commands).

## Submitting changes

1. Fork the repo and create a branch for one focused change.
2. Check it works locally: <lint command> and <test command> pass.
3. Open a pull request, link the related issue, and fill in the template, including <changelog path> for user-facing changes.

## AI-assisted contributions

AI tools are welcome, but if you used one (Claude Code, Copilot, ChatGPT or similar) you must say so in the pull request or issue, and how much: for example "written mostly by Claude Code" or "I asked an AI to explain the code, but wrote the fix myself". Trivial typo or spacing fixes don't need it. The same applies if an AI writes your replies to review comments.

We also ask that you:
- understand what your change does and can explain why it's needed;
- include tests, examples or steps that show it works.

We may close contributions that don't disclose AI use, because reviewers need to know how closely to check them.

## License

By contributing, you agree that your contributions are licensed under the project's [license](LICENSE).
<Separate licenses: "Code is licensed under <license> ([LICENSE](LICENSE)); documentation under <license> ([LICENSE-docs](<path>))." Use the files that exist.>
````
