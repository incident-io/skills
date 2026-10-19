---
name: architecture
description: >
  Answer questions about how the organisation's own systems are built and run — what a
  system is, who owns it, where it runs, what it depends on and what depends on it, and
  the real names of things (clusters, hostnames, queues, buckets, repos) — from
  architecture docs, the catalog and past incidents. Use whenever a question is about a
  specific system or piece of infrastructure: "what is X", "what breaks if X goes down",
  "where does X run", "do we have docs on X", or grounding a component before debugging
  it.
argument-hint: "<an estate question to answer>"
---

# Architecture

Architecture docs describe what systems *are*: where they run, what they depend on, and
the real names of things. They pair with runbooks — runbooks own *procedures* (how to
diagnose and fix a failure), architecture owns *facts* (what the component is in the
first place). This skill answers estate questions (the estate: everything you run and
where) from those docs and the records beside them, cited — never from general
knowledge. General knowledge is exactly what these docs exist to override: a team's
setup differs from defaults in precisely the ways worth writing down.

## Where you are running

You are a coding agent with incident.io's skills.

- **Before you start:** load the `extensions` skill and have it map the estate — which
  plugins are registered, where each lives, and their sync state. Skipping it doesn't
  fail loudly. It just means you searched the local half of the estate and reported it
  as the whole.
- **Where to search:** the four places in
  [where-docs-live.md](references/where-docs-live.md), in its order. Read it before
  searching, even when you think you know where the docs are.
- **Where live config lives:** the workspace.
- **When the docs have a gap:** if the user wants it filled now, that's the
  `architecture-author` skill.
- **When the question is really "how do I fix this failure":** hand over to the
  `runbooks` skill. Its Find job owns routing a symptom to its runbook.
- **How to reply:** in the voice the `talking-to-the-user` skill sets — lead with the
  answer, be concise, one next step where there is one.

## 1. Pin the subject

Reduce the question to the system or identifier it is about: a service name, a
hostname, a cluster, a bucket, a deployment. Keep both the literal identifier (for
keyword search and grep) and the question phrasing (for semantic search).

## 2. Search

Search the places above, in their order. Start each corpus at its README — a
well-formed corpus has a "Where do I look?" routing table that resolves most questions
in one hop. Do not grep the tree before trying the map; the map exists so one hop finds
the owning file. Grep only when the map misses. The README is a map, not a gate: every
synced file is searchable whether or not the README lists it. Document search results
carry a source provider and generated tags; architecture-shaped documents describe
systems and infrastructure rather than procedures. A result's summary is a pointer, not
the answer: open the owning doc before you state a fact from it.

Docs are not the only record, so check these alongside them:

- **The catalog** holds each system's purpose, owner, aliases and modelled
  dependencies. A system is an entry inside a type, so find it by searching the
  entries of the likely types (`catalog_entry_list` with `search`); listing types by a
  system's name matches type names only, and an empty result there says nothing about
  the system. Take ownership from it, never from a doc's own "Owner" line; when a doc
  and the catalog disagree, give both and say which is newer.
- **The glossary** holds the organisation's nicknames and acronyms. Resolve an
  unfamiliar name there, and through catalog aliases, before searching for it. Code
  paths and resource names resolve through aliases too, and one can fit more than one
  system.
- **Past incidents** are often the only description of a system nobody wrote up.
- **A doc's notes** (`document_show` with `include: notes`) record known
  inaccuracies. Read them whenever a claim's accuracy matters.

Say "nothing describes it" only after all of these came back empty.

**"What depends on X" needs a reverse lookup.** A dependency is recorded on the thing
that depends, so X's own doc or catalog entry lists what X calls, not what calls X. Find
the catalog types with an attribute that points at X's type, and list each with an
`attribute_filters` `one_of` on X. Page to the end, or count, before giving a total;
name the types you checked. For impact, run the same lookup once more on each direct
dependent, and mark what that finds as second-hand impact.

## 3. Answer from the owning doc

- **Quote identifiers verbatim** — project IDs, cluster and pool names, hostnames,
  subscription names. A paraphrased identifier is worse than none.
- **Cite the doc** each fact came from, and the authoritative config repo where the
  doc names one.
- **Respect what the docs deliberately do not hold.** Values that churn — replica
  counts, resource limits, machine types, current flag state — are pointed at, not
  copied. Answer with where the current value lives, not a number the docs never
  promised. If the live config above holds that value, read it and say where it came
  from.
- **Keep it short.** Most questions resolve to a few sentences and one or two doc
  references.

## 4. When the docs do not cover it

First make sure that is what happened. A place you couldn't reach is not a place with no
docs, and reporting an unreachable corpus as a missing one sends someone to write a
document that already exists. Name what you couldn't search.

Once it's genuinely a gap, say so explicitly. Answer from other evidence when you have
it — deploy manifests, service definitions, config, a connected system's own listing —
clearly labelled with where it came from, not the docs. Never silently substitute general
knowledge for a missing doc.

Then note the gap as a curation candidate: a question the docs could not answer is a
section waiting to be written. Handle it as "Where you are running" says.

## Rules

- Read-only, always: this skill explains; it never mutates, flips flags, or runs
  commands that change state.
- Route, don't absorb: if the question is really "how do I fix this failure", ground
  the component here, then hand over as "Where you are running" says.

## What this skill is not for

Writing or maintaining architecture docs, diagnosis and fixes (the runbook that owns the
failure), current runtime state (replica counts, flag values — the docs point at where
those live), and product or code-level documentation (API references, user guides).
