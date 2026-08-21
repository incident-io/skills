# Orient

Every run starts here: a fast pass, cheap reads only, that answers three questions and
ends in a situating block. Nothing in this phase verifies an anchor, pulls feedback
issues, or reads a runbook — the point is that the user sees something true and useful
within seconds, and the expensive review runs only after they've chosen it.

## The three questions

1. **Where is this session?** The working directory; whether it's a git checkout and of
   what (the remote names the repository); whether the checkout lags the branch the
   plugin syncs from — a lagging checkout changes what the review verifies against
   (see content-drift's rules). And whether a plugin tree lives here: an
   `incident.yaml`, a skills directory, a runbooks corpus.
2. **Does what's here correspond to a plugin the account knows?**
   `extension_plugin_list`, matched against the local tree. Three outcomes, each a
   line in the block: this checkout carries a synced plugin (name it, with sync state
   and skill count); the account has plugins whose trees aren't in this checkout
   (name them — they're reviewable through feedback and account data, not through
   their files); or there's no incident.io connection at all (say so, and offer only
   what files alone can support).
3. **What does the account's own rollup already know?** `extension_connector_list`
   and `nexus_health_show`, one call each: connections with status, sources with
   query statistics. This is the same rollup the dashboard computes, so the block can
   never disagree with what the user sees there.

## The situating block

Compact, one line per fact, status glyphs doing the summarizing — ✓ healthy, ⚠
degraded, ✗ failing:

```markdown
# Doctor — where you are

Session   <repo and checkout state> · <incident.io connection ✓ | no incident.io connection>
This repo <plugin dir → synced as "<name>", <last sync>, <n> skills | no plugin tree>
Account   plugins: <name ✓|⚠ per plugin, trees-not-here noted> | <none>
Health    <n> connections — <n> ✓ · <each degraded one: name, glyph, one-phrase reason>
```

Three rules keep it honest:

- Every line is sourced from a tool this pass actually called, or reads
  `unknown — <how to find out>`.
- Glyphs come from the rollup's own judgments (attention reasons, reconnection
  needed, low success rate), never recomputed here — orientation summarizes, the
  review verifies.
- A connection with no queries in the stats window is "never queried", not healthy
  and not unhealthy — the same correction telemetry.md applies.

## The offer

After the block, offer the runs that make sense *from here* — built from what
orientation found, never a fixed list — each with an honest cost signal:

- **Deep review of <the local plugin>** — feedback, anchor verification, content
  drift. The thorough one: minutes, and where the verified findings come from.
- **Estate health snapshot** — the block above expanded with per-source query
  statistics and per-plugin feedback funnels, nothing verified. Moments.
- **Feedback triage** — open issues across every synced plugin, verified against
  their anchors and clustered into briefs. Between the two.
- **Everything** — all applicable legs, the full report.

Then stop: the block plus the menu is the reply, and the user's pick starts the
review. Don't start gathering while they decide.

## When to skip the offer

- **The invocation already carries a scope** ("doctor for the ops plugin", a skill
  argument) — orient silently and go straight to that review; the situating block
  still opens the report.
- **Scheduled runs** — nobody is there to pick. Same: orient silently, run the agreed
  scope, block opens the report.
- **The snapshot answers the question by itself** ("is anything failing right now?")
  — answer it from the block and offer the deeper runs in one line. That can be the
  whole run.
