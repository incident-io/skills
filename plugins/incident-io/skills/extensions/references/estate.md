# The estate

What a ready incident.io agent estate has, how to measure what exists, and where to
route what's missing. One walk, three starting points:

- **From scratch** — nothing exists yet. Start by asking what the user wants to
  create first — where their request doesn't already say. Advise that it's often
  helpful to start with a specific use case in mind, but every option is valid:

  - a skill that triages a specific class of incident
  - a skill for working with a connector
  - architecture docs
  - runbooks (the skills they lean on come first —
    [choosing-a-mechanism.md](choosing-a-mechanism.md) has the line)
  - an empty plugin, content to follow

  Then walk the checks as a setup run, creating in dependency order: the connections
  the goal needs, then the content (a first skill is drafted and verified before
  anything ships, with the architecture docs it needs written as part of writing it),
  then the plugin registered around whatever syncs. Whatever wasn't chosen first
  stays a standing offer once setup has landed — never a gate before it. A failed
  check is an exit:
  hand the fix to the route named beside it, then come back and continue the walk.
  Fixes that happen in the dashboard (connections, integrations) are linked, not
  waited on — continue with what exists and note the gap.
- **Existing skills, but no incident plugin** — the team already keeps skills or docs
  for their own agents. The same setup run as from scratch, with one difference: the
  existing content is material to adapt into the new plugin, not a home to take over —
  check 3 says how to tell which situation a found plugin is.
- **A working plugin, adding to it** — the user wants a new skill or doc, or advice.
  The walk is a readiness pre-check: confirm everything the new piece needs exists
  (the connections it leans on, a healthy sync, skill selection that will pick it up),
  record it, and hand over to the owning skill. Nothing is created here.

Whatever the starting point, a walk against a mature estate produces mostly "in place"
lines. That's the walk working, not failing.

## What ready looks like

Two tiers, and the difference matters. **Hard requirements** are what the platform
needs before anything can work — hold these. Everything else is a **recommendation**
that produces better results — explain why, then respect the user's choice.

Required:

- A source-control integration (GitHub or GitLab) incident.io can read the plugin's
  repository through — without it, nothing syncs
- A plugin registered and syncing cleanly, with the skills the team intends enabled

Recommended:

- The connections the team's skills lean on, healthy — nothing awaiting
  re-authentication. (Required in one case: a skill that reads through a connection
  can't work without it, so a narrow goal inherits the connections it needs.)
- Architecture docs and runbooks somewhere agents can find them
- Skills in the plugin that earn their place in real incidents

When several pieces are missing, fix in that order: source control gates plugin
registration, and connections bound what any skill can do, so both come before content
that leans on them. Every creation is proposed and confirmed before it's made, per the
skill's ground rules.

Match the walk's depth to the user's intent. Some users want the detailed setup;
others have one narrow use case in mind ("I just want a triage skill for checkout
failures"). For a narrow intent, hold the requirements that goal actually needs,
recommend the rest in a line each, and proceed — a recommendation declined is a report
line, never a blocker.

## 1. What can this session reach?

Feature-test, don't assume. Absence changes the route, not the goal — note presence or
absence without comment:

- **The incident.io connection** — try a cheap read (`extension_plugin_list`). Without
  it, every measurement below comes from the user and the dashboard; say so and carry
  on.
- **The extension tools** on that connection — some surfaces expose a subset of
  `extension_plugin_list` / `extension_plugin_create` / `extension_plugin_sync` /
  `extension_plugin_update`.
- **A filesystem and repository** — is the session in a checkout the team can land
  changes from?

Where the session can reach the plugin's repository, check it for a previous estate
report (a dated file, or the registering pull request) — it carries what earlier runs
considered and declined, so this run doesn't re-litigate it.

## Configuration

### 2. Source control

**Ready:** a GitHub or GitLab integration connected, covering the repository the plugin
lives (or will live) in.

**Measure:** no extension surface reports this — ask the user, or have them confirm on
the dashboard's integrations page, and record it as user-confirmed.

**Missing:** link the user to the dashboard's integrations page. Nothing plugin-shaped
can be registered until this exists.

### 3. The plugin

**Ready:** a plugin registered against the team's repository, last sync completed, and
skill selection covering what the team intends (automatic mode, or an allowlist that
includes the skills they expect agents to load).

**Measure:** `extension_plugin_list` — each plugin's name, sync state, and skills.
Without the tool, ask the user to read the dashboard's Extensions page.

**Missing or broken:**

- No plugin → [scaffold.md](scaffold.md) creates and registers one — though for a
  first skill, drafting and verifying it comes before registering (scaffold says how).
  Never create a second plugin beside a working one without the user asking.
- A sync error → the repository is unreachable or the tree malformed; scaffold.md's
  verify step covers diagnosing it.
- Selection excluding an expected skill → `extension_plugin_update` (or the dashboard)
  enables it; confirm which skills before changing selection, since it's set
  whole-state.
- No `AGENTS.md` (or `CLAUDE.md`) at the plugin root telling agents to load the
  `extensions` skill before editing here → offer to add one
  ([scaffold.md](scaffold.md)'s tree section has the instruction and the harness
  naming rule).

**A plugin found on disk:** when the session's checkout holds a plugin (a
`.claude-plugin/` manifest, or a `skills/` tree of `SKILL.md` files), classify it
before working in it:

- **It's the registered plugin** — its repository and subpath match an entry in
  `extension_plugin_list`. This is the estate's plugin: new skills go in it.
- **It's not registered** — a plugin the team keeps for other tooling. Don't take it
  over: registering an existing plugin wholesale ships every skill in it to
  incident.io's agents, and content written for other callers may not fit. Create the
  incident plugin fresh ([scaffold.md](scaffold.md)) and treat the found plugin's
  skills and docs as material — adapt what earns its place through the
  `skill-authoring` skill, rather than syncing it as-is.

### 4. Connections

**Ready:** the telemetry sources and connectors the team's skills lean on, connected
and healthy — `connection_status` good, no `reconnection_reason` set.

**Measure:** in order of preference:

1. `extension_connector_list` — each connection with its type, enabled state,
   capabilities, the tools it exposes, and health. An absent tools list means nothing
   is callable there; `tools_unlisted: true` means callable but not named — say "tools
   unlisted", never "no tools". Entries with no capabilities are grouping or
   credential nodes whose children carry the queryable capabilities.
2. Where the session reads MCP resources, `telemetry://datasources` gives the same
   inventory without health.
3. Otherwise ask the user to read the dashboard's data sources page and record what
   they report.

Record when each connection was made where a surface or the user can say — a young
connection changes how its data reads in check 7.

**Missing or broken:** connections are created and re-authenticated in the dashboard,
never from a session. Case by case:

- Missing → link the user to the dashboard's Extensions page, note the gap, and
  continue with what exists.
- Needing re-authentication → a finding for the report.
- Disabled → a status line, not a gap, unless evidence lives behind it.
- Exists but lacks the auth type or tools a stated goal needs → a blocker to surface
  now, before any authoring starts — not something to discover after a skill is
  written against it.

## Content

### 5. Architecture docs and runbooks

**Ready:** a corpus of each exists somewhere agents can find it — the repository, a
plugin, or a connected provider like Notion or Confluence.

**Measure:** use the search jobs of the `runbooks` and `architecture` skills rather
than re-deriving them — a quick probe of each skill's find/answer surface is enough to
say "a corpus exists at <where>" or "none found". Where those skills aren't loadable,
ask the user where theirs live and record the answer as user-reported.

**Missing:** neither corpus is a gate on setup.

- Architecture docs are written just-in-time: creating a skill captures the docs that
  skill needs through the `architecture` skill's write job; a general corpus can
  follow — during setup where the user wants it.
- Runbooks are most valuable once there's incident history to curate from (the
  `runbooks` skill's curate job mines closed incidents); a team with an
  already-practised procedure can write one any time — writing the skill it leans
  on first.

### 6. Skills

**Ready:** the plugin holds skills that earn their place in real incidents — including,
where the team wants custom triage, skills that describe themselves as such.

**Measure:** the skill list from `extension_plugin_list`, read against what actually
pages (check 7). An empty or thin skills list on a young estate is normal, not a gap.

**Missing:** writing a skill is the `skill-authoring` skill's create job, and mapping a
problem to the right mechanism first is
[choosing-a-mechanism.md](choosing-a-mechanism.md). Propose, don't push: the paging
read says where a skill would earn its keep, and the user decides what's worth writing.

## The estate report

End the walk with this block, filled in — every line either sourced from a tool,
confirmed by the user, or an honest `unknown — <how to find out>`. On a setup run, add
what was created and what happens next: when agents will see the skills, where
feedback will accumulate, and the standing offers — a general architecture corpus, and
runbooks once there are incidents to learn from. Offer to keep the report in the
plugin's repository — a dated file, or the pull request description — so the next run
sees what was already considered.

```markdown
# Estate report — <date>

- **Session:** <incident.io connection? extension tools? repo checkout?>
- **Source control:** <GitHub/GitLab integration state, user-confirmed | unknown>
- **Plugin:** <name — sync state — skill count | none>
- **Connections:** <name — type — status — capabilities — connected since, one line each | none beyond incident.io>
- **Content:** <runbooks corpus at <where> | none found; architecture docs likewise>
- **Gaps:** <each missing or broken piece, with the route that fixes it | none>
```
