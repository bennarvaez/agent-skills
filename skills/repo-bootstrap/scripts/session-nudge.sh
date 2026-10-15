#!/usr/bin/env sh
# SessionStart hook for Claude Code: if the repo has no agent instructions,
# ask Claude to suggest /repo-bootstrap. Prints nothing otherwise.
root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
[ -f "$root/AGENTS.md" ] || [ -f "$root/CLAUDE.md" ] && exit 0
printf '%s' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"This repository has no AGENTS.md or CLAUDE.md. Before starting other work, briefly suggest running /repo-bootstrap to set up agent instructions and project docs. Mention it once; do not run it unless asked."}}'
