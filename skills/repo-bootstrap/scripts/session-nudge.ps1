# SessionStart hook for Claude Code: if the repo has no agent instructions,
# ask Claude to suggest /repo-bootstrap. Prints nothing otherwise.
$root = git rev-parse --show-toplevel 2>$null
if (-not $root) { exit 0 }
if ((Test-Path (Join-Path $root 'AGENTS.md')) -or (Test-Path (Join-Path $root 'CLAUDE.md'))) { exit 0 }
$msg = 'This repository has no AGENTS.md or CLAUDE.md. Before starting other work, briefly suggest running /repo-bootstrap to set up agent instructions and project docs. Mention it once; do not run it unless asked.'
@{ hookSpecificOutput = @{ hookEventName = 'SessionStart'; additionalContext = $msg } } | ConvertTo-Json -Compress
