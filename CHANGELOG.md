# Changelog

All notable changes to these skills are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- `make-artifact`: makes a self-contained HTML page (an "artifact") with any agent, and keeps it on your machine.
  - **Page rules:** one file, light and dark themes, works at phone width, accessible, complete as soon as it loads.
  - **Design guidance:** pick a treatment, a palette, a type scale and a layout grounded in the subject, and avoid the generic AI look.
  - **A starter page** with the theme setup done, plus three example pages: a comparison, an interactive tool and a report with a chart.
  - **Save scripts** for Windows (`save.ps1`) and macOS/Linux (`save.sh`). They copy the page to `~/artifacts/<slug>/index.html`, keep each earlier version, and open the page in the browser.
- `AGENTS.md` for this repo: write skills to Anthropic's and agentskills.io's best practices, and prefer `AGENTS.md` to `CLAUDE.md`.
- `repo-bootstrap`: sets up or audits a repository for Copilot in VS Code and Claude Code.
  - **Environment detection:** which agents, OS, shell and command-line tools the person has, and the git platform.
  - **One shared `AGENTS.md`** for every agent, with no `CLAUDE.md` (Claude Code reads `AGENTS.md` directly).
  - **Project docs:** README status table, roadmap, changelog and decision log, plus the "update every session" habit.
  - **Personal, git-ignored notes** for each person and machine: `.claude/rules/personal.local.md` and `.github/instructions/personal.local.instructions.md`.
  - **Repo settings, only if you ask for them:** groups, branch rules, CODEOWNERS, labels and security for GitHub and Azure DevOps.
  - **Your standards, saved once:** repo settings and `CONTRIBUTING.md` choices are proposed the first time they're needed, then saved to `~/.agents/repo-bootstrap/standards.md` and reused in every repo.
  - **`README.md`:** checked for what it's missing (what the project is, how to install and use it, links to the other docs); created if missing, otherwise only the missing sections are proposed.
  - **`.gitignore`:** created if missing, with the stack's entries and the local-files block.
  - **`CONTRIBUTING.md`:** drafted from the repo (contribution types with their requirements, what's not accepted and why, setup commands, an AI-assistance disclosure policy) and shown to you for changes before it's written.
  - **Templates** for rules, skills, agents, PR and issue templates, and `SECURITY.md`.
  - **Safety:** every run starts with an audit, nothing is written before you approve the plan, CI/CD is only offered where it applies, and a to-do list tracks the phases.
  - **`.worktreeinclude`:** lists the personal git-ignored files so Claude Code worktrees get them too.
  - **Personal "Project instructions" setting:** documents the exact `pluginConfigs` key for people who want Claude Code to read both `CLAUDE.local.md` and `AGENTS.md`.
- Installers for Windows (`install.ps1`) and macOS/Linux (`install.sh`). Safe to run again: they replace their own links and copies instead of backing them up.
