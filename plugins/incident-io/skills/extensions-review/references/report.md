# The report

Every review ends in this shape, whichever legs ran and wherever it is delivered.
The parts are standalone by design: nothing in one item may depend on having read
another, which is what lets the same report render as a chat thread, a document, or
plain text without rewriting.

## The parts

**Lead** — the window in a glance. Answers: was anything good, and which item should
I open?

```
**Extensions review – <weekday> <ordinal day> <month>**

<The best story, told directly in one or two sentences. Open with the story
itself — never a label like "Best of the window:" and never a verdict adjective.
A short verbatim reaction can sit here when it is the story's payoff.>

<The rest of the window: one concrete sentence per remaining highlight — each
naming its skill, enough that a reader knows which thread reply it is — then the
miss, runbooks named by their titles. Tour every item; never let the lead fixate
on one story.>

✨ <N> highlights · ⚠️ <N> misses · 🧩 <N> gaps · <N> loads across <N> skills
```

When nothing cleared the bar, the lead collapses to one line saying so, with the
counts — and the report is just the lead and the coverage part.

**Highlight items** — one block each, at most five:

```
✨ **<what happened, in plain words>**

<The setup and what the skill did, in paragraphs of at most two sentences,
naming the skill within the first two sentences. Two or more figures become
bullets, with one bold value. What it declined to do, when that is the point.>

> <the payoff line, verbatim — usually the person's reaction, sometimes the
> agent's refusal. One blockquote per item, and only for this.>

<One plain sentence on what the plugin supplied that the agent lacked without it —
prose, never a labelled field.>

<skill dir, linked to its dashboard page> · <incident reference, when there is
one> · <link to the run>
```

The footer's skill link is built from the row's own fields:
`https://app.incident.io/~/nexus/extensions/<plugin_id>/skills/<skill_dir>` — the
`~` resolves to the viewer's organisation. Skill names are code-formatted
(`queue`) everywhere they appear — the lead's tour, item bodies, coverage — one
consistent mark, so the reader always knows which skill a message is about.
Headlines stay plain-words stories: no skill names, no numbering, no code
formatting there; backticks are for identifiers in the body.

**Miss item** — same shape, at most one, anchored ⚠️ instead of ✨. Its headline
may name the skill, code-formatted — in a miss the skill is the story's subject. Its "line to change"
replaces the bar sentence: the file and instruction that caused it when the source
shows one, or one line saying the cause sits outside the content.

**Gap briefs** — one block each, when the gaps leg ran:

```
🧩 **Gap: <the symptom or system, in the words the window used>**

<The evidence: which incidents, what the investigation lacked, whether the shape
recurred.>

Route: <skill-authoring's create job | the runbooks skill's write job | a connection,
decided in the dashboard> — <what the receiving job needs to start>
```

**Coverage** — always last, always present. The reader must be able to tell what
"nothing from X" means:

```
ℹ️ **Coverage**

- **Scanned** — <N> loads · <N> skills · <N> plugins · <N> incidents
- **By plugin** — <name N · name N …, "N+ (capped)" where paging stopped early>
- **Read in full** — <N> investigations · <N> conversations
- **Left out** — <each exclusion in a phrase: platform-internal loads, loads with
  no public link, incidents nothing written could have helped>
- **Looked uncovered, wasn't** — <incidents the map missed, each with the runbook
  title its investigation used, and duplicates with their primary>
- **Too recent to judge** — <incidents, or "none">
- **Couldn't read** — <each unreachable surface and what that cost, or "nothing">
```

Every coverage field survives abstention: a field the review checked and found
empty reads "none", never silence. Fields the review could not check are stricter:
after a failed preflight, every count-bearing field — loads scanned, sources read,
exclusions, gaps — reads "not scanned", never 0, "none", or "no …". Zero-shaped
words are reserved for a completed scan that returned no records; a zero that means
"couldn't look" is the worst lie a coverage section can tell.

## Delivery

The request usually names a destination ("post to our extensions channel"). Match
the report to what the session can do, and say which shape was used:

- **Threaded** — the session has a tool that posts chat messages and threads
  replies. The lead is the parent; each item, each brief, and coverage are replies
  in order. Do not broadcast replies to the channel.
- **Sectioned** — the destination is a document (a page, a file the team reads). One
  document, the parts as headings, same order.
- **Sequential** — no destination, or no posting tool. The report is the reply
  itself, parts separated by rules. Never deliver by writing a file and pointing at
  it: whoever asked is reading here.

Where the named destination is unreachable — no posting tool, or the tool lacks the
channel — deliver sequentially in the reply and say what was missing. Never treat a
delivery request as blocked work: the report exists either way.

Two rules that exist because chat posting is one-way:

- **Nothing posts until the whole report is written.** A thread's parent goes out
  first but depends on everything after it, and most platforms cannot edit a posted
  message from a tool. Finish every item, then post in order.
- **A published mistake is corrected in a follow-up reply** that says plainly what
  was wrong — never by quiet re-posting.

Write links and emphasis in the destination's own syntax, and check which one that
is before posting: chat platforms and documents disagree, and a wrong guess renders
raw markup — or whispers where the report meant to be bold. The common trap: a tool
that takes GitHub-flavoured markdown renders single asterisks as italic, so the
headlines that anchor each part need double asterisks there.

## Length

The lead under about 1,200 characters; each item under about 900. These are targets
that keep a thread scannable, not limits to pad toward. Cut the item, not the quote.
