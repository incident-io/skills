# Candidate skills

Turn the inventory into at most two or three proposed skills, each a one-line brief
the user accepts or declines. This step decides *what* is worth writing; the actual
drafting is the `skill-authoring` skill's create job, one accepted brief at a time.

## The test

A skill is worth writing when all three hold:

1. **It recurs.** The same shaped problem shows up repeatedly in the paging data —
   an alert source or incident type near the top of the workload ranking, not a
   one-off.
2. **The evidence is reachable.** The facts an agent would need to triage it live
   behind connections the inventory found working. A perfect skill for evidence
   nobody has connected is a connection proposal, not a skill proposal. Connected is
   not the same as readable: a connection serves an allowlisted subset, and individual
   fields can be restricted. Where a candidate rests on one particular fact, check that
   fact comes back before proposing the skill.
3. **A person does it by hand today.** There's a procedure someone follows — codes
   they look up, queries they run, a decision they make — that the skill would carry.
   If nobody can describe the procedure, it's a runbook interview first (route to the
   `runbooks` skill), not a skill.

## Mining the paging data

The inventory's workload rankings are the shortlist. For the top entries, ask what an
agent would do when one fires — the user knows; the data doesn't. Useful
probes:

- "When a <top source> alert fires, what does whoever's on call actually look at?"
- "Which of these do you triage the same way every time?"
- Where the organization assesses escalation urgency, `incident_stats(group_by:
  ["escalation_urgency", "alert_source"])` splits real pages from noise per source —
  a source that mostly produces deferrable noise may need tuning in incident.io, not
  a skill.

The rankings group by source, so a failure mode that presents under several sources'
names is invisible in them: one subsystem surfaces as a monitoring alert one week, a
support ticket the next, a stray error the week after. Search incident titles and
summaries for a subsystem's vocabulary as well, and treat a cluster that spans sources
as a strong candidate — recognising it is the work a responder repeats every time.

## Shape of a proposal

One line each, so the user can compare and choose:

```markdown
- **<skill name>** — when <trigger, quoting the real alert/request phrasing>, gather
  <evidence> via <connection>, and produce <the output a responder acts on>.
```

Propose the two or three with the best recurrence and reachability, and say why each
made the cut — "your top workload source" beats "seemed useful". Note what was
considered and dropped, in one line, so a re-run doesn't re-litigate it.

## What isn't a skill

- **Missing facts about systems** — architecture content; route to the
  `architecture` skill.
- **A procedure with no automation-worthy judgment** — a plain runbook; route to the
  `runbooks` skill. Skills earn their place when an agent must gather and weigh
  evidence, not just follow steps.
- **Unreachable evidence** — a connection gap; goes in the report's gaps line with
  the dashboard page that fixes it.

Each accepted brief goes to `skill-authoring`'s create job — including its interview,
which will deepen the one-line brief into concrete trigger examples. Declined briefs
are recorded in the run's report so the next run knows.
