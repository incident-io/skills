---
name: architecture
description: >
  Answer questions about how a team builds, deploys, and runs its software — what a
  system is, where it runs, what it depends on, and the real names of things (cloud
  projects, clusters, namespaces, hostnames, buckets) — from architecture docs wherever
  they live. Also guides writing those docs: an interview that pins down what each
  system actually is before anything is written. Use when asked "how does X run",
  "what is Y", "where does Z live", when grounding a component before debugging it, or
  when asked to write or improve architecture documentation.
argument-hint: "<an estate question to answer — or write to author architecture docs>"
---

# Architecture

Architecture docs describe what systems *are*: where they run, what they depend on, and
the real names of things. They pair with runbooks — runbooks own *procedures* (how to
diagnose and fix a failure), architecture owns *facts* (what the component is in the
first place) — and each side chains to the other rather than absorbing it. This skill
answers estate questions (the estate: everything you run and where) from those docs,
and guides writing them.

## The two jobs

- **Answer** — route a question ("how does X run", "what talks to Y") to the doc that
  owns it, across every place architecture docs can live, and answer from the doc with
  citations — never from general knowledge.
  → [references/answer.md](references/answer.md)
- **Write** — author or extend architecture docs. The heart of it is an interview that
  resolves what system names actually mean before anything is written: the names people
  use are ambiguous, and boundaries are decisions the owner makes, not facts an agent
  infers. → [references/write.md](references/write.md)

## Before you start

Both jobs need to know which plugins exist. Load the `extensions` skill and have it
map the estate first — which plugins are registered, where each lives, and their sync
state. Come back with that map, then start the job.

Skipping it doesn't fail loudly. It just means you searched the local half of the estate
and reported it as the whole.

## Where this skill looks

Architecture docs live in four places, and the same system can be documented in more
than one. [references/where-docs-live.md](references/where-docs-live.md) owns them:
what each place is for, how to reach it, what it cannot show you, and the order to read
and write in. Both jobs work from that file rather than assuming a location.

## The taxonomy

Architecture docs work when they follow a small structural spec — systems are
directories (one per thing responders reason about separately, regardless of repo
layout), views are root files answering one cross-system question, estate services
(observability, the data platform, CI) are directories whose README routes across
their tools, the README is the map, and churny values are pointed at rather than
copied. The spec lives in [references/format.md](references/format.md); a corpus may
carry its own FORMAT.md, which takes precedence.
[references/concerns.md](references/concerns.md) catalogs the recurring concerns
(deployment, database, events, …) and the questions each file answers, and
[references/examples/](references/examples/README.md) is a complete worked example
corpus to calibrate depth against.

## What this skill is not for

Diagnosis and fixes (that's the runbook that owns the failure — the `runbooks` skill
routes to it), current runtime state (replica counts, flag values — the docs point at
where those live), and product or code-level documentation (API references, user
guides).
