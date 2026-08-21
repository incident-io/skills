# incident.io skills

Official incident.io plugins for AI agents: skills for working with
[incident.io](https://incident.io) — incidents, on-call, and investigations — and for
authoring the operational content our platform draws on.

## Installation

In Claude Code:

```
/plugin marketplace add incident-io/skills
/plugin install incident-io@incident-io-skills
```

## Plugins

| Plugin | Description |
|--------|-------------|
| [incident-io](./plugins/incident-io) | Work with incident.io from your agent, and author the operational content — runbooks, skills, and plugins — that incident.io investigations draw on. Bundles the official incident.io MCP server. |

## Layout

```
.claude-plugin/marketplace.json   # the marketplace: lists the plugins below
plugins/
  incident-io/                    # the incident.io plugin
    .claude-plugin/plugin.json
    .mcp.json                     # the official incident.io MCP server
    skills/
```

## Other agents

The plugin format is Claude Code's, but skills are plain markdown: for other agents,
reference a skill's `SKILL.md` from the tool's equivalent mechanism (for example Cursor
rules, or an `AGENTS.md` pointer).

## Contributing

This repository is a read-only release mirror: each commit is a squashed snapshot of a
release, so pull requests opened here can't be merged. Please report problems via
[incident.io support](https://incident.io) instead.

## License

[MIT](./LICENSE)
