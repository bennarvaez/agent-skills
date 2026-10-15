# Environment: agents, machine, and personal files

Two kinds of facts never belong in shared repo files:

- **Personal**: one person's preferences, working style, local paths.
- **Machine**: one computer's OS, shell, toolchain quirks, crashes, workarounds.

This file explains how to detect them and where they go, so person 2 never inherits person 1's setup.

## Contents

- Detecting agents; detecting the machine
- Where each kind of fact goes
- The .gitignore block (the one copy; other files point here)
- The .worktreeinclude file (personal files in Claude Code worktrees)
- The Local notes section in AGENTS.md; template for the personal notes file
- Standing preferences (user level); optional session-start nudge

## Detecting agents

| Check | Means |
|---|---|
| `~/.claude/` exists, or `claude --version` works | Claude Code is installed |
| `.claude/` or `CLAUDE.md` in the repo | The team uses Claude Code |
| VS Code user settings contain `github.copilot` or `chat.` keys; `~/.copilot/` exists | Copilot in VS Code |
| `.github/copilot-instructions.md`, `.github/agents/`, `copilot-setup-steps.yml` | The team uses Copilot (maybe on github.com) |
| `.cursor/`, `.windsurfrules`, `GEMINI.md` | Other agents also read this repo; `AGENTS.md` covers most of them |

VS Code user settings location: Windows `%APPDATA%\Code\User\settings.json`; macOS `~/Library/Application Support/Code/User/settings.json`; Linux `~/.config/Code/User/settings.json`.

Default harness target: `both` if Claude Code is installed or used by the repo, otherwise `copilot`. Ask only when the person's install and the repo disagree.

## Detecting the machine

| Fact | How |
|---|---|
| OS | `uname -s` (MINGW/MSYS = Windows with Git Bash), or `$env:OS` / `$PSVersionTable` in PowerShell |
| Shell | The agent's own shell tool, `$SHELL`, or `$PSVersionTable.PSVersion` |
| CLIs | `git --version`, `gh --version` and `gh auth status`, `az --version` and `az extension show -n azure-devops`, `glab --version` |
| Toolchain | Versions of the stack's tools (`node -v`, `python --version`, `cargo -V`, `dotnet --version`...) compared with the repo's pins |

Note any mismatch (a missing CLI, a toolchain older than the repo's pin) for the person's local file, not for `AGENTS.md`.

## Where each kind of fact goes

| Scope | Claude Code | Copilot in VS Code | Committed? |
|---|---|---|---|
| Whole team, this repo | `AGENTS.md` | `AGENTS.md` | Yes |
| Me, this repo, this machine | `.claude/rules/personal.local.md` | `.github/instructions/personal.local.instructions.md` (`applyTo: "**"`) | No, git-ignored |
| Me, this repo, permissions | `.claude/settings.local.json` | VS Code workspace settings are shared, so use user settings instead | No |
| Me, every repo | `~/.claude/CLAUDE.md`, `~/.claude/rules/*.md` | `~/.copilot/copilot-instructions.md`, `~/.copilot/instructions/*.instructions.md` | n/a (home folder) |
| My skills, every repo | `~/.claude/skills/` | `~/.copilot/skills/`, `~/.claude/skills/`, `~/.agents/skills/` | n/a |

**Why not `CLAUDE.local.md`?** It counts as a `CLAUDE.md` file, so having one stops Claude Code reading `AGENTS.md`. Files in `.claude/rules/` don't count, so Claude's personal notes go in `.claude/rules/personal.local.md` (no frontmatter, so it always loads).

**Both agents:** Copilot can't import another file, so when the target is `both` the same notes live in two personal files, `.claude/rules/personal.local.md` and `.github/instructions/personal.local.instructions.md`. Whoever records a note writes it to both (`local-notes.md`).
- `TODO(verify)`: VS Code 1.109+ reads `.claude/` folders. If chat references show it loading `.claude/rules/personal.local.md`, the Copilot copy is unnecessary.

**Personal setting alternative:** someone who prefers `CLAUDE.local.md` can set Claude Code's "Project instructions" to `claude-md-and-agents-md`, which makes Claude read both. The easy way is `/config` in a session. In a file, it goes in `~/.claude/settings.json` as `"pluginConfigs": { "agents-md@builtin": { "options": { "instructionFiles": "claude-md-and-agents-md" } } }`. Claude Code ignores this setting in the repo's `.claude/settings.json` and `settings.local.json`, so it can only ever be personal.

**Machine facts that apply to every repo** (e.g. "this PC crashes under parallel builds", "use PowerShell syntax") go in the user-level files, not per repo.

## The .gitignore block

Add this once to the repo's `.gitignore`, with approval. It's shared, harmless to people without these files, and protects everyone:

```gitignore
# Personal, per-machine agent files (see AGENTS.md "Local notes")
*.local.md
*.local.json
.github/instructions/*.local.instructions.md
.claude/settings.local.json
.claude/worktrees/
.claude/agent-memory-local/
# Keeps Claude Code reading AGENTS.md (see AGENTS.md "Local notes")
CLAUDE.local.md
```

If the person may not edit the shared `.gitignore`, use the personal ignore file `.git/info/exclude` instead (same syntax, never committed). After writing local files, check that `git status` doesn't list them.

`.claude/agent-memory-local/` is where a subagent with `memory: local` keeps its notes. The generated agents don't use it; the line is there so any that do later stay out of git.

## The .worktreeinclude file

Claude Code worktrees (`claude --worktree`, subagents with `isolation: worktree`) are fresh checkouts, so they get every committed file but none of the git-ignored ones. Without this file, Claude in a worktree silently loses the person's local notes and permissions. `.worktreeinclude` sits at the repo root, is committed, and uses `.gitignore` syntax; Claude Code copies matching git-ignored files from the main checkout into each new worktree. Files that don't exist or aren't ignored are skipped, so it's harmless for teammates. Copilot doesn't use it.

Create it when the harness target includes Claude Code and a personal `.local` file is created; if it exists, add only the missing lines:

```gitignore
# Personal files Claude Code needs in every worktree (see AGENTS.md "Local notes")
.claude/rules/personal.local.md
.claude/settings.local.json
```

If Phase 2 found git-ignored env files the app needs to run (for example `.env`), propose adding them too; they're copied locally, never committed.

## The Local notes section in AGENTS.md

Every generated `AGENTS.md` gets this section, so all agents know the system and keep it up to date:

```markdown
## Local notes

Personal and machine-specific notes live in git-ignored files: `.claude/rules/personal.local.md` (Claude Code) and `.github/instructions/personal.local.instructions.md` (Copilot). When you learn something true only for this person or this machine (an OS quirk, a local path, a tool version, a preference), add it there, not to this file.
```

## Template: personal.local.instructions.md

```markdown
---
applyTo: "**"
description: "Personal notes for <name> on <machine>. Not committed."
---

# Local notes (<name>, <OS>, <shell>)

<!-- Git-ignored. Facts true only for this person or this machine. Agents may add to this file. -->

## Machine
- OS / shell: <detected>
- Toolchain: <detected versions, and any mismatch with the repo's pins>
- Quirks: <e.g. builds crash under parallel load; use -j 2>

## Preferences for this repo
- <e.g. run the app with the dev profile>
```

## Standing preferences (user level)

Phase 0 checks whether the person has user-level instructions. If not, offer a starter covering how they like to work: when to commit, how much to explain, writing style, things to never do. Write it to `~/.claude/CLAUDE.md` and/or `~/.copilot/copilot-instructions.md`, depending on the agents detected. Ask before writing: these files are theirs and apply to every repo.

## Optional: a nudge when opening an unconfigured repo

`scripts/session-nudge.ps1` (Windows) and `scripts/session-nudge.sh` (macOS/Linux) check whether a repo lacks both `AGENTS.md` and `CLAUDE.md`. If so, they tell Claude Code to suggest `/repo-bootstrap`. To install, with the person's approval, add this to `~/.claude/settings.json` (merge with existing hooks; don't replace them):

```json
{
  "hooks": {
    "SessionStart": [
      { "matcher": "startup", "hooks": [ { "type": "command", "command": "<path to the script for this OS>" } ] }
    ]
  }
}
```

On Windows, the command is `powershell -NoProfile -File "%USERPROFILE%\.agents\skills\repo-bootstrap\scripts\session-nudge.ps1"`. Copilot's hook support differs; `TODO(verify)` before offering it there.
