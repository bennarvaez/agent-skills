# AGENTS.md

This repo holds agent skills for GitHub Copilot in VS Code and Claude Code. Each skill is a folder in `skills/` with a `SKILL.md`.

## Instruction files: AGENTS.md over CLAUDE.md

We strongly prefer `AGENTS.md` to `CLAUDE.md`, both in this repo and in anything a skill writes.

- Put agent instructions in `AGENTS.md`. Copilot, Claude Code and most other agents read it.
- Don't create a `CLAUDE.md` unless a tool can't read `AGENTS.md`. If you need one, make it a one-line pointer to `AGENTS.md` and don't copy content into it.
- When a skill sets up or audits a repo, it should write `AGENTS.md` by default.

## Writing skills

Follow both of these guides when you create or change a skill:

- Anthropic, [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- Agent Skills, [Best practices for skill creators](https://agentskills.io/skill-creation/best-practices) (see especially [Design coherent units](https://agentskills.io/skill-creation/best-practices#design-coherent-units))

If you can, read the guides themselves. The rules below are the ones that matter most:

**Scope**
- Each skill should be one coherent unit of work, like a well-designed function. If it's too narrow, one task loads several skills whose instructions can conflict. If it's too broad, the agent can't tell when to use it.
- Write the skill from real expertise: a task you've actually done, corrections you've made, project conventions. Generic best-practice text doesn't help.

**Frontmatter**
- `name`: up to 64 characters, using only lowercase letters, digits and hyphens. It can't contain `anthropic` or `claude`. Names follow one pattern across the repo.
- `description`: up to 1,024 characters, written in third person. Say what the skill does and when to use it, with the trigger words a user would actually type.

**Content**
- Keep it concise. Include only what the agent wouldn't otherwise know, and delete any line it would follow correctly without being told.
- Keep the `SKILL.md` body under 500 lines and about 5,000 tokens. Move detail into `references/`, `scripts/` or `assets/`.
- Link reference files directly from `SKILL.md`, one level deep, and say when to read each one ("read `references/x.md` if …"). Give any reference file longer than 100 lines a table of contents.
- Fit how specific you are to how fragile the step is. Give exact commands where a mistake costs a lot. Elsewhere, give guidance and explain why.
- Give one default plus a fallback rather than a list of equal options.
- Teach a method that generalizes, not the answer to one case.
- Put gotchas in `SKILL.md`. Use checklists for multi-step workflows, validation loops for important output, and plan-validate-execute for batch or destructive operations.
- Use one term for each concept throughout. Don't write dates that will go stale. Use forward slashes in paths.

**Scripts**
- Handle errors inside the script instead of leaving them to the agent. Explain every constant. List any dependencies.
- Say whether the agent should run each script or read it.

**Testing**
- Write about three evaluation scenarios before you write much of the skill, and compare the results with no skill against the results with it.
- Test with real tasks and read the execution traces, not just the final output. When you correct the agent, add the correction to the gotchas.

## Repo conventions

- Add new skills to the table in `README.md` and record changes in `CHANGELOG.md`.
- Installers (`install.ps1`, `install.sh`) link every folder in `skills/`, so nothing else needs to be registered.
