# GitHub

Apply `standards.md` through the `gh` CLI. Every item is a shared change: plan it, get approval, check whether it exists first, apply one at a time, and never loosen or delete an existing setting. Confirm flags with `gh <command> --help` before first use.

## Contents

- Preconditions (CLI, sign-in, owner type, role, plan limits)
- Teams, repository settings, branch protection (rulesets), CODEOWNERS, labels, security, environments
- Files; org-wide defaults

## Preconditions

| Check | Command | If it fails |
|---|---|---|
| CLI installed | `gh --version` | Offer the install command for the OS (`winget install GitHub.cli`, `brew install gh`). Skip Phase 5 until it's installed. |
| Signed in, with enough scope | `gh auth status` | `gh auth login`; teams need `admin:org`, so run `gh auth refresh -s admin:org` |
| Repo and owner | `gh repo view --json nameWithOwner,owner,isPrivate,visibility,defaultBranchRef` | |
| Owner type | `gh api users/<owner> --jq .type` | `Organization`: teams available. `User`: collaborators only. |
| Your role | `gh api repos/<owner>/<repo> --jq .permissions` | Needs `admin` for settings, rules and security |
| Plan limits | | Branch protection and rulesets on **private** repos need GitHub Pro, Team or Enterprise. On Free, list them as "needs a paid plan" instead of failing. |

## Teams (organizations only)

```sh
gh api orgs/<org>/teams --jq '.[].slug'                       # what exists
gh api orgs/<org>/teams -f name='<repo>-maintainers' -f privacy=closed \
  -f description='Maintainers of <repo>'                       # create
gh api -X PUT orgs/<org>/teams/<slug>/repos/<owner>/<repo> -f permission=maintain   # grant
```

For a personal account, list collaborators instead: `gh api repos/<owner>/<repo>/collaborators --jq '.[].login'`. Don't invite anyone without being asked.

## Repository settings

```sh
gh repo edit <owner>/<repo> --enable-squash-merge --enable-merge-commit --enable-rebase-merge=false \
  --delete-branch-on-merge --enable-auto-merge
```

## Branch protection (rulesets)

Rulesets replace classic branch protection. Check `gh api repos/<owner>/<repo>/rulesets` first, then create one from a JSON file in the scratchpad:

```json
{
  "name": "default-branch",
  "target": "branch",
  "enforcement": "active",
  "conditions": { "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] } },
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    { "type": "pull_request", "parameters": {
        "required_approving_review_count": 1,
        "dismiss_stale_reviews_on_push": true,
        "require_last_push_approval": true,
        "require_code_owner_review": false,
        "required_review_thread_resolution": true } },
    { "type": "required_status_checks", "parameters": {
        "strict_required_status_checks_policy": false,
        "required_status_checks": [ { "context": "<CI job name>" } ] } }
  ]
}
```

```sh
gh api -X POST repos/<owner>/<repo>/rulesets --input ruleset.json
```

Only list status checks that exist: take the job names from `.github/workflows/*.yml`, and drop the `required_status_checks` rule if there's no CI yet. A solo maintainer with `required_approving_review_count: 1` can't merge their own pull requests. Ask, and use 0 for solo repos.

## CODEOWNERS

Write `.github/CODEOWNERS` from `standards.md`. Every path pattern must match real files, and every owner must exist (team slug or user). Afterwards, check the "CODEOWNERS errors" view: `gh api repos/<owner>/<repo>/codeowners/errors`.

## Labels

```sh
gh label list --json name --jq '.[].name'
gh label create '<name>' --color '<hex>' --description '<meaning>' --force   # --force updates if it exists
```

## Security

```sh
gh api -X PUT repos/<owner>/<repo>/vulnerability-alerts            # Dependabot alerts
gh api -X PUT repos/<owner>/<repo>/automated-security-fixes        # Dependabot security updates
gh api -X PUT repos/<owner>/<repo>/private-vulnerability-reporting # public repos
gh repo edit <owner>/<repo> --enable-secret-scanning --enable-secret-scanning-push-protection
gh api -X PUT repos/<owner>/<repo>/actions/permissions/workflow -f default_workflow_permissions=read
```

Secret scanning on private repos needs GitHub Advanced Security. Report that instead of failing.

Also write `.github/dependabot.yml` for each detected package ecosystem, plus `github-actions`.

## Environments (only if the repo deploys)

```sh
gh api -X PUT repos/<owner>/<repo>/environments/production --input env.json
```

Here `env.json` sets `reviewers` to the admins team. Get team IDs from `gh api orgs/<org>/teams/<slug> --jq .id`.

## Files

The PR template, issue forms (`agent-task.yml`, plus bug and feature forms if wanted), `copilot-setup-steps.yml` (if the Copilot coding agent is used), and the code-review instructions. Templates are in `templates.md`.

## Org-wide defaults (optional)

If many repos in an org should share community files (SECURITY.md, CONTRIBUTING.md, issue templates), they can live once in the org's `.github` repository instead of in each repo. Mention this; don't create it unprompted.
