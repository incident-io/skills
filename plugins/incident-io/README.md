# incident.io

Makes your agent fluent in incident.io: responding to and investigating incidents, working
with on-call schedules and escalations, and authoring the operational content — runbooks,
skills, and plugins — that incident.io investigations draw on.

The plugin bundles the [official incident.io MCP server](https://docs.incident.io/ai/remote-mcp)
(`https://mcp.incident.io/mcp`), so installing it connects your agent to your incident.io
workspace through a standard OAuth flow the first time a tool is used.

Run these skills on Opus/Sol level or higher. Smaller models follow their
workflows unreliably.

## Skills

| Skill | What it does |
|-------|--------------|
| [architecture](./skills/architecture) | Answers questions about how your systems are built, deployed and run, using your architecture docs. |
| [architecture-author](./skills/architecture-author) | Interviews you to write and maintain the architecture docs that say what each system is, where it runs and what it depends on. |
| [catalog](./skills/catalog) | Answers questions from your catalog, such as who owns a service, what it depends on and what a team owns. |
| [doctor](./skills/doctor) | Reviews the health of your setup: sync failures, skills that load but don't get followed, and feedback worth acting on. It reports what to fix and never edits anything. |
| [extensions](./skills/extensions) | The place to start. Reads your current plugins and connectors, works out whether a plugin or a connector solves your problem, scaffolds and registers a plugin, then hands off to the skill that owns the rest. |
| [incidents](./skills/incidents) | Reads and updates incidents, including status, severity, roles, custom fields and updates, and looks back at past incidents. |
| [on-call](./skills/on-call) | Shows who is on call, manages overrides and cover requests on your schedules, and pages people and checks whether a page reached them. |
| [postmortem](./skills/postmortem) | Finds, reads, edits and reviews postmortem documents, checking their claims against what actually happened. |
| [skill-authoring](./skills/skill-authoring) | Writes new skills from your team's knowledge, verifies them before they ship, and improves existing skills from the usage feedback we record. |
| [talking-to-the-user](./skills/talking-to-the-user) | Sets how the incident.io skills talk to you, including one clear next step at the end of each reply. |
| [telemetry](./skills/telemetry) | Queries your logs, metrics, traces, dashboards and databases to find evidence for an answer. |

## Connections

Every connection these skills call, and where it comes from in each environment:

| Connection | Coding agent on your machine | incident.io hosted agents |
|-----------|------------------------------|---------------------------|
| incident.io | The bundled MCP server (`.mcp.json`), authenticated over OAuth on first use | Native tools with the same capabilities |

Skills may also use provider tools the session already has (a Notion search, a wiki
search) — those are the session's, not dependencies of this plugin.

## Where your content lives

This plugin carries incident.io's guidance, not your content. Runbooks, architecture notes,
and other operational knowledge belong in your own repositories, where they live next to the
code they describe and are reviewed like it. The skills here help you write that content
well and keep it current.

## Usage reporting

When an agent session starts, the plugin runs `hooks/report-telemetry`. It tells us
which version of the plugin you have and which agent it runs in. It is a short `sh`
script that you can read, and it cannot block or fail a session.

It sends at most one request a day for each agent, to
`https://app.incident.io/api/agent_plugins/v1/telemetry`.

### What we send

```
X-Incident-Plugin-Version: 1.20261007.771
X-Incident-Plugin-Harness: claude-code
X-Incident-Plugin-Channel: public

{"key": "plugin:session", "install_id": "9b89b079-24ec-403e-89e2-e5e2513b718e"}
```

`install_id` is a random id for this installation, so we count it once. It is not derived
from anything about you or your machine, and it is not linked to your incident.io
account.

We send nothing else. The script does not read your prompts, your conversation, your
files or anything your agent passes to it.

### What it keeps on your machine

Two kinds of file, both under `~/.config/incident-io-plugin/`:

- `installation-id` holds the random id. Delete it and the next report makes a new one.
- `last-report-<agent>` holds the date and plugin version of the last report, so the
  script reports once a day.

### Turning it off

```
export INCIDENT_PLUGIN_TELEMETRY=off
```

Any capitalization of `off` works. Or create a file, which an admin can push centrally
without editing everyone's shell profile:

```
touch ~/.config/incident-io-plugin/opt-out
```

With either one set, the script writes no files and makes no request.

## Privacy

This plugin connects to your incident.io account through the bundled MCP server. See the
[incident.io privacy policy](https://incident.io/privacy), and the
"Usage reporting" section above for exactly what the plugin's own hooks send and how
to turn them off.
