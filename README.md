# 🔥 incident.io skills

Official [incident.io](https://incident.io) skills plugin to help you author and maintain your Nexus extensions.

## Installation

<details>
<summary>Claude Code</summary>
Start a new session and then run the following:

```
/plugin marketplace add incident-io/skills
```

```
/plugin install incident-io@incident-io-skills
```

```
/reload-plugins
```
</details>

<details>
<summary>Cursor</summary>  

1. Open the plugin manager: from the command palette, run Open Plugins (you can also reach it from Customize in the sidebar).
2. Add our marketplace: select Browse Marketplace, then Add Marketplace, and give it https://github.com/incident-io/skills.
3. Install the plugin: everyone else finds the incident.io plugin in the marketplace and selects Install, choosing whether to install it for the project or for their user account.
</details>

<details>
<summary>Codex</summary>
On Business and Enterprise plans, ask an admin to import our marketplace for everyone, from Admin → Plugins → Marketplaces.

To install it yourself instead:
```
codex plugin marketplace add incident-io/skills
```

```
codex plugin add incident-io@incident-io-skills
```
</details>

<details>
<summary>Other</summary>
Most agents that support plugins can install ours straight from the repository. 
Add incident-io/skills as a marketplace, or https://github.com/incident-io/skills 
where the shorthand isn’t accepted, then install the incident-io plugin from it.  
</details>

## Getting started with extensions

This plugin helps you author incident.io Extensions plugins: the skills, runbooks, and
architecture docs that incident.io investigations draw on. Once installed, invoke the
`extensions` skill and describe what you want, or just say it in plain language and let
the agent pick the skill that fits.

**Example prompts:**

```
/incident-io:extensions help me get started
```

```
/incident-io:extensions create a new plugin and then interview me to create architecture docs
```

```
/incident-io:extensions find and fix any issues relating to my <skill_name>
```

Read more in the [Extensions docs](https://docs.incident.io/investigations/extensions/overview).


---


#### Plugins

| Plugin | Description |
|--------|-------------|
| [incident-io](./plugins/incident-io) | Work with incident.io from your agent, and author the operational content — runbooks, skills, and plugins — that incident.io investigations draw on. Bundles the official incident.io MCP server. |

#### Layout

```
.claude-plugin/marketplace.json     # Claude marketplace: lists the plugins below
.agents/plugins/marketplace.json    # Codex marketplace: the same plugins, Codex format
plugins/
  incident-io/                      # the incident.io plugin
    .claude-plugin/plugin.json      # Claude plugin format
    .codex-plugin/plugin.json       # Codex plugin format
    .mcp.json                       # Claude + Codex formats - the official incident.io MCP server
    plugin.json                     # Agent Plugins 1.0 format
    mcp.json                        # Agent Plugins 1.0 - the same MCP server
    skills/                         # shared by all formats
```

#### Three formats, one plugin

This plugin is published in the Claude, Agent Plugins 1.0 and Codex formats, so most
agents can install it directly rather than through a workaround.

| Format | Files |
|--------|-------|
| [Claude plugin](https://code.claude.com/docs/en/plugins) | `.claude-plugin/marketplace.json`, and `.claude-plugin/plugin.json` + `.mcp.json` inside the plugin |
| [Agent Plugins 1.0](https://agent-plugins.org) | `plugin.json` + `mcp.json` at the plugin root |
| Codex plugin | `.agents/plugins/marketplace.json`, and `.codex-plugin/plugin.json` inside the plugin, sharing `.mcp.json` with the Claude format |

The `skills/` directory is shared by all formats by convention.

If your agent reads none of these formats, you can point your tool's own mechanism at a skill's
`SKILL.md`.

#### Contributing

This repository is a read-only release mirror: each commit is a squashed snapshot of a
release, so pull requests opened here can't be merged. Please report problems via
[incident.io support](https://incident.io) instead.

#### License

[MIT](./LICENSE)
