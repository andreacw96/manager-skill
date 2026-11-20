<p align="center">
  <img src="https://raw.githubusercontent.com/andreacw5/manager-skill/main/docs/brand/banner.png" width="500" alt="manager, a Claude Code plugin" />
</p>

# manager

A Claude Code skill that makes Claude delegate instead of doing the work itself. Claude plans the task, writes a brief for each piece, and hands each one to a separate session or subagent running the cheapest model that can handle it. When a worker reports back, Claude checks the evidence and tells you what landed.

Most of the work runs on haiku and sonnet, which costs less than running everything on your main model. Your main session's context also stays small, and a task only counts as done after Claude has checked it against `git` and `gh`.

## Install

Requires `git` and an authenticated GitHub CLI (`gh`).

In Claude Code:

```
/plugin marketplace add andreacw5/manager-skill
/plugin install manager@manager-skill
```

To install it without the plugin system, copy the skill folder by hand:

```bash
git clone https://github.com/andreacw5/manager-skill /tmp/manager-skill && mkdir -p ~/.claude/skills && cp -r /tmp/manager-skill/skills/manager ~/.claude/skills/
```

## Use

Say "manager mode" or "delegate everything", or in Italian "modalità manager" or "fai il gestore". As a slash command it is `/manager:manager` when installed as a plugin and `/manager` when copied by hand. Say "stop manager" or "normal mode" ("basta gestore", "modalità normale") to turn it off.

Then describe the work as usual, for example: *"Bump the SDK in api and web, fix the breaking changes, open PRs."*

## How it works

| Step | What Claude does |
|------|------------------|
| Plan | Splits the request into independent pieces, one per repo or area |
| Brief | Sends each worker the same template: goal, path, constraints, a concrete check for "done", where to stop, what to report |
| Route | Picks the model by how clear the task is. A large but fully specified task still goes to a cheap model: haiku for mechanical work, sonnet by default, opus for unclear or risky work, fable to review opus-tier changes before merge |
| Verify | Treats each report as a claim and checks the branch, diff stat, tests and CI before calling it done |
| Escalate | If the brief caused a failure, fixes it and retries once on the same model. Otherwise moves haiku to sonnet after one failure, and sonnet to opus after two |

Workers can't run on a higher model than your main session, so start it on opus if you want opus available.

Claude doesn't edit project repos itself unless you say "do it here" for a specific task. It runs at most 4 workers at a time, with one writer per repo (two only if they touch different files). Workers commit to a branch and open a PR. Nothing is merged or pushed to main until you approve.

## Compatibility

In the Claude desktop app (Code tab), each implementation task runs in its own session and worktree, and you can open and steer any of them. Small edits and searches go to subagents.

In the CLI, IDE extensions and other clients, all workers are subagents (the `Agent` tool with worktree isolation). The rules and briefs are the same, but you can't open the workers as separate sessions.

## License

MIT
