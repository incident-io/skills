---
name: doctor
description: >
  Review the health of your incident.io agent estate — plugins, skills, connections —
  and say what to fix, without fixing anything itself. Use whenever anyone asks
  whether their incident.io setup is healthy, what's degraded, or what to improve, in
  any phrasing — one-off or as a recurring review. Every finding routes to the thing
  that fixes it.
argument-hint: "<a plugin or area to focus on — or nothing, to be shown what can be reviewed from here>"
---

# Doctor

A review, not a repair: doctor reads the estate, ranks what it finds, and hands each
finding to the thing that fixes it. It never edits a plugin's tree (skills, README,
docs — any file), never re-syncs, never changes a setting, and never writes into the
estate — the report itself is handed over, not filed. All of this holds when it runs
on a schedule. That's what makes it safe to run weekly and boring to read when
everything is fine, which is the goal.

## The shape of a run

1. **Orient** — a fast pass, cheap reads only: where the session is, whether a plugin
   lives here and corresponds to one the account knows, and what the account's own
   health rollup says. Ends in a compact situating block the user sees within
   seconds. → [references/orient.md](references/orient.md)
2. **Offer** — an interactive, unscoped invocation pauses on that block plus a short
   menu of the reviews that make sense from here, each with an honest cost signal,
   and waits for the pick. A scoped invocation or a scheduled run skips the pause —
   orient silently and go. The skip rules are in orient.md.
3. **Review** — the chosen legs, below.
4. **Report** — the situating block leads, findings are one-line entries with routes,
   and the briefs carry the detail, per [references/report.md](references/report.md).

## The legs

- **Extensions** — plugins and their skills, checked end to end: sync state, how
  skills perform once loaded, the feedback issues worth acting on, feedback
  orphaned by renames, and convention drift against the authoring rules.
  → [references/extensions.md](references/extensions.md)
- **Connections and telemetry** — what this session can and cannot read about the
  rest of the estate, stated honestly.
  → [references/telemetry.md](references/telemetry.md)
- **Content drift** — the copies that were right when written: runbooks restating what
  a skill owns, procedures naming levers that no longer exist, pointers to homes that
  don't hold the content, and skill-shaped knowledge with no skill to live in.
  → [references/content-drift.md](references/content-drift.md)

Run all three for a whole-estate review; run what the user picked otherwise.

## Ground rules

- **Propose-only, always.** Every finding becomes a route: an improvement brief for
  the `skill-authoring` skill's improve job, a structural gap for the `init` skill, a
  change in the plugin's repository, or a named dashboard page. Doctor stops at the
  hand-off — the report is the run's last act, and acting on a brief is a new job the
  user starts, never a continuation of this one.
- **Verify before alarming.** A computed status is a hint, not a verdict: check an
  issue's anchor against the current tree, and apply the reading corrections in
  skill-authoring's [improve reference](../skill-authoring/references/improve.md)
  before reporting an issue as real or resolved.
- **An unreadable surface is reported, not guessed.** Where this session has no way
  to read part of the estate, the report says so and names where the answer lives.
  Never pad a leg with speculation to look thorough.
- **Healthy is a finding.** "All plugins synced, no actionable issues" is a complete
  and useful report line, not a failure to find something.

## What this skill is not for

Setting the estate up or growing it — that's `init` (which routes here for reviews,
as this skill routes there for gaps). Making the edits — that's `skill-authoring`.
And incident response: doctor reviews the machinery agents use, not live incidents.
