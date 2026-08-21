---
name: init
description: >
  Walk a team through setting up their incident.io agent estate — and through growing
  it later. Use whenever someone is getting started with incident.io skills, plugins,
  or connections in any way, or asking what to add next after something changed ("we
  just connected Datadog"). Safe to re-run: it states what exists and creates only
  what's missing.
argument-hint: "<what changed, if anything — or nothing, for a first setup>"
---

# Init

A walkthrough, not a script: work one step at a time with the user, confirm before
creating anything, and say plainly what already exists before proposing anything new.
Re-running init against a mature estate should produce mostly "already in place" lines
and at most a couple of proposals — that's the tool working, not failing.

## The steps

1. **Inventory** — what the session can reach, and what the organization already has:
   plugins, connections and their state, what actually pages. Connections come first
   because they bound every later step: a skill whose evidence lives behind a
   connection nobody has made can't work.
   → [references/inventory.md](references/inventory.md)
2. **Foundations** — the content agents draw on before any custom skill matters.
   Architecture docs and runbooks have their own skills in this plugin; init routes
   there rather than duplicating them: the `architecture` skill's write job for "what
   is each system", the `runbooks` skill's write and curate jobs for procedures. A
   team with no content yet starts here, not with skills; where the inventory found a
   corpus, this step is one "already in place" line.
3. **Candidates** — from the inventory and the incident history, the two or three
   skills worth writing first, each proposed as a one-line brief the user can accept
   or decline. → [references/candidates.md](references/candidates.md)
4. **Scaffold and register** — create the plugin tree in the team's repository,
   register it with incident.io, and verify the first sync landed.
   → [references/scaffold.md](references/scaffold.md)
5. **Hand over** — say how the estate improves from here: skills accumulate usage
   feedback as agents load them, and the `skill-authoring` skill's improve job turns
   that feedback into edits. Suggest re-running init at the next growth moment — a
   new connection, a new team, a new class of incident.

Steps are ordered but not all mandatory: a growth-moment re-run ("we added Datadog")
usually touches steps 1 and 3 only. Start every run with step 1 regardless — the
inventory is what makes the run idempotent. Where the inventory surfaces a foundation
gap (no architecture docs, no runbooks corpus), raise it as one routed line even on a
re-run; don't silently skip step 2 because the run started elsewhere.

## Ground rules

- **Confirm before creating.** Every artefact — a directory, a registration, a doc —
  is proposed with what it will contain, and made only on a yes.
- **Connections are created in the dashboard, never here.** Connecting a tool to
  incident.io is an authentication flow. Where the inventory finds a gap, link the
  user to the dashboard's settings for it (with `open_url` where the session has it,
  or by naming the page) and continue with what exists; re-run when it's connected.
- **Route, don't absorb.** Architecture content belongs to the `architecture` skill,
  runbooks to `runbooks`, skill drafting to `skill-authoring`. Init owns the order and
  the estate-level decisions; it never writes those artefacts itself.
- **A thin estate is a valid finding.** A team with one connection and no incidents
  yet gets a short honest report and one proposal, not a padded plan.

## What this skill is not for

Writing or improving one named skill — that's `skill-authoring`, which also owns the
authoring conventions init's scaffold points at. And a health review of the existing
estate ("is everything working? what's degraded?") is the `doctor` skill's job: init
inventories to decide what to create, and won't stretch that inventory into a health
verdict.
