# Special files

Some file names mean something to the hosting platform: it shows them in its UI, applies them automatically, or links to them. Others are only conventions that tools and people recognise. Check which exist in Phase 2. Offer the missing ones that fit, but only in Phase 3, and never write legal text (license, code of conduct) without the user choosing it.

## Recognised by GitHub

GitHub calls most of these "community health files". They work in the repo root, `docs/` or `.github/`, and an organization can provide defaults for all its repos from a repo named `.github`.

| File | What GitHub does with it |
|---|---|
| `README.md` | Shown on the repo home page |
| `LICENSE` | Detected and shown in the sidebar; drives the license API |
| `CONTRIBUTING.md` | Linked when people open issues and pull requests |
| `CODE_OF_CONDUCT.md` | Linked in the community profile |
| `SECURITY.md` | Shown in the Security tab; tells people how to report vulnerabilities |
| `SUPPORT.md` | Linked when people open issues |
| `GOVERNANCE.md` | Linked in the community profile |
| `FUNDING.yml` (`.github/`) | Shows a Sponsor button |
| `CODEOWNERS` (root, `docs/` or `.github/`) | Requests reviews from owners of changed paths; can be required by branch rules |
| `CITATION.cff` | Shows "Cite this repository" |
| `.github/ISSUE_TEMPLATE/*.yml` / `*.md`, `config.yml` | Issue forms and templates |
| `.github/pull_request_template.md` | Pre-fills pull request descriptions |
| `.github/dependabot.yml` | Dependency update pull requests |
| `.github/workflows/*.yml` | GitHub Actions |
| `.github/copilot-instructions.md`, `.github/instructions/`, `.github/agents/`, `.github/workflows/copilot-setup-steps.yml` | Copilot customisation |

Learn more:
- [Community health files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
- [About CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [Licensing a repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)

## Recognised by Azure DevOps

| File | What Azure DevOps does with it |
|---|---|
| `README.md` | Shown on the repo's Files page and the project overview |
| `.azuredevops/pull_request_template.md` (also `.vsts/` or `docs/`), and `pull_request_template/branches/<branch>.md` | Pre-fills pull request descriptions |
| `azure-pipelines.yml` | Offered when creating a pipeline |

Azure DevOps has no CODEOWNERS file; required reviewers per path are a branch policy (see `platform-azure-devops.md`). Learn more: [PR templates](https://learn.microsoft.com/en-us/azure/devops/repos/git/pull-request-templates).

## Recognised by GitLab

`README.md`, `LICENSE`, `CONTRIBUTING.md`, `CHANGELOG.md` (linked on the project page), `CODEOWNERS` (root, `docs/` or `.gitlab/`), `.gitlab/issue_templates/`, `.gitlab/merge_request_templates/`, and `.gitlab-ci.yml`. Learn more: [GitLab Code Owners](https://docs.gitlab.com/user/project/codeowners/).

## Conventions (not special to any platform)

| File | Convention |
|---|---|
| `CHANGELOG.md` | [Keep a Changelog](https://keepachangelog.com/); also read by release tools such as release-please and changesets |
| `ROADMAP.md` / `docs/roadmap.md` | Plain convention; no platform treats it specially |
| `AGENTS.md` | Cross-agent instructions ([agents.md](https://agents.md/)), read by Copilot, Claude Code, Cursor, Codex and others |
| `CLAUDE.md`, `CLAUDE.local.md` | Claude Code's own instruction files. Either one stops Claude Code reading `AGENTS.md`, so this skill avoids both and uses `.claude/rules/` instead ([Claude memory docs](https://code.claude.com/docs/en/memory.md)). |
| `.editorconfig` | Indentation and line endings across editors ([editorconfig.org](https://editorconfig.org/)) |
| `.gitattributes` | Line endings and binary handling. `* text=auto` stops LF/CRLF churn on mixed Windows/Unix teams. |
| `.gitignore` | Paths git ignores |
| `docs/adr/` | Architecture Decision Records ([adr.github.io](https://adr.github.io/)) |
