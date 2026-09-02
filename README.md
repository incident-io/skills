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
.claude-plugin/marketplace.json     # the marketplace: lists the plugins below
plugins/
  incident-io/                      # the incident.io plugin
    .claude-plugin/plugin.json      # Claude plugin format
    .mcp.json                       # Claude format - the official incident.io MCP server
    plugin.json                     # Agent Plugins 1.0 format
    mcp.json                        # Agent Plugins 1.0 - the same MCP server
    skills/                         # shared by both formats
```

## Two formats, one plugin

This plugin is published in **both** the Claude and Agent Plugins 1.0 formats, so most
agents can install it directly rather than through a workaround.

| Format | Files |
|--------|-------|
| [Claude plugin](https://code.claude.com/docs/en/plugins) | `.claude-plugin/marketplace.json`, and `.claude-plugin/plugin.json` + `.mcp.json` inside the plugin |
| [Agent Plugins 1.0](https://agent-plugins.org) | `plugin.json` + `mcp.json` at the plugin root |

The `skills/` directory is shared by both formats by convention.

If your agent reads neither format, you can point your tool's own mechanism at a skill's
`SKILL.md`.

## Contributing

This repository is a read-only release mirror: each commit is a squashed snapshot of a
release, so pull requests opened here can't be merged. Please report problems via
[incident.io support](https://incident.io) instead.

## License

[MIT](./LICENSE)
