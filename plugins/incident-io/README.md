# incident.io

Makes your agent fluent in incident.io: responding to and investigating incidents, working
with on-call schedules and escalations, and authoring the operational content — runbooks,
skills, and plugins — that incident.io investigations draw on.

The plugin bundles the [official incident.io MCP server](https://docs.incident.io/ai/remote-mcp)
(`https://mcp.incident.io/mcp`), so installing it connects your agent to your incident.io
workspace through a standard OAuth flow the first time a tool is used.

## Skills

| Skill | What it does |
|-------|--------------|
| [runbooks](./skills/runbooks) | Find, follow, write, and maintain runbooks wherever they live — your repo, your plugins, or providers like Notion and Confluence synced into incident.io. Find the runbook that owns a symptom, follow its read-only diagnostic flow, write new runbooks into the right home, and keep a corpus honest (curate from closed incidents, split bloated files, verify claims against the code). |
| [architecture](./skills/architecture) | Answer estate questions — "how does X run", "what is Y", "where does Z live" — from architecture docs wherever they live, cited rather than guessed. And write those docs through an interview that pins down what each system actually is before anything is written. Pairs with runbooks: runbooks own procedures, architecture owns facts. |
| [skill-authoring](./skills/skill-authoring) | Create and improve the skills in your own plugins — the ones incident.io's agents and your coding agents load. Author a new skill from concrete trigger examples, or improve an existing one from incident.io's per-skill usage feedback without undoing what the feedback credits. Carries the format rules and the empirical patterns that make skills get selected and followed. |
| [init](./skills/init) | Walk a team through setting up their incident.io agent estate — and through growing it later. Inventory what exists (connections first), bootstrap architecture docs and runbooks through their skills, identify the two or three skills worth writing from what actually pages, scaffold a plugin, and register it. Safe to re-run: it states what already exists and creates only what's missing. |
| [doctor](./skills/doctor) | Review the health of your incident.io agent estate and say what to fix, without fixing anything itself. Checks plugins and their skills end to end — sync failures, skills that load but don't get followed, feedback issues worth acting on, convention drift — and reports what it can't read honestly. Every finding routes somewhere: a brief for skill-authoring, a gap for init, or a dashboard page. Built to recur. |
| [extensions-review](./skills/extensions-review) | Review what your extensions did over a window — the skill loads that made a real difference, each verified against the incident or conversation it happened in, plus the incidents no skill or runbook covered, turned into briefs for what to write next. Delivers as a chat thread, a document, or plain text, so it suits a scheduled digest. Doctor says whether the estate is healthy; this says what it actually did. |

## Connections

Every connection these skills call, and where it comes from in each environment:

| Connection | Coding agent on your machine | incident.io hosted agents |
|-----------|------------------------------|---------------------------|
| incident.io | The bundled MCP server (`.mcp.json`), authenticated over OAuth on first use | Native tools with the same capabilities |

Skills may also use provider tools the session already has (a Notion search, a wiki
search) — those are the session's, not dependencies of this plugin.

## How these skills are designed

The skills follow one deliberate pattern — machinery in the plugin, your content wherever
you keep it, one interface across every environment, conventions as the contract, and
epistemics that keep produced content honest. [docs/philosophy.md](./docs/philosophy.md)
describes the pattern; new skills are judged against it.
[docs/agent-environments.md](./docs/agent-environments.md) maps the environments the
skills run in — filesystem layouts, tools per capability, and the shared search strategy.

## Where your content lives

This plugin carries incident.io's guidance, not your content. Runbooks, architecture notes,
and other operational knowledge belong in your own repositories, where they live next to the
code they describe and are reviewed like it. The skills here help you write that content
well and keep it current.
