# The extensions leg

Plugins and their skills, checked end to end. Needs the incident.io connection's
extension tools (`extension_plugin_list`, `extension_skill_feedback_list`); without
them, this leg reduces to asking the user to read the dashboard's Extensions page and
the per-plugin feedback panels, and recording what they report.

Work per plugin, in this order — each check feeds the next.

## 1. Sync state

`extension_plugin_list`: check sync first, because nothing downstream of a broken
sync is current — the report still orders findings most-actionable first, wherever a
sync problem ends up ranking. A `last_synced_at` far in the past on
a plugin whose repository changes often is worth a line too: agents may be following
stale instructions. Route: the error text usually says whether it's the repository
(fix there), the tree (a skill-authoring brief), or access (a dashboard page).

## 2. Are the skills earning their loads?

`extension_skill_feedback_list(plugin: "…")` per plugin, and read the funnel before
anything else. Two corrections first: the feedback lists only skills that have been
loaded, so "never loaded" is the set difference between step 1's skill list and the
feedback's; and the funnel covers only assessed loads, which trail usage — a young
skill's thin funnel is lag, not failure.

- **In step 1's skill list but absent from the feedback** — never loaded. Either the
  description never matches real requests (a skill-authoring brief: rewrite the
  trigger) or the skill serves a moment that has not yet occurred; say which is
  more likely from its description, and don't manufacture urgency about a young
  skill.
- **Loaded much, followed little** (high `not_used`) — the description over-promises.
  Brief: tighten the description to what the body delivers.
- **Followed but not helping** (`hurt` or persistent `neutral` contributions) — the
  instructions take runs the wrong way; the highest-severity skill finding there is.
  Brief with the examples the feedback carries.
- **Healthy funnels get a healthy line.** Name the skills that are working; the
  report reads as a review, not a complaint. A healthy funnel on a plugin whose sync
  is failing gets its credit with the caveat: the feedback describes the mounted
  version, not what's in the repository now.

## 3. The issues worth acting on

Issues arrive most-actionable-first, but doctor's job is triage, not transcription:

- First, check the plugin's repository for prior init and doctor reports (dated files
  under `docs/`, or pull requests — where pull requests aren't readable from this
  session, say so). They record what earlier runs proposed and what the team
  declined, and a declined issue is reported differently below; the record's home is
  agreed in [report.md](report.md)'s cadence section.
- Verify each issue's anchor (`target_file`, `target_quote`) against the plugin's
  current tree before reporting it — apply the "Read the feedback with these
  corrections" section of skill-authoring's
  [improve reference](../../skill-authoring/references/improve.md), including its
  distrust of `likely_resolved` (the rest of that file is edit-mode material; doctor
  stops at the brief). An issue that verifies becomes one line in a brief; an issue
  that doesn't is noted as probably stale, not escalated.
- Cluster by skill: one brief per skill carrying its verified issues — each with its
  `issue_key`, which the improve job uses to anchor its pre-ship verification to the
  recorded problem — and the strengths that must survive the fix, ready to hand to
  skill-authoring's improve job.
- An issue the team has already declined (a dismissal recorded over
  `extension_skill_feedback_update`, or a won't-fix note in the plugin's repository
  or pull requests) is reported once as "previously declined — still recurring", not
  re-escalated every run. Dismissed issues leave the feedback by default, so make one
  pass per review with `include_dismissed` — without it, a recurrence of a declined
  issue is indistinguishable from a new one, and the report can't honestly use the
  "previously declined" label at all.

## 4. Feedback orphaned by renames

A skill whose feedback says it isn't in the current version was renamed or removed —
which one is usually undecidable from the data, so ask the user rather than guessing.
Removed and meant to be: fine, one line. Renamed: its history no longer informs the
new directory — worth a line so the team knows the rename reset the skill's track
record, and a caution against repeating it casually.

## 5. Convention drift

Spot-check each plugin's tree against skill-authoring's
[format reference](../../skill-authoring/references/format.md) — this is a sample for
the report, not a full audit:

- Every skill directory registered in the plugin README's skills table; connections
  the skills call present in its connections table.
- No client-prefixed tool names or single-environment invocation syntax in skill
  bodies — these break the skill in environments the feedback may not cover.
- References that nothing links to.

Drift becomes part of the per-skill brief where one exists, or a small standalone
brief where the skill is otherwise healthy.

## What this leg does not do

Edit, re-sync, or dismiss. Where a fix is obvious, the brief says exactly what to
change — and stops there.
