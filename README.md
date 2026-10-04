# Agent skills

Skills for **GitHub Copilot in VS Code** and **Claude Code**. A skill is a folder with a `SKILL.md` that teaches the agent a procedure; you run it by typing `/<name>` in chat.

| Skill | What it does |
|---|---|
| [`repo-bootstrap`](skills/repo-bootstrap/SKILL.md) | Sets up or audits any repository for AI agents. It reads the repo and your environment (which agents, OS, git platform), plans everything, and writes only what you approve. That covers `AGENTS.md`, rules, skills and agents, the project docs (status table, roadmap, changelog, decision log), personal git-ignored notes, and optionally repo settings (groups, branch rules, CODEOWNERS, labels) on GitHub or Azure DevOps. |

## Install

Requirements: git, and Copilot in VS Code and/or Claude Code.

```sh
git clone <this repo's URL>
cd agent-skills
```

**Windows (PowerShell):**

```powershell
.\install.ps1
```

If PowerShell refuses to run scripts, use `powershell -ExecutionPolicy Bypass -File .\install.ps1`.

**macOS / Linux:**

```sh
./install.sh
```

Then restart VS Code (or start a new Claude Code session) and type `/repo-bootstrap` in chat.

### What the installer does

- It links each folder in `skills/` into `~/.agents/skills/`, which Copilot in VS Code reads, and into `~/.claude/skills/` if Claude Code is installed.
  - On Windows these are directory junctions, which need no admin rights. On macOS/Linux they're symlinks.
  - Because they're links, the installed skills are the files in this clone.
- If a folder with the same name already exists, it's renamed to `<name>.backup-<date>`, never deleted.
- Prefer copies to links? Use `install.ps1 -Copy` or `install.sh --copy`, and re-run it after each update.

## Update

```sh
git pull
```

With the default (linked) install, that's all. With `-Copy` / `--copy`, run the installer again.

## Uninstall

```powershell
.\install.ps1 -Uninstall     # Windows
```

```sh
./install.sh --uninstall     # macOS / Linux
```

This removes the links (or copies) only. Your personal files are left alone, such as the saved standards in `~/.agents/repo-bootstrap/standards.md`.

## Your settings vs. this repo

`repo-bootstrap` ships default repo standards in `skills/repo-bootstrap/references/standards.md`. The first time it changes repo settings, it shows you those defaults, asks what to change, and saves your version to `~/.agents/repo-bootstrap/standards.md`. That personal copy is what it uses from then on, so updating this repo never overwrites your choices. Don't edit the defaults here unless you mean to change them for everyone who installs from this repo.

## Repo layout

```
skills/
  repo-bootstrap/
    SKILL.md          the procedure (phases, rules)
    references/       details loaded when needed: templates, platforms, standards...
    scripts/          optional session-start reminder
install.ps1           Windows installer
install.sh            macOS / Linux installer
CHANGELOG.md
```

To add a skill, create `skills/<name>/SKILL.md` with `name` and `description` frontmatter (the folder name must match `name`), then re-run the installer.
