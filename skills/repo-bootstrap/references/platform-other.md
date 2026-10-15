# GitLab, Bitbucket, and no remote

## GitLab (`glab` CLI)

Same rules as GitHub: plan, approve, check first, one at a time, confirm flags with `glab <command> --help`.

| Standard | GitLab |
|---|---|
| Groups | Subgroups under the project's group: `glab api groups -X POST -f name=<repo>-maintainers -f path=<repo>-maintainers -f parent_id=<id>`. Then share the project with them at an access level: Maintainer 40, Developer 30, Reporter 20. |
| Branch protection | `glab api projects/<id>/protected_branches -X POST -f name=<default> -f push_access_level=0 -f merge_access_level=40` |
| Approvals | Approval rules (Premium tier). On Free, list as "needs a paid tier". |
| CODEOWNERS | `.gitlab/CODEOWNERS`; "code owner approval" on protected branches is Premium |
| Templates | `.gitlab/merge_request_templates/Default.md`, `.gitlab/issue_templates/` |
| Labels | `glab label create --name <name> --color '#<hex>'` |
| CI | `.gitlab-ci.yml` |

## Bitbucket

No standard CLI. Branch restrictions, default reviewers and groups are set in the web UI or the REST API. List them as manual steps with exact settings from `standards.md`. Files: `bitbucket-pipelines.yml`; there's no PR template file.

## No remote, or an unknown host

Skip Phase 5. Write only the repo files. In the report, list which standards would apply once the repo has a host, so they're easy to apply later with an audit run.
