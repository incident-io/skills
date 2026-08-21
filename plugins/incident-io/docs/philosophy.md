# How these skills are designed

The skills in this plugin follow one pattern. This document describes that pattern, so
new skills join it deliberately and existing ones can be judged against it. The
`runbooks` and `architecture` skills are the reference implementations: when a rule here
feels abstract, read how they apply it.

## Skills carry judgment; your content stays yours

Every skill here separates machinery from content. The skill owns the *how* — how to
find the runbook that owns a symptom, how to interview someone before writing
architecture docs, how to curate a corpus from closed incidents. Your team owns the
*what*: the runbooks, the architecture docs, the operational knowledge. That content
never lives in this plugin. It lives wherever you want it — a directory in your repo, a
plugin of your own, a Notion or Confluence space — and the skills find it there.

This is why the skills are genuinely reusable: nothing in them is about us, or about any
one team. And it's why installing the plugin is useful on day one — the machinery works
on whatever you already have.

## One skill, every environment

A skill runs in more than one place: a coding agent in your repo, other agents your team
operates, and inside incident.io — whose agents provide the same capabilities natively
during investigations and chat. What holds this together is an interface, not shared
code: what you can ask of a skill, and where it looks, is the same everywhere.

To keep that true, skills never assume a runtime
([agent-environments.md](agent-environments.md) maps what each environment actually
provides). They:

- **Feature-test their surfaces.** Search jobs check what exists in the session — the
  current workspace, installed plugins, the organization's documents through the
  incident.io MCP, any provider tool the user points at — and search what's there,
  skipping what's absent without comment.
- **Name needs, not plumbing.** "Search your organization's documents" rather than a
  client-specific tool string. Where a concrete tool is named (`document_search`), it's
  by its portable name, with a fallback stated for sessions that lack it.
- **Degrade to match the cost of being wrong.** The asymmetry is deliberate: a search
  job silently skips an absent surface (missing one surface is cheap); a curation job
  hard-stops if it can't list incidents (fabricating an incident list is catastrophic);
  an execution job records `unknown — tried <what>` rather than improvising. Don't
  flatten these into one rule.

## Discovery makes location a preference

Because search is federated across every place content can live, *where* your team keeps
its content is a preference, not a commitment. Runbooks in the repo get PR review and
verification against the code in the same checkout; runbooks in Notion suit teams who
don't live in git; either way, every surface finds them. The skills reinforce this from
the writing side: every authoring job ends by checking the new content will actually be
found. When it won't be, the job says plainly what would connect it, as a test you can
run ("after the next sync, searching for this title should return it") rather than
product knowledge you need. Local-only content is legitimate; the point is you should
know what will and won't see it.

## Conventions are the contract

A generic skill can only navigate content it has never seen if the content follows
predictable structure. So each content-producing skill ships a format: title as
identity, chains that link by exact title, literal routing strings a search can match,
one subject per document. Three rules about these formats:

- **They're guidance, not schema.** Nothing validates them; content that ignores them
  still gets found, just less well.
- **Local formats win.** A corpus may carry its own FORMAT.md, and when it does, the
  corpus's rules take precedence over the skill's defaults. The skill's format is for
  new corpora and for corpora that haven't made their own choices.
- **They're taught by worked example, not just rules.** Each format ships a concern
  catalog (a menu of what files of each kind are for — never a checklist) and a complete
  worked example for an invented company, calibrated to the intended depth. Authors
  match the nearest example rather than inventing a shape.

## Setting up structure is a first-class job

The skills don't just consume well-structured content — they help create it. Every
writing job resolves *where* content should live through the same ladder: an existing
corpus wins (match its conventions exactly; never start a second corpus beside one), a
home the user names comes next (confirming before writing into an external system), and
only then does the skill propose bootstrapping a structure from scratch.

And where the content encodes decisions rather than observable facts, authoring is
interview-first. System boundaries are the canonical case: the names people use are
ambiguous, and where one system ends is a decision the team makes, not a fact an agent
infers. The skill enumerates the candidates it can actually see, asks one concrete
question at a time, and captures the resolution in the doc itself — so the next reader
gets the decision, not the ambiguity.

## Say true things, and make truth checkable

The epistemics are the part most worth copying:

- **Verify every claim.** Every file path, function, flag, metric, and identifier named
  in produced content gets checked against the code or config in reach. A claim that
  doesn't verify is dropped or generalized to its pattern form — never shipped.
- **Provenance over precision.** Values that churn — counts, sizes, timings, defaults —
  are never pinned. Name the file or repo that owns the current value, so a stale doc
  degrades into a correct lookup instead of a wrong answer. When a number is worth
  quoting, its owner is named in the same sentence.
- **Enumerate completely; never claim closure.** Small stable inventories
  (environments, queues, hostnames, roles) are listed in full with compact identifiers —
  a complete list is what lets a reader notice the unexpected. But never write "only
  these exist": absolute negatives go stale silently and then mislead. A member that
  exists without being listed is a *finding* — the doc drifted, or something genuinely
  unexpected is happening, and either is worth flagging.
- **Name the code owner.** Where infrastructure has a canonical governing module — the
  cache wrapper, the task registry, the database router — state the coupling and what it
  enforces. That link turns an infrastructure symptom into a code search, and makes
  "something is bypassing the wrapper" a checkable claim.
- **An honest unknown is a valid answer.** "No runbook owns this" is a finding, not a
  failure — and it's the moment to offer to write the missing one. A stalled execution
  pretending to progress is the failure.

## Skills route to each other; they don't absorb

Skills pair along clean contracts — runbooks own procedures, architecture owns facts —
and each side chains to the other rather than inlining it. The same applies inside a
skill: reading jobs are strictly read-only (fixes are recommendations for a human — "the
lever is X" — never steps to run), maintenance jobs are propose-only by default with an
explicit apply gate, and shared mechanisms live in one place and are referenced ("same
ladder as the runbooks skill's Write job") rather than restated.

## Maintenance is part of the skill

Content that can't be kept honest mechanically will rot, so every format is designed for
mechanical verification — identifiers greppable by design, chains checkable by exact
title — and the skills carry the maintenance jobs (curate from what actually happened,
split what has grown past one subject, verify claims against the code). The companion
rule for content that lives with code: change the doc in the change that changes the
fact.

## The voice

Everything — skill prose and produced content alike — is written for two readers at
once: a responder, often tired, who needs to route fast and follow one clear path; and
an agent, which needs literal strings to match and unambiguous steps to follow. That
means plain language, short sentences, no color and no drama, sentence-case headings,
facts stated once, and nothing that would be stale in three months.
