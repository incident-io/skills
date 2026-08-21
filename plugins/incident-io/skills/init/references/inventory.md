# Inventory the estate

One read of what exists, taken before anything is proposed or created — init runs it
first on every invocation, day zero and re-run alike. The output is the block at the
end — every line either sourced from a tool, confirmed by the user, or an honest
`unknown — <how to find out>`.

## 1. What can this session reach?

Feature-test, don't assume. Check for each of these and note presence or absence
without comment — absence changes the route, not the goal:

- **The incident.io connection** — try a cheap read (`extension_plugin_list`). Without
  it, the whole inventory comes from the user and the dashboard; say so and carry on.
- **The extension tools** on that connection (`extension_plugin_list`,
  `extension_plugin_create`, `extension_plugin_sync`) — some MCP surfaces expose a
  subset.
- **A filesystem and repository** — is the session in a checkout the team can land
  changes from?

## 2. Plugins

`extension_plugin_list` — for each plugin: name, sync state, and its skills. Note
anything in a sync-error state; that's a finding for the report, not something init
fixes silently. Without the tool, ask the user to read the dashboard's Extensions
page.

Where the session can reach a plugin's repository, check it for a previous init
report (a dated file, or the registering pull request) — it carries what earlier runs
considered and declined, so this run doesn't re-litigate it.

## 3. Connections

Connections bound what any skill can do, so read them before proposing anything. In
order of preference:

- `extension_connector_list` on the incident.io connection, where the session has it
  — each connection with its type, enabled state, capabilities, the tools it exposes,
  and its connection status. A connection needing re-authentication is a finding. An
  absent tools list means nothing is callable there; `tools_unlisted: true` means
  callable but not named — say "tools unlisted", not "no tools".
- The `telemetry://datasources` resource, where the session reads MCP resources —
  the same inventory without health.
- Otherwise: ask the user to read the dashboard's data sources page, and record what
  they report — including anything shown as needing re-authentication, which is a
  finding.

All three surfaces cover telemetry and tool connections only. Source-control integrations
(GitHub, GitLab) don't appear in them, and registration in step 4 needs that state:
ask the user, or have them confirm on the dashboard's integrations page, and record
it.

Record when each connection was made, if a surface or the user can say — a young
connection changes how its data reads below. A disabled connection is a status line,
not a gap, unless the paging data shows evidence living behind it.

## 4. What actually pages?

The paging reality is what candidate skills are mined from. Two reads, both cheap:

- `alert_stats(group_by: ["source"], sort_groups_by: "workload", created_after:
  "<~90 days ago>")` — which alert sources generate the most on-call work, with
  workload minutes, not just counts.
- `incident_stats(group_by: ["type"], sort_groups_by: "workload", created_after:
  "<~90 days ago>")` — where incident time goes. Grouping by `team` instead
  answers the same question per team.

A source connected more recently than the window covers ranks on partial data — a
three-day-old connection can top a 90-day workload ranking without meaning anything
yet. Say so in the Paging line rather than reporting it as the top source; "we just
connected X" runs hit exactly this.

A young organization with little history here is normal: record the volumes and move
on — step 3 of init will propose less, which is correct.

## 5. Content

Does the organization already have runbooks and architecture docs somewhere agents
can find them? Use the search jobs of the `runbooks` and `architecture` skills for
this rather than re-deriving it — a quick probe of each skill's find/answer surfaces
is enough to say "a corpus exists at <where>" or "none found". Where those skills
aren't loadable in this session, ask the user where their runbooks and architecture
docs live, and record the answer as user-reported.

## The inventory block

End with this block, filled in. It is the input to every later step, and on a re-run
it is most of the output — lines that say "already in place" are the idempotence.

```markdown
# Estate inventory — <date>

- **Session:** <incident.io connection? extension tools? repo checkout?>
- **Plugins:** <name — sync state — skill count, one line each | none>
- **Connections:** <name — type — status — capabilities — connected since, one line each | none beyond incident.io>
- **Source control:** <GitHub/GitLab integration state, user-confirmed | unknown>
- **Paging:** <top sources/types by workload over the window, or "little history">
- **Content:** <runbooks corpus at <where> | none found; architecture docs likewise>
- **Gaps:** <connections needing creation or re-auth, sync errors, missing content —
  each with where it gets fixed>
```
