# Local notes

How any agent records a personal or machine-specific fact (an OS or shell quirk, a local path, a tool version, a workaround, a preference) so it helps this person without affecting teammates. Used in Phase 4 to create the files, and by the `Local notes` section of every generated `AGENTS.md` afterwards.

## 1. Decide the scope

| The fact is true for... | Write it to |
|---|---|
| This user, in every repo (preferences, OS-wide quirks) | User-level files (step 3) |
| This user, in this repo only (local paths, this repo's build quirks on this machine) | The repo's local files (step 2) |
| Everyone working on this repo | Not this skill: propose an `AGENTS.md` change instead, and ask before editing it |

When unsure between the first two, ask in one short question.

## 2. Repo-level local files

Detect which agents this user runs: Claude Code if `~/.claude/` exists; Copilot if VS Code user settings have `github.copilot` or `chat.` keys, or `~/.copilot/` exists.

| Agents | File to write | Reader |
|---|---|---|
| Both | `.claude/rules/personal.local.md` and `.github/instructions/personal.local.instructions.md`, the same note in each | Claude Code reads the first, Copilot the second |
| Claude Code only | `.claude/rules/personal.local.md` | Claude Code |
| Copilot only | `.github/instructions/personal.local.instructions.md` | Copilot |

Never create `CLAUDE.local.md`: it would stop Claude Code reading the repo's `AGENTS.md`. If one already exists, mention that, and offer to move its notes to `.claude/rules/personal.local.md`.

Before writing:

1. Confirm the file is ignored: `git check-ignore -v <file>`. If it isn't, add the local-files block from `environment.md` ("The .gitignore block") to `.gitignore` (ask first; it's a shared file), or to `.git/info/exclude` if the user prefers not to touch shared files.
2. If the file doesn't exist, start it from the template in `environment.md` ("Template: personal.local.instructions.md"). For `.claude/rules/personal.local.md`, leave out the frontmatter so it always loads.

## 3. User-level files

| Agent | File |
|---|---|
| Claude Code | `~/.claude/CLAUDE.md`, or a topic file in `~/.claude/rules/<topic>.md` |
| Copilot | `~/.copilot/copilot-instructions.md`, or `~/.copilot/instructions/<topic>.instructions.md` with `applyTo: "**"` |

Write to each agent the user runs. These files apply everywhere and belong to the user, so show the exact lines and ask before adding them.

## 4. Write the note

- One bullet, phrased as an instruction an agent can follow: "Build with `-j 2`; parallel builds crash this PC", not "the PC is unstable".
- Include the reason or evidence in a few words, and the date if it may go stale (tool versions, workarounds).
- Update an existing bullet rather than adding a near-duplicate. Remove bullets that are no longer true when you notice them.
- Never record secrets, tokens or passwords. Record where they come from instead (an env var name, a vault entry name).

## 5. Check

- `git status` must not list the local files.
- Tell the user in one line what you recorded and where.
