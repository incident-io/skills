# Follow a runbook

You have a runbook — selected from a symptom (see [find.md](find.md)) or already named.
Follow it: work through its flow, running its read-only diagnostic steps and chaining out
where it points, to reach a likely cause and a recommended fix. The output is a runbook
execution, not just a route.

## What you work with

The procedure needs a few capabilities. Map each to whatever this session has:

| Need | Where to get it |
|---|---|
| Incident / symptom context | the symptom in hand; or `incident_show` on your incident.io MCP connection when an incident is named |
| Runbooks | the corpus — wherever [find.md](find.md) located the selected runbook |
| Architecture / system docs | your team's architecture or system docs, if the corpus or repo carries them — the `architecture` skill in this plugin routes estate questions to them |
| Live telemetry (the runbook's queries) | your telemetry tools — `ask_telemetry` on your incident.io MCP connection, or whatever observability access this session has |
| Code and git-history search | code search in your workspace, when the workspace holds the repo the runbook cites |
| Output | your scratch space for raw evidence; the result goes in your reply |

Where a capability is missing — no telemetry access, no checkout of the cited repo — don't
improvise a substitute. Record the affected steps as `unknown`, naming the tool you lacked.

Scratch space means your session's temporary directory — never the user's repository. If
you have no scratchpad, keep the evidence inline in your reply instead of creating files.

**Harvest before you query.** If the incident has an incident.io investigation (check with
`investigation_list`; read it via `incident_show` with `include: ["investigation"]`, or
`investigation_sync` for the full tree), take its findings first and run queries only for
the steps the investigation didn't answer. Sections answered from the investigation cite
it as their provenance; sections you filled with your own queries are labeled
`gap — filled fresh`. If the session has no investigation tools, or there is no
investigation, every step takes the fresh path — the procedure is unchanged.

## Bounds

Following a runbook means running queries — that is the job — but the work is bounded.
Follow the runbook's flow, run its steps, and stop at the runbook's own edges. Cap chained
runbooks at **two hops from the entry**: a well-formed corpus completes within that (see
[format.md](format.md)). If a chain wants a third hop, note it as a format finding rather
than following it. Per step, if
two or three attempts don't produce the answer, write `unknown — tried <what>` and move on.
An honest unknown is a valid answer; a stalled execution is not. Never mutate anything —
every step here is read-only.

## Walk the runbook

Walk the runbook's body in the order it's written — orient → classify → discriminate.

First, pin a representative event and its identifying tags (tenant or account ID, build SHA,
trace ID) where present — the runbook's queries filter and correlate on them, and the Symptom
output records them. Then run its steps as you go:

- **Run its diagnostic queries live.** Each runbook query is copy-paste runnable and names its
  datasource; run it against that datasource (telemetry, code or git search, a database
  replica — whatever it names). Save each query's raw text and output to your scratch space,
  one file per query, so a reader can re-run it.
- **Follow its decision tables.** A runbook classifies — map your query results onto its
  tables and classes to reach the branch that fits.
- **Ground components in your system docs.** Where the runbook names a system, deployment, or
  namespace, confirm what it is and where it runs from your team's architecture or system
  docs rather than general knowledge.
- **Follow its chains.** Where the runbook chains to a mechanism or technique runbook, follow
  that as a nested run — bounded to two hops from the entry.

**Following a runbook is read-only.** You run its *diagnostic* steps only. Runbooks write
fixes as recommendations for a human ("the lever is X"), never as steps to run — honor that.
Identify the offending deploy, PR, or data-state change and the fix site, and surface the fix
as a recommendation. Never flip a flag, revert, or write to production or any external system.

If your own query contradicts something the incident or its context records, keep both and
label the conflict plainly — a labeled contradiction is one of the most valuable things you
can surface.

## Output

Write `RESULT.md` in this shape, every section present, each a few plain sentences at most.
Every section states its provenance: cited to the investigation it was harvested from,
`gap — filled fresh` citing the saved query artifact, or `unknown — tried <what>`.

```markdown
# Runbook execution: <incident, alert, or symptom>

## Symptom
## Selected runbook
## What the runbook found
## Likely cause & recommended fix
## Unknowns and gaps
```

- **Symptom** — the pinned greppable string plus one representative event and its identifying
  tags where present.
- **Selected runbook** — the entry runbook followed and one line on why. If none was
  appropriate, say so and give the reason — the symptom you pinned, what you searched, and why
  the candidates didn't fit — then mark it a curation candidate and name the fallback technique
  you ran instead.
- **What the runbook found** — the diagnostic result of walking its flow, including any chained
  runbooks, cited to the artifacts you saved.
- **Likely cause & recommended fix** — a labeled hypothesis and the runbook's fix as a
  recommendation. Never applied.
- **Unknowns and gaps** — steps that didn't resolve, and anything the session had no tool for.

Your scratch space holds the raw evidence — query text plus output — one file per query,
referenced from RESULT.md by name. Include the RESULT.md content in your reply.

## Rules

- Read-only towards the world: no mutations of any kind. Every runbook step you run is a
  query, a grep, or a read; every fix is a recommendation.
- Recommend, don't drive: produce a result and recommend next steps; don't schedule other work
  or poll for state. Whatever invoked you decides what happens next.
- Follow the runbook's targeted steps, not a broad sweep. If the runbook's own flow answers a
  question, that's the answer — don't re-query it.
- Delegate, don't inline: the diagnostic method lives in the runbook and component facts live
  in your system docs where you have them. Cite the file you took a query or fact from.
- Plain language. Short sentences. No speculation outside the labeled hypothesis.
