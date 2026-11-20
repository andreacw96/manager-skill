<p align="center">
  <img src="https://raw.githubusercontent.com/andreacw5/manager-skill/main/docs/brand/banner.png" width="500" alt="manager — Claude Code plugin" />
</p>

# manager — a Claude Code skill

Turns Claude into a **manager, not an executor**. Once invoked, Claude plans the work, writes a brief for each piece, hands it to a separate session or subagent on the **cheapest model that can do it**, checks the evidence each worker returns, and keeps you posted.

Why use it: long tasks stay cheap (haiku and sonnet do most of the work), your main session's context stays clean, and nothing counts as done until it is checked against `git` / `gh`.

## Install

In Claude Code:

```
/plugin marketplace add andreacw5/manager-skill
/plugin install manager@manager-skill
```

Manual alternative, without the plugin system:

```bash
git clone https://github.com/andreacw5/manager-skill /tmp/manager-skill && cp -r /tmp/manager-skill/skills/manager ~/.claude/skills/
```

## Use

Say `/manager`, "manager mode", "delegate everything", or in Italian "modalità manager" / "fai il gestore".
Turn it off with "stop manager" or "normal mode".

Then just describe the work, for example: *"Bump the SDK in api and web, fix the breaking changes, open PRs."*

## How it works

| Step | What Claude does |
|------|------------------|
| Plan | Splits the request into independent pieces, one per repo or area |
| Brief | Sends each worker a fixed template: goal, path, constraints, a concrete "done" check, where to stop, what to report |
| Route | Picks the model by **ambiguity, not size**: haiku for mechanical work, sonnet by default, opus for unclear or risky work, fable for independent review |
| Verify | Treats a report as a claim and checks branch, diff stat, tests and CI before saying it's done |
| Escalate | Retries once with a better brief, then moves up a tier |

Rules it follows: it never edits project repos itself, runs at most 4 workers at once, gives each repo one writer, and never merges or pushes without your explicit OK.

## Compatibility

- **Claude desktop app (Code tab):** full mode. Each piece runs in its own session and worktree, and you can open and steer any of them.
- **CLI / IDE / other clients:** works on subagents (`Agent` tool, worktree isolation). Same rules and briefs; workers just aren't separate sessions you can open.

## License

MIT
