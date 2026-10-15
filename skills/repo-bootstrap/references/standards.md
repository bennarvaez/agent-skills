# Default standards

The defaults this skill proposes (Phase 3). Each of the three parts below is proposed the first time a run needs it. Once the user accepts or changes it, their version is added to `~/.agents/repo-bootstrap/standards.md`, and every later run, in any repo, uses that copy instead. Don't edit this file for personal changes: an update to the skill would overwrite them. `<repo>` stands for the repository name.

## Contents

- Repository settings (only when the user wants them, Phase 5): groups, branch protection, merge settings, CODEOWNERS, labels, security, environments
- Contributing (when `CONTRIBUTING.md` is in the plan)
- Files every repo gets

# Repository settings

## Groups every repo gets

Created even when empty, so permissions, CODEOWNERS and approvals have somewhere to point from day one. Add members by hand later.

| Group | Purpose | GitHub permission | Azure DevOps equivalent |
|---|---|---|---|
| `<repo>-admins` | Settings, secrets, branch rules | Admin | Repo "Manage permissions" and "Edit policies" |
| `<repo>-maintainers` | Merge, releases, issue management | Maintain | Contribute, with policy bypass only when needed |
| `<repo>-approvers` | Required reviewers; the default CODEOWNERS entry | Write | Required-reviewer policy group |
| `<repo>-contributors` | Branches and pull requests | Write | "Contribute to pull requests", "Create branch" |
| `<repo>-triagers` | Label, assign and close issues without code access | Triage | Boards work item rights, no repo write |
| `<repo>-readers` | View only | Read | Read |
| `<repo>-release-managers` | Approve production deployments (only if the repo deploys) | Write | Environment approvers |

GitHub teams exist only in organizations. On a personal account, skip teams and use collaborators; CODEOWNERS then names the owner. On Azure DevOps, one project often holds many repos, so ask whether groups should be named after the project instead.

## Default branch protection

- Pull requests required to merge into the default branch
- Approvals required: 1. The last pusher can't approve their own changes.
- Approvals reset when new commits are pushed
- Required checks: the CI jobs that exist (the job names from the workflow or pipeline)
- No force pushes, no deletion of the default branch
- Conversations resolved before merging
- Linear history: off (turn on if you squash-merge only)

## Merge settings

- Squash merge on, merge commits on, rebase merge off
- Delete branches after merge
- Auto-merge allowed

## CODEOWNERS

```
*   @<org>/<repo>-approvers
```

Plus one line per area with a clear owner, found in Phase 2 (e.g. `/infra/ @<org>/<repo>-admins`). On Azure DevOps this becomes a required-reviewer policy per path.

## Labels

| Label | Color | Meaning |
|---|---|---|
| `needs-triage` | `fbca04` | Needs a maintainer to look at it |
| `needs-info` | `d4c5f9` | Waiting on the reporter |
| `ready-for-agent` | `0e8a16` | Fully specified; an AI agent can pick it up |
| `ready-for-human` | `1d76db` | Needs a person to implement |
| `agent-task` | `5319e7` | Created from the agent task form |
| `wontfix` | `ffffff` | Won't be done |

## Security

- Dependabot (or Azure DevOps dependency scanning) alerts on; security updates on
- Secret scanning and push protection on where the plan allows it
- Private vulnerability reporting on (public repos)
- Actions / pipelines: the default token is read-only; workflows ask for more explicitly

## Environments

If the repo deploys: `dev`, `staging`, `production`. `production` requires approval from `<repo>-admins`.

# Contributing

Choices for `CONTRIBUTING.md` (template in `templates.md`). The facts in it (links, commands, licenses) always come from the repo.

- **Offered for:** public repos, and private repos that take changes from outside the core team.
- **Sections:** types of contributions (each with where it goes and what it needs), not accepting right now (each with a reason), getting set up, submitting changes, AI-assisted contributions, license.
- **Getting set up:** list the one or two commands that get a working copy running, then link to `AGENTS.md` for the full list.
- **Large changes:** ask in a discussion (or an issue, without Discussions) first.
- **AI policy:** contributors must disclose AI use and how much; trivial typo or spacing fixes are exempt. Also: they must understand and be able to explain their change, include tests or steps that show it works, and undisclosed AI contributions may be closed.
- **License:** one line pointing to `LICENSE`; when code and docs have separate licenses, name both.

# Files every repo gets

`README.md` (with a status table), `.gitignore` (created if missing, with the stack's entries and the local-files block), `.gitattributes` (`* text=auto`), `.editorconfig`, the PR template, `SECURITY.md`. Plus `LICENSE` and `CONTRIBUTING.md` for public repos, where you choose the license.
