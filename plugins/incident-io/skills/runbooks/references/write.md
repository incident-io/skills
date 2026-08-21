# Write a runbook

Capture a new runbook, or extend an existing one. The hard part isn't the prose — it's
deciding where the runbook lives and making sure it will be found next time someone hits
the symptom. This reference describes that procedure.

## 1. Find first

Never write before searching. Run [find.md](find.md) on the symptom the runbook would
own. Three outcomes:

- **A runbook already owns the subject** → extend it instead of writing a sibling. One
  subject, one owner: a second document on the same subject splits future readers between
  two half-truths.
- **A runbook owns a neighboring subject** → write the new one, and add a chain between
  them (see [format.md](format.md) for chaining rules).
- **Nothing owns it** → write it.

## 2. Resolve the home

Where the runbook lives, decided in this order:

1. **An existing corpus wins.** If the workspace (or the provider the user works in)
   already has a runbook corpus, new runbooks join it. Match its conventions exactly —
   its directory layout, its index, its FORMAT.md if it carries one. Never start a second
   corpus next to an existing one.
2. **The user names a home** — "put this in Notion", "add it to the platform team's
   space". Use whatever write tools the session has for that provider. If the session has
   no write tools for the named provider, say so and offer the markdown for the user to
   paste — don't silently write it somewhere else. Always confirm before writing into an
   external system: name the target space or page and what you're about to create.
3. **No corpus anywhere** → propose bootstrapping one: a `runbooks/` directory at the
   repo root with a README index and the first runbook. A corpus next to the code it
   describes is the easiest to keep honest — claims can be verified against the code in
   the same checkout, and changes ride the same review flow.

## 3. Draft to the format

Write the runbook per [format.md](format.md) — or the corpus's own FORMAT.md if it has
one, which takes precedence. The rules that matter most for a new runbook:

- The title is the subject, and it's the runbook's identity — searches and chains resolve
  on it.
- The "Use this when" section carries the literal routing strings (error messages, alert
  names) verbatim. These are what [find.md](find.md) greps and searches for — a runbook
  without them is invisible.
- Where a passage explains a skill's subject — a tool's mechanics or result semantics —
  chain to the skill instead of inlining it (see skills as chain targets in
  [format.md](format.md)).
- **Verify every claim before finishing.** Every file path, function name, flag, metric,
  and table the draft names gets checked against the code it describes. A claim that
  doesn't verify is dropped or generalized to its pattern form, never shipped. This is
  the single rule that separates a corpus teams trust from one they ignore.
- No incident IDs, customer names, or anything else that turns a triage guide into a
  record of one event.

Update the corpus index (README routing table — see the README spec in
[format.md](format.md)) in the same change, and add chain lines from any neighboring
runbooks found in step 1.

## 4. Check it will be found

A runbook that can't be discovered might as well not exist. Before finishing, work out
which surfaces will find it (the same surfaces [find.md](find.md) searches):

- **Written into a repo** → agents working in that repo will find it. For incident.io
  investigations and agents on other surfaces to find it too, the repo needs to be
  connected to incident.io — as a plugin (if the corpus lives in one) or through document
  sync.
- **Written into Notion, Confluence, or another provider** → it's findable through
  incident.io once that space is included in the organization's document sync.

Both connections are configured in incident.io settings — see docs.incident.io. If you
can't tell whether a home is connected, `document_search` for the exact title of a
document you know lives there — a hit means it's connected.

If the home is connected, confirm the loop closes: after the next sync, `document_search`
for the runbook's title should return it. If the home is *not* connected, say so plainly
and name the fix — which repo or space to connect — so the user can decide. Don't treat
an unconnected home as an error; local-only corpora are legitimate. The point is that the
user should know what will and won't see their runbook.

## Extending instead of writing

When step 1 found an owner, propose a targeted edit: a new routing string, a new
discriminating step, or a new failure class inside the owned subject. Respect the size
discipline in [format.md](format.md) — if the extension would push the file past its
ceiling or bolt on a second subject, the answer is a new sibling runbook plus a chain,
not a longer file.
