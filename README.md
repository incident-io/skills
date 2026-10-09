# 🔥 incident.io skills

The official [incident.io](https://incident.io) plugin for AI agents. It bundles incident.io skills with the [incident.io MCP server](https://docs.incident.io/ai/remote-mcp). Use it to respond to and investigate incidents, work with on-call schedules and escalations, and author the runbooks, skills and plugins that incident.io investigations draw on.

## Installation

Install the plugin from your agent's official listing. Install it from this repository only when your agent has no listing, or you cannot use the listing. For the full steps for each agent, see [Install the plugin](https://docs.incident.io/ai/remote-mcp#install-the-plugin).

<details>
<summary>Claude Code</summary>

Our plugin is in Claude's official [marketplace](https://claude.com/marketplace/plugins/incident-io). To install it, run:

```
/plugin install incident-io@claude-plugins-official
```

For a team, an administrator can add our plugin to the organization's plugin library on claude.ai. Claude then syncs it to everyone's sessions.

The official marketplace auto-updates, so you get new skills as we ship them.

To install from this repository instead, run:

```
/plugin marketplace add incident-io/skills
/plugin install incident-io@incident-io-skills
```

A copy from this repository does not auto-update by default. To turn it on, see Claude Code's [configure auto-updates](https://code.claude.com/docs/en/plugins/install#keep-plugins-updated).

</details>

<details>
<summary>Cursor</summary>

Our plugin is in the [Cursor marketplace](https://cursor.com/marketplace/incident.io). To install it, run:

```
/add-plugin incident-io
```

You can also install it from the Cursor IDE. Open **Customize** in the sidebar, find the incident.io plugin, and select **Install**. Choose to install it for the project or for your user account.

Cursor syncs daily when you install from the official marketplace, so you get new skills as we ship them.

</details>

<details>
<summary>Codex</summary>

Our plugin is in the [ChatGPT plugin directory](https://chatgpt.com/plugins/plugin_asdk_app_6ac3f2cb2b608191b91136b4cf737358). Codex installs from the directory only when you sign in with ChatGPT. To install it, run:

```
codex plugin add incident-io@openai-curated-remote
```

If you sign in to Codex with an API key, install from this repository instead:

```
codex plugin marketplace add incident-io/skills
codex plugin add incident-io@incident-io-skills
```

To get a new version from this repository, run `codex plugin marketplace upgrade`.

On Business and Enterprise plans, an admin can import this repository's marketplace for everyone, from **Admin → Plugins → Marketplaces**. The workspace syncs it daily. To sync it sooner, the admin selects **Sync now** on the same page.

</details>

<details>
<summary>Other agents</summary>

Most agents that support plugins can install ours from this repository. This includes VS Code and GitHub Copilot. Add `incident-io/skills` as a marketplace, or `https://github.com/incident-io/skills` if your agent does not accept the shorthand. Then install the `incident-io` plugin from it.

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

This repository is a read-only release mirror, pull requests are not accepted here.
Please report problems via [incident.io support](https://incident.io) instead.

#### License

[MIT](./LICENSE)
