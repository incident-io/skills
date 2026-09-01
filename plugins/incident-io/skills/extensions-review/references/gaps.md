# The gaps leg

The usage leg reads the loads that happened; this leg reads the incidents that got no
help. It ends in gap briefs — proposals for content or connections worth adding —
routed to the skills that act on them. It changes nothing itself.

This leg needs the usage leg's corpus plus `incident_list` and `incident_show` on the
incident.io connection. When any of those is missing, say which and stop — generic
incident rows from a warehouse cannot settle candidates, recency, or scope, so
substituting them produces gap claims nothing can support. The coverage disclosure
names what was missing.

## 1. Build the coverage map

Group the usage leg's corpus by `incident_reference` — every row, whatever its
verdict, since coverage is any load, not only the helpful ones. The result maps each
incident to the skills that loaded during it. No further pulling: the corpus was
built per plugin with no verdict filter, so it already holds everything the map
needs.

The map errs toward false gaps, in three ways it cannot help. The corpus lists
**assessed loads only**, and assessment follows scoring, which follows the run — so
an incident from the last few hours can show no loads merely because nothing has
been assessed yet. It is **windowed on assessment**, so a load assessed just outside
the window is invisible even though its incident is inside it. And a plugin whose
paging was **capped** is missing its oldest-assessed rows entirely. All three are why
step 2 never declares a gap from the map alone: absence nominates a candidate, and
`incident_show` settles it.

## 2. List the window's incidents

```
incident_list(created_after: <start>, created_before: <end>, include: ["summary"], page_size: 50)
```

Page through, then diff against the coverage map. Four classes:

- **Covered** — one or more skill loads in the map. Usage-leg material; nothing to
  do here.
- **Merged or superseded** — an incident folded into another follows its primary:
  judge the primary, and give the duplicate one line.
- **Absent from the map** — a candidate, not yet a gap. Read `incident_show(id:
  <reference>, include: ["investigation"])`: an investigation that cites a runbook or
  shows skill activity is covered after all (the map's blind spots — see step 1);
  an incident still being scored is **too recent to judge**, left for the next
  review.
- **Confirmed uncovered** — the read shows an investigation that had nothing to
  reach for. These go to step 3.

## 3. Judge each uncovered incident

The test: **would an agent following a skill or a runbook have advanced this
incident's diagnosis?** Not every incident passes it — a stolen laptop, an office
outage, a people-process failure is out of scope, and saying so takes one line in
the coverage section, not a brief.

For each candidate that passes, work out from step 2's `incident_show` read what
was missing:

- **A missing skill** — the incident's system has no skill teaching an agent to
  interrogate it. The evidence is an investigation reasoning from scratch about a
  system a skill could have modelled: its tools, its vocabulary, its footguns.
- **A missing runbook** — the symptom recurs but no procedure owns it. The evidence
  is a runbooks-skill load whose account says no runbook matched, or an
  investigation that reconstructed a diagnostic path a document should carry.
- **A missing connection** — the diagnosis needed a system no tool in the estate
  reaches. The evidence is an investigation naming data it wanted and could not get.

A recurring symptom is the strongest signal: two incidents in one window with the
same shape and no coverage outrank any single gap. Check the window's other
uncovered incidents for the same signature before writing each brief.

## 4. Harvest standing capability gaps

The assessments already record one class of gap directly: feedback issues with theme
`capability_gap`, raised when a skill's step needed an integration the estate lacks.
For each plugin that loaded during the window, one call:

```
extension_skill_feedback_list(plugin: <name>)
```

and collect the open `capability_gap` issues. These are cumulative rather than
window-scoped — say so when reporting them — and an issue the organisation has
dismissed is an accepted tradeoff, not a gap to re-raise.

## 5. Write the briefs

Each gap becomes one brief in the report (shape in [report.md](report.md)), routed
to what acts on it:

- A missing skill → the `skill-authoring` skill's create job. The brief carries what
  create needs to start: the trigger examples (this window's symptom, in the words
  the alert or responder used), the system to teach, and the incidents as evidence.
- A missing runbook → the `runbooks` skill's write job, with the symptom and the
  diagnostic path the investigation had to reconstruct.
- A missing connection → the team's decision, made in the dashboard; the brief names
  the system and the questions it would have answered. Setting up structure from
  nothing — a first plugin, a first corpus — is the `extensions` skill's job.

Briefs are proposals. The report delivers them; a human decides. Where the same gap
was briefed in a previous review and declined, report it once as "previously
declined, still recurring" rather than re-escalating — the record of past reviews
lives wherever the team keeps them (the same home the doctor skill's reports use).
