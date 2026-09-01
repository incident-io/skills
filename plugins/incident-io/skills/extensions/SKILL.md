---
name: extensions
description: >
  Understand the extensions so that you can help a user configure and manage
  their incident.io agent estate. Use this when you're asked a question about incident.io 
  plugins, skills, connectors or MCPs ("I want to setup an incident plugin", "How do I 
  add a triage skill?"), or when you need to understand the user's existing configuration
  before editing a plugin or skill.
---

# Extensions

Before anything else, check the model this session runs on. These workflows need
Opus/Sol level or higher; smaller models follow them unreliably. If this session is
below that level, tell the user and recommend switching model before continuing.

Extensions are how an organization gives incident.io's agents its own tools and
instructions. There are two kinds: **plugins** — directories of skills synced from the
organization's repositories, which agents load and follow — and **connectors** — MCP
servers whose tools agents can call.
[references/extensions-product.md](references/extensions-product.md) explains how the
system works; read it before answering questions about it or changing anything.

This skill is the entrypoint. It teaches the system, reads the current state of an
estate, and picks the right mechanism for a problem — and it routes every specialised
job to the skill that owns it rather than doing it here.

Whatever the task, the first two moves are the same: read the estate, and hear what
the user needs. Nothing else — no drafting, no probing of any connected system —
starts before both.

## Route by the task

- **Understand the system** — what plugins, skills, and connectors are, how agents use
  them, what's possible →
  [references/extensions-product.md](references/extensions-product.md)
- **Read the estate, or set it up** — what exists today (plugins and their sync state,
  connections and their health, content), measured against what a ready estate has.
  One walk serves every starting point, from scratch to a readiness pre-check.
  → [references/estate.md](references/estate.md)
- **Choose the right mechanism** — the user describes a problem ("I want these steps
  run at the start of an investigation", "I want something that diagnoses this error
  code") and it needs mapping to the feature that solves it: a skill, a runbook, an
  architecture doc, a connector, or a combination. This picks the mechanism, not a
  detailed plan of what to build — drafting the content is the owning skill's job.
  → [references/choosing-a-mechanism.md](references/choosing-a-mechanism.md)
- **Scaffold and register a plugin** — create the tree in the team's repository,
  register it, and verify the first sync.
  → [references/scaffold.md](references/scaffold.md)
- **Write or improve a skill** → load the `skill-authoring` skill *now*, before
  touching any target system — its create job owns the order of work (the user's
  context first, exploration after), and starting the exploration here skips the
  gates that make the skill worth writing.
- **Write or answer from architecture docs** → the `architecture` skill
- **Review the estate's health** ("is our setup healthy? what's degraded?") → the
  `doctor` skill

## Ground rules

- **Ground before proposing.** Grounding means two things, and target-system
  exploration is neither: the incident.io estate
  ([references/estate.md](references/estate.md) — what's registered, connected, and
  already written; `extension_plugin_list` is the first call), and the user's intent —
  what they actually need, in their words. Probing the system a skill will cover is
  part of *authoring*, owned by `skill-authoring`, and comes after the user has
  confirmed what the skill is for. However inviting a connected tool surface is,
  exploring it before that conversation is guessing with tools.
- **Confirm before creating.** Every artefact — a directory, a registration, a doc —
  is proposed with what it will contain, and created only on a yes.
- **Requirements are few; the rest is guidance.** The hard requirements are what the
  platform needs to function:
  - a repository the connected source-control integration can read
  - a registered plugin

  Everything else (architecture docs, runbooks, more skills) is a recommendation:
  explain why it produces better results, then respect the user's choice. A narrow
  use case gets a narrow setup, not the full walk's ambitions.
- **Speak the user's language, not this skill's.** The user hasn't read this file —
  never cite "the ground rules", a reference filename, or "the estate walk" at them.
  Say what you're doing plainly ("I'm checking your configuration before we get
  started") and end a read-only pass with an offer of what you can help with next.
- **Connections are created in the dashboard, never here.** Connecting a tool to
  incident.io is an authentication flow. Where a gap is found, link the user to the
  dashboard's Extensions page and continue with what exists.
- **Specialised work goes to the skill that owns it.** This skill owns the
  estate-level picture and the routing; the routes above name the owners.

## What this skill is not for

Incident response — this skill configures the machinery agents use, it doesn't
investigate incidents.
