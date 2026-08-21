---
name: extensions-review
description: >
  Review what your extensions did over a period: the skill loads that made a real
  difference, told through the incident or conversation each one happened in, and the
  incidents no skill or runbook covered. Use whenever anyone wants a review, digest,
  or pulse of extension or skill usage over a window — "how did our skills do this
  week", "post yesterday's extensions review to our channel" — one-off or on a
  schedule. Whether the estate is healthy (sync state, funnels, issues to fix) is the
  doctor skill, not this one.
argument-hint: "<the window and where to deliver — e.g. 'last 24 hours, post to #extensions'>"
---

# Extensions review

After an agent loads a skill, incident.io assesses the load once the run is scored:
did the agent follow the skill, did following it help, and a short written account of
what happened. This skill turns a window of those assessments into a story people
read — the loads where an extension let an agent do something it could not have done
alone, and the incidents where no extension helped — so the team sees what their
content earns and what to write next.

The model that shapes everything here: **an assessment is a claim about a run; the
run is the evidence.** The written account routinely understates or inverts what the
run shows, so nothing is published from the assessment alone — every published item
is read at its source first. And assessment lags the run it judges, so a recurring
review windows on when loads were assessed, not when they happened: that way each
load is seen exactly once, and none are missed for being assessed late.

## The two legs

- **Usage** — pull the window's assessed loads, shortlist the few that clear the
  bar, verify each against the run it happened in, and write them as standalone
  items. → [references/usage.md](references/usage.md)
- **Gaps** — the same window's incidents, checked for coverage: which ones no skill
  load touched, whether an extension could have advanced them, and a brief for each
  gap worth filling. → [references/gaps.md](references/gaps.md)

Run both for a full review. A request for one ("what got used", "what are we
missing") runs that leg alone: do not read the other leg's reference, run its
preflight, or name its capabilities in the report — a usage-only review that fails
its preflight names the three census surfaces and nothing more. Both legs end in one report —
[references/report.md](references/report.md) owns its shape and how it is delivered,
including "post to a channel" requests.

## Ground rules

- **Read before you publish.** A load may only appear in the report after its source
  — the investigation or the conversation — has been read and supports it. Where the
  source is unreadable from this session, the item is either dropped or written as
  the assessment's claim, marked as such — never asserted as fact.
- **Platform rows are not extensions.** A load row with no `plugin_id` belongs to the
  platform's own agent machinery. The per-plugin pull never sees them; drop them
  whenever the global stream is read instead. The managed incident.io plugin's rows
  (which carry a `plugin_id`) count.
- **Show a miss when the window has one.** A review that only shows wins reads as
  marketing and stops being read. The best miss names the line of content that
  caused it.
- **A quiet window is a finding.** When nothing clears the bar, say so in one line
  with the load count — never inflate a routine load into a highlight.
- **This skill reads and reports.** It edits no content and dismisses no feedback.
  Gap briefs are proposals for the skills that act on them.

## What this skill is not for

- **Estate health** — sync failures, funnels, feedback issues worth acting on,
  convention drift — is the `doctor` skill. Doctor aggregates and diagnoses; this
  skill narrates a window. Where this review notices a health problem (a plugin that
  stopped syncing, a skill whose loads keep hurting), note it in one line and route
  it to doctor rather than absorbing the diagnosis.
- **Editing a skill** from what a review found is the `skill-authoring` skill's
  improve job; **writing a missing runbook** is the `runbooks` skill's write job. Gap
  briefs hand over there.
- **A skill's cumulative track record** — rates, open issues, examples — is
  `extension_skill_feedback_list` and the dashboard's extensions pages, not a window
  review.
