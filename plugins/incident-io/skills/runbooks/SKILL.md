---
name: runbooks
description: >
  Find, follow, write, and maintain runbooks — wherever they live. Four jobs: find the
  runbook that owns a symptom (searching your workspace, your installed plugins, and your
  organization's documents through incident.io), follow a runbook's read-only diagnostic
  flow to a likely cause, write new runbooks into your repo or a connected provider like
  Notion or Confluence, and maintain a corpus (curate from closed incidents / split /
  verify against the code). Use when anyone mentions runbooks: "which runbook covers
  <error>", "run the runbook for this alert", "write a runbook for this", or when
  refreshing, auditing, or verifying runbooks.
argument-hint: "<a symptom to find/follow — or write|curate|split|verify to work on the corpus>"
---

# Runbooks

A runbook is a triage guide: one subject per document — a component, a failure mechanism,
or a technique — routing from a symptom to a likely cause and a recommended fix. Teams
keep them in different places: a directory in a repo, a plugin, a Notion or Confluence
space synced into incident.io. This skill works with all of them: one way to find the
runbook that owns a symptom, one discipline for following it, and one set of practices
for writing and maintaining them.

## The four jobs

- **Find** — you have a symptom and want the runbook that owns it. A lookup across every
  place runbooks can live, not a diagnosis: it ends when you're holding the right entry
  point. → [references/find.md](references/find.md)
- **Follow** — you have a runbook (found from a symptom, or already named) and want to
  work through it: run its read-only diagnostic steps, follow its chains, and reach a
  likely cause and a recommended fix. → [references/follow.md](references/follow.md)
- **Write** — capture a new runbook, or extend an existing one: resolve where it should
  live, draft it to the format, and make sure it will be found next time.
  → [references/write.md](references/write.md)
- **Maintain** — keep a corpus accurate, single-subject, and current: `curate` (mine
  recent closed incidents for new material), `split` (cohesion sweep for bloated files),
  `verify` (check claims against the code).
  → [references/maintain.md](references/maintain.md)

To work a runbook end to end from a symptom — the common case during an incident — do
**Find then Follow**. Find alone is the quick "which runbook is this?" lookup; Follow
alone is when the runbook is already in hand. When Find comes up empty, that's a real
finding — offer to Write the missing runbook while the details are fresh.

## Where this skill looks

Runbooks are discovered, never assumed to be in one place. Find searches every surface
that exists in the session:

1. **The current workspace** — conventional locations in the repo you're working in.
2. **Installed plugins** — plugin content available to this agent session.
3. **Your organization through incident.io** — the `document_search` / `document_show`
   tools on your incident.io MCP connection, which cover documents synced from providers
   like Notion, Confluence, and GitHub, plus content from repos and spaces your
   organization has connected to incident.io.
4. **Any provider search tool the user points you at** — a Notion search, a wiki search.

The same surfaces answer "will this runbook be found?" when writing one — Write ends by
checking the new runbook is discoverable, and says what to connect if it isn't.

## Format

Runbooks search well and execute well when they follow a few structural rules — title as
identity, one subject per document, literal routing strings, chains by exact title. The
rules live in [references/format.md](references/format.md). A corpus may carry its own
FORMAT.md at its root; when it does, the corpus's own rules win.

## What this skill is not for

Post-mortems and retrospectives (those are records, not triage guides), architecture
explanations (facts about how systems are built belong in architecture docs — the
`architecture` skill in this plugin owns them), and one-off customer workarounds. If
content would be stale in three months, it doesn't belong in a runbook.
