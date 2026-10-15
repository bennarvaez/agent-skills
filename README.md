# Agent skills

Skills for **GitHub Copilot in VS Code** and **Claude Code**. A skill is a folder with a `SKILL.md` that teaches the agent a procedure; you run it by typing `/<name>` in chat.

| Skill | What it does |
|---|---|
| [`repo-bootstrap`](skills/repo-bootstrap/SKILL.md) | Sets up or audits any repository for AI agents. It reads the repo and your environment (which agents, OS, git platform), plans everything, and writes only what you approve. That covers `AGENTS.md`, rules, skills and agents, the project docs (status table, roadmap, changelog, decision log), personal git-ignored notes, and optionally repo settings (groups, branch rules, CODEOWNERS, labels) on GitHub or Azure DevOps. |
| [`make-artifact`](skills/make-artifact/SKILL.md) | Turns a request into one self-contained HTML page, such as a report, comparison, dashboard, chart or small tool, with light and dark themes and a layout that works on a phone. Each version is saved under `~/artifacts/<name>/` and opened in your browser. Nothing leaves your machine. |

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

Then restart VS Code (or start a new Claude Code session) and type `/` in chat to see the skills, for example `/repo-bootstrap`.

### What the installer does

- It links each folder in `skills/` into `~/.agents/skills/`, which Copilot in VS Code reads, and into `~/.claude/skills/` if Claude Code is installed.
  - On Windows these are directory junctions, which need no admin rights. On macOS/Linux they're symlinks.
  - Because they're links, the installed skills are the files in this clone.
- If a folder with the same name already exists, it's renamed to `<name>.backup-<date>`, never deleted.
- It's safe to run again: links and copies it made itself are replaced, not backed up.
- On Windows, use `install.ps1`. `install.sh` stops in Git Bash, which can't make real links there (it suggests `--copy` instead).
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

This removes the links (or copies) only. Your personal files are left alone, such as the saved standards in `~/.agents/repo-bootstrap/standards.md` and the pages in `~/artifacts/`.

## Your settings vs. this repo

`repo-bootstrap` ships default standards in `skills/repo-bootstrap/references/standards.md`: repo settings, `CONTRIBUTING.md` choices, and the files every repo gets. The first time a run needs one of those, it shows you the defaults, asks what to change, and saves your version to `~/.agents/repo-bootstrap/standards.md`. That personal copy is what it uses from then on, in every repo, so updating this repo never overwrites your choices. Don't edit the defaults here unless you mean to change them for everyone who installs from this repo.

## Repo layout

```
skills/
  repo-bootstrap/
    SKILL.md          the procedure (phases, rules)
    references/       details loaded when needed: templates, platforms, standards...
    scripts/          optional session-start reminder
  make-artifact/
    SKILL.md          the procedure: plan, build, check once, save
    references/       page rules, design guidance, example pages
    assets/           starter.html, the page every artifact starts from
    scripts/          save.ps1 / save.sh: version a page in ~/artifacts and open it
AGENTS.md             instructions for agents working on this repo
install.ps1           Windows installer
install.sh            macOS / Linux installer
CHANGELOG.md
```

To add a skill, create `skills/<name>/SKILL.md` with `name` and `description` frontmatter (the folder name must match `name`), then re-run the installer.
