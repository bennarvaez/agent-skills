# Azure DevOps

Apply `standards.md` through the Azure CLI with the `azure-devops` extension. Every item is a shared change: plan it, get approval, check whether it exists first, apply one at a time, and never loosen or delete an existing setting. Flags change between versions, so confirm with `az <group> <command> --help` before first use.

## Preconditions

| Check | Command | If it fails |
|---|---|---|
| CLI and extension | `az --version`, `az extension show -n azure-devops` | `az extension add -n azure-devops` |
| Signed in | `az account show`, or `az devops login` with a PAT from an env var (never write the PAT anywhere) | |
| Org, project, repo | From the remote: `https://dev.azure.com/<org>/<project>/_git/<repo>` or `https://<org>.visualstudio.com/<project>/_git/<repo>` | |
| Defaults for this session | `az devops configure --defaults organization=https://dev.azure.com/<org> project=<project>` | This writes to the user's az config; mention it. Or pass `--org` and `--project` on every command instead. |
| Repo ID | `az repos show --repository <repo> --query id -o tsv` | |
| Your permissions | Project Administrator, or Edit policies and Manage permissions on the repo | Report what's missing |

## How GitHub concepts map

| GitHub | Azure DevOps |
|---|---|
| Team | Team (for boards and areas) and security group (for permissions). Create both only if boards are used; otherwise a security group is enough. |
| Repo permission per team | Repo security: allow or deny per group |
| CODEOWNERS | Branch policy: required reviewers with a path filter |
| Ruleset / branch protection | Branch policies on the default branch |
| Required status checks | Build validation policy |
| PR template | `.azuredevops/pull_request_template.md` |
| Labels | Work item tags (created on first use; nothing to set up) |
| Environments with approvals | Pipeline environments with approvals and checks |
| Dependabot / secret scanning | GitHub Advanced Security for Azure DevOps (paid, per org) |

## Security groups

```sh
az devops security group list --scope project --query "graphGroups[].displayName"
az devops security group create --name '<repo>-maintainers' --description 'Maintainers of <repo>' --scope project
```

Granting repo permissions to a group uses `az devops security permission update` with the Git Repositories namespace and a token for the repo. Find them with:

```sh
az devops security permission namespace list --query "[?name=='Git Repositories']"
az devops security permission namespace show --namespace-id <id>    # bit values per permission
```

The token is `repoV2/<projectId>/<repoId>`. Because this is error-prone, show the exact command and bits in the plan. If unsure, list it as a manual step: Project settings > Repositories > Security.

## Teams (only if Boards are used)

```sh
az devops team list --query "[].name"
az devops team create --name '<repo> team' --description '...'
```

## Branch policies (default branch)

```sh
az repos policy list --repository-id <repoId> --branch <default> -o table
az repos policy approver-count create --repository-id <repoId> --branch <default> \
  --minimum-approver-count 1 --creator-vote-counts false --allow-downvotes false \
  --reset-on-source-push true --blocking true --enabled true
az repos policy comment-required create --repository-id <repoId> --branch <default> --blocking true --enabled true
az repos policy merge-strategy create --repository-id <repoId> --branch <default> \
  --allow-squash true --allow-no-fast-forward true --blocking true --enabled true
az repos policy work-item-linking create --repository-id <repoId> --branch <default> --blocking false --enabled true
```

Build validation (the equivalent of required checks) needs a pipeline ID:

```sh
az pipelines list --query "[].{id:id,name:name}"
az repos policy build create --repository-id <repoId> --branch <default> --build-definition-id <id> \
  --display-name 'CI' --queue-on-source-update-only false --valid-duration 0 --manual-queue-only false \
  --blocking true --enabled true
```

## Required reviewers per path (CODEOWNERS equivalent)

```sh
az repos policy required-reviewer create --repository-id <repoId> --branch <default> \
  --required-reviewer-ids '<group or user descriptor/email>' --path-filter '/infra/*' \
  --message 'Infra changes need an admin' --blocking true --enabled true
```

Record the path-to-group mapping in `AGENTS.md` too, so agents know who owns what.

## Pipelines and environments

- If there's no `azure-pipelines.yml`, offer a minimal one built from the `AGENTS.md` commands. Create the pipeline with `az pipelines create --name '<repo> CI' --yml-path azure-pipelines.yml --repository <repo> --repository-type tfsgit --branch <default> --skip-first-run true`.
- Environments with approvals have no `az` command; create them through the REST API or list them as a manual step (Pipelines > Environments > Approvals and checks).

## Files

- `.azuredevops/pull_request_template.md`
- `README.md`
- `AGENTS.md`
- Copilot and Claude files as usual: the agents don't depend on the git host.

There's no issue form equivalent: describe the agent task fields in a work item template, or skip it.
