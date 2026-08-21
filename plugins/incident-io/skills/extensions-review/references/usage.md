# The usage leg

Pull the window's assessed loads, shortlist the few worth telling, verify each
against its run, and write the items. The output shape is
[report.md](report.md)'s; this file owns how the items are chosen and proven.

## 1. Pull the corpus

First, check the surfaces exist. The census comes from the incident.io connection's
`extension_plugin_list` and `extension_skill_usage_list`, with
`extension_skill_feedback_list` as the last fallback. When the session has none of
the three, stop: deliver a coverage-only report and say the review could not run.
That report names all three census capabilities individually — including the
fallback, even when the primary tools are already known absent — so the reader sees
the full list of what connecting would take. Never substitute a warehouse table or a telemetry
query for the assessed-load record, and never assume counts — an improvised census
reads like the real one and is fiction.

Pull per plugin, not from the global stream. The unfiltered stream interleaves every
plugin's loads with the platform's own machinery, so on a busy day most of what you
page through is rows you must discard. A `plugin` filter skips them at the source.

First list the plugins with the incident.io connection's `extension_plugin_list`,
then one call per enabled plugin to `extension_skill_usage_list`, windowed on
assessment (the default), with the window's dates computed from the conversation's
current date:

```
extension_skill_usage_list(plugin: <name>, since: <start>, until: <end>, page_size: 50)
```

Dates: a request for "yesterday" or a named day uses bare dates — a bare date as
`until` covers the whole of that day. A request for "the last 24 hours" uses RFC 3339
timestamps, or the window silently widens to whole days.

Page with `after: <next_cursor>` until `has_more` is false, under a budget: a busy
plugin — the managed incident.io plugin above all — can produce hundreds of loads in
one day, so cap any one plugin at a few pages rather than paging to exhaustion. A
capped pull is declared, never hidden: its count reports as "N+ (capped)" in the
coverage section. The cap costs little — the shortlist reads newest-first, and the
gaps leg settles every candidate with `incident_show` rather than trusting the map —
but an undeclared cap turns the counts into fiction.

Reading the rows:

- **Do not filter on verdicts in the call.** One unfiltered pull per plugin serves
  everything downstream: partition by `contribution` yourself for the highlights
  (helped) and the miss (hurt), and keep every row — whatever its verdict — for the
  gaps leg's coverage map.
- **A `partial` load that still helped** is often the best item in the window: the
  agent followed half the skill, and that half carried the answer.
- **A row with no `url`** is a load whose run cannot be linked — a private incident,
  or a conversation outside a public channel. The redaction is deliberate: the row
  counts in the totals, but it cannot become an item, because an item needs a source
  to verify against and a link for the reader.

Two fallbacks, in order. Where the plugin list is unreadable, pull the global stream
with the same window and both verdict filters, and **drop rows with no `plugin_id`**
— those are the platform's own machinery (the rule in SKILL.md). Where the session
lacks `extension_skill_usage_list` entirely, fall back to
`extension_skill_feedback_list(plugin: …, include: ["examples"])` per plugin — and
say in the report that its examples are capped per skill, so busy skills are
under-sampled and the counts are not a census.

## 2. Shortlist

Cut to at most five highlights, plus the strongest miss. A load earns a place only if
you can complete this sentence with something specific:

> Without the `<skill>` skill, the agent would have `<concretely worse thing>`.

"Answered less well" does not qualify. If the skill only supplied structure, framing,
or tone, the agent had that anyway — drop it. The shapes that do qualify (the
specifics below are illustrative, a different system every time):

- **Reach** — the skill drove a tool into a system nothing else in the session
  reads: the raw response an integration recorded, a build system's job logs.
- **The organisation's vocabulary** — the skill knew the team's names for their own
  data, so a question became a precise lookup instead of a guess.
- **The organisation's topology** — the skill knew the system's shape: that messages
  cross two brokers, so checking one is never the whole picture.
- **Operational muscle memory** — the skill produced a real command with its exact
  flag semantics, its undo, and its footguns — details no model infers.
- **The owning procedure** — the skill routed a symptom to the runbook that owns it
  instead of reasoning from scratch.
- **Restraint** — the skill carried a caution that stopped a destructive or
  premature action. Watch for this class: an agent declining to purge, gate, or
  conclude — and saying why — is often the window's best story, and the one a reader
  trusts most.

Among qualifying loads, prefer: conversation loads over investigation loads (a
person reacted, and the reaction is most of the story); accounts that name a
decision ("recommended against the purge") over accounts that name a contribution
("supplied context"); one item per skill and at most two per plugin; variety of
shape over the five strongest examples of one shape.

For the miss, prefer the one that names a line of content to change. The strongest
shape is an instruction that has outlived the world it was written for — a skill
that says a tool does not exist after the tool was connected, so the agent refuses
something it could do. That miss converts directly into a fix.

## 3. Verify each shortlisted load

Read the source before writing the item — this is the claim-versus-evidence rule
from SKILL.md, applied per item:

- **Investigation loads**: `incident_show(id: <reference>, include:
  ["investigation"])` on the incident.io connection. Check the finding the
  assessment credits appears, and read what the person did with it.
- **Conversation loads**: the row's `url` links the thread. Where the session has a
  tool that reads the chat platform's messages, open the thread and read the
  exchange — the person's own words are usually the item's best material. (A Slack
  permalink ends in the message timestamp: `p1787239959545589` is ts
  `1787239959.545589`.)
- **Where the thread is unreadable from this session**, prefer investigation-backed
  items. A conversation item may still run, but every claim in it must be written as
  the assessment's ("the assessment records that…"), and the report's coverage
  section says the thread went unread.

Then judge: does the source support the assessment's account? Expect it not to,
regularly — accounts understate ("produced the command" for a run that also withdrew
its own earlier suggestion) and overstate (credit for a finding the run reached
another way). Re-frame the item from what the source shows, or drop it. Budget the
reading: verify the shortlist, not the corpus — around eight reads is the ceiling,
and five well-read items beat twelve skimmed ones.

## 4. Write the items

To [report.md](report.md)'s item contract. The rules that matter while writing:

- Write the way you would tell a colleague what happened. Plain words, no idioms,
  no personification ("the skill earned its keep"), no verdict adjectives. The
  story says where it went well; the reader judges how well.
- Translate the assessment's vocabulary into plain words. "Transient", "ground
  truth", "blast radius" belong to the grader; the reader gets "temporary", "what
  actually happened", "how far it spread".
- Quote people verbatim and attribute by name — their words carry the moment better
  than a summary of it. Never invent or tidy a quote.
- Name runbooks and documents by their titles, as the run named them ("Build
  pipeline failures", `pubsub-backlog.md`) — never "a runbook".
- Leave the skill's internals out. Which reference file routed a query is
  machinery; the reader wants what was asked, what came back, and what it changed.
- End each item with one plain sentence on what the plugin supplied that the agent
  lacked without it — the bar sentence from step 2, as prose, never a labelled
  field.
- Say what the agent declined to do when that is the point — restraint items lead
  with the refusal, not the diagnosis.
