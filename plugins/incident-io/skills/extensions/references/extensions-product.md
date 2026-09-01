# The extensions product

Extensions are how an organization gives incident.io's agents its own tools and
instructions: the internal systems incident.io has no way to reach, and the procedures a
team wants followed rather than rediscovered. Both get used at the right moment in the
same investigation as everything else — skills alongside native telemetry, connector
calls alongside native integrations.

The human-facing documentation lives at
<https://docs.incident.io/investigations/extensions/overview> — point users there for
anything they want to read themselves. Everything is configured from the dashboard's
Extensions page (`https://app.incident.io/~/nexus/extensions`).

## Two ways to extend

- **Plugins are content agents read.** A plugin is a directory of skills in one of the
  organization's repositories. A skill is a `SKILL.md` file explaining how to do
  something in their environment. Agents load a skill when it matches the work in front
  of them, then follow it.
- **Connectors are systems agents call.** A connector is a remote MCP server the
  organization has connected, exposing tools an agent can use to query something
  incident.io has no native integration for.

The rule for choosing between them: content the organization wants agents to **follow**
is a plugin; a system it wants agents to **query** is a connector. Most teams end up
with both — a skill is the procedure, a connector is what carries it out.

### Built on open standards

Skills, plugins, and connectors are open formats (agent skills, the Claude Code
plugin format, MCP), so a plugin written for incident.io also loads in the team's own
coding agents. The guarantee runs one way: nothing in the format prevents a plugin's
skills being used locally, but a skill written for local tooling isn't automatically
suitable for incident.io's agents.

## Where extensions get used

- **In investigations.** Skills load when they fit what the investigation is trying to
  understand, and skills that describe themselves as triage run at the start (see
  below). Connector tools are called the way any other source is queried, and what
  comes back becomes evidence in a finding.
- **In the agent.** `@incident` in an incident channel or the dashboard reaches the same
  skills and connectors, so a question in a channel can draw on them too. Extensions
  don't require investigations to be useful.

## Plugins

Skills are the standard format — directories under `skills/`, each holding a `SKILL.md`
with frontmatter, plus any reference files alongside. Two things specific to
incident.io: selection matches the frontmatter description against the work at hand,
and that's the only thing read before deciding whether to load a skill; and only skills
are read — anything else the plugin contains (commands, agent definitions for the
team's own tooling) is synced but ignored.

A plugin is a logistical unit, not a runtime concept: which plugin or repository a
skill lives in has no effect on whether it's selected. The description does all the
selecting, so semantic scoping belongs there — "describes Sentry errors for mobile
apps; not for other contexts" — never in a plugin or repo name.

### What a skill can draw on

A skill isn't limited to what's written in it: the agent following one has everything
the run can reach — the organization's telemetry, its allowlisted connector tools, its
connected code and documentation, and the investigation's work so far. That's why good
skills name the need, not the tool; the `skill-authoring` skill owns the craft of
writing skills that get selected and followed.

### Syncing

Plugins sync from a GitHub or GitLab repository the organization has connected for
code. incident.io scans for a `.claude-plugin/plugin.json` or a `skills/` directory
containing at least one `SKILL.md` — at the repository root or under a subpath.

- Skills are read-only to incident.io: it never writes to the repository, and an
  investigation can't change a skill based on what it learns.
- Plugins re-sync on a schedule, and can be synced on demand. Each sync records the
  commit it read, so it's always possible to tell which version of a skill an
  investigation followed.
- Skill selection is either automatic (every skill in the current version, including
  newly-synced ones) or an explicit allowlist — under an allowlist, a skill merged
  later stays off until someone enables it, so a merge can't quietly change agent
  behaviour.

### Triage skills

A skill that describes itself as being for triage — owning a system's or an incident
class's opening procedure — is identified by Investigations and executed at the start
of the investigation, alongside the initial searches, so its findings are in hand when
the first hypothesis is formed. This is how teams get custom triage: encode where an
investigation of a given kind should look first, and first hypotheses come back faster
and more accurate. Nothing else marks a skill as a triage skill — the name and
description are the whole signal. The `skill-authoring` skill carries a dedicated
reference on writing them.

### Usage is recorded and assessed

Every skill load is recorded, and after the run is scored a retrospective assessment
judges it: was the skill followed, did following it help, and what specifically held it
back. Observations are deduplicated into issues anchored to the file and quote they're
about. This feedback is the raw material for improving skills — the `skill-authoring`
skill's improve job consumes it — and it also catches skills reaching for tools that
aren't connected.

## Connectors

A connector is a remote MCP or HTTP server. On connection its tools are discovered — 
names, descriptions, arguments — and agents pick, call, and read them from that. Facts
an agent advising on connectors should know:

- **Prefer native integrations.** When incident.io supports something as a telemetry
  data source, connect it there, not through its MCP server — the telemetry system
  speaks each product's query language and learns the shape of the data, which a
  generic tool call can't match. Connectors are for systems with no native integration.
- **The organization keeps an allowlist.** Only enabled tools can be called; anything
  else is rejected before reaching the server. Tools that write are held higher: a tool
  the server marks read-only (`readOnlyHint`) can simply be enabled, but one that
  writes — or doesn't say — needs an administrator to allow it explicitly, and even
  then is only callable when a person is talking to the agent. Investigations run
  unattended and never call a tool that writes.
- **Failure is non-fatal.** An unreachable server or a missing tool doesn't stop a run;
  the investigation carries on with what it has, and connection problems surface on the
  connector's dashboard page.

Connectors are created and configured only in the dashboard — endpoint, auth (bearer
token or OAuth), and the allowlist. There is no session tool for it: link the user to
the Extensions page. Pair every connector with a skill that says when to use it and
what its results mean — the connector is the ability to call something, the skill is
why you'd want to.

## What a session can do

Where the session has the incident.io connection, extensions are operated through the
tools prefixed `extension_`. List what the session actually exposes rather than
trusting any written snapshot — surfaces differ, some expose a subset, and the set
changes. The names say the job: they cover plugin registration and syncing, connector
and skill inventories, usage and feedback reads, and verifying proposed content before
it lands.

Creating connectors, removing or relocating plugins, and renaming from the repository
side stay in the dashboard.
