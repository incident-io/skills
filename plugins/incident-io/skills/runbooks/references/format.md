# Runbook format

The structural rules that make a runbook easy to find, safe to follow, and cheap to
maintain. They're guidance, not a schema: a corpus may carry its own FORMAT.md at its
root, and when it does, the corpus's rules win — as a delta on this format (its own
tables, conventions, thresholds), not a fork: where the local file is silent, this
format holds. Use this as the default for new corpora and as the base others extend.

Runbooks have two consumers, and every rule here serves one or both:

- **A responder**, often tired, who needs to route to the right document fast and follow
  one clear path.
- **An agent**, which finds runbooks by searching titles and symptom strings, walks their
  steps with read-only tools, and follows references to other runbooks by title.

## Tiers

Each runbook has one of three roles:

- **Entry** — a symptom lands here directly (an alert, an error string, an exception
  class). Owns the routing for its symptom family and either resolves it or chains out.
- **Mechanism** — explains one failure mechanism in depth. Reached by a chain from an
  entry runbook, but must still stand alone: a reader arriving directly gets everything
  they need.
- **Technique** — a cross-cutting move (scoping the blast radius, correlating a change
  window, profiling). Chain leaves: linked from everywhere, inlined nowhere.

## Title and name

- The title is the subject the runbook owns — a component, a mechanism, or a technique —
  in sentence case. Not a symptom sentence, and never an incident. The title is the
  runbook's identity: searches resolve on it and chain links use it verbatim, so keep it
  stable.
- In a file-based corpus, the filename is the subject in lowercase kebab-case
  (`redis-connection-exhaustion.md`). In a provider like Notion, the page title carries
  the identity and there is no filename — the title rules above are what matter.

## Shape

```markdown
# Sentence-case title

Two or three sentences: what this subject is, what failure family it covers, and what
the runbook will help you do. Plain language.

## Use this when

- Bulleted routing criteria with literal strings: error messages, alert names, error
  codes, log event names. These strings are how both consumers find the document —
  include them verbatim.

Go elsewhere when:   ← entry runbooks only, where routing confusion is real

- The look-alike symptom that belongs to a sibling — with a link.

## <The body>

One flow, in the order you'd actually work: orient → classify → discriminate → fix.

## Chains

Generic next moves this runbook deliberately does not inline — one line each, linked
by the target's exact title.
```

Body section names are free (pick what fits the subject); the rules are not:

- Each fact appears exactly once. No summary checklist, decision tree, or class catalog
  restating what the body already says.
- Every query is copy-paste runnable and names its datasource (see below).
- Diagnostic steps (queries, greps, SQL) are things the reader or an agent executes.
  Responder-only actions (flag flips, console clicks, vendor escalation) are
  recommendations — write them as "the lever is X", not as a step an agent can run.

## Chaining rules

- Link text is the target runbook's title, exactly. Agents resolve chains by searching
  for that title, so a paraphrased link is a broken link.
- Never inline another runbook's subject. If you're explaining change-window correlation
  inside a database runbook, stop and link instead.
- Chains form a DAG. Any diagnostic path completes within two hops of its entry runbook.
- A chain target must stand alone. If the reader would need to come back to understand
  it, the split is wrong — fix that in review rather than shipping it.

## Skills as chain targets

A skill owns one system's tools and their result semantics: how to call them, what null
vs zero means, the generic flows. A runbook never restates a skill's subject — it owns
the symptom, the thresholds, and the decision. Where the runbook would explain tool
mechanics, chain to the skill instead.

A skill chain names the skill in bold, with no path and no invocation syntax — skills
resolve differently per environment, so the name is the whole reference:

```
- Reading results and node selection → the **postgres** skill
```

When a runbook cannot be followed at all without a skill, add one standard sentence
after the intro, before "Use this when": "If you need to follow or execute this
runbook, first load the **<name>** skill."

## Size

Target 60–150 lines. 200 is the ceiling; a document pushing past it almost certainly owns
two subjects and should be split (see [maintain.md](maintain.md)). Under ~40 lines, the
subject probably belongs as a section of its parent.

## The corpus README

The `README.md` at the corpus root is the index. It carries two short tables:

- **Routing table** — one row per entry runbook: the symptoms it owns (its strongest
  literal routing strings, abbreviated) and a link whose text is the runbook's exact
  title. This is the first thing a search checks, so every new or split runbook updates
  it in the same change.
- **Datasource vocabulary** — see the next section.

## Datasource conventions

Every query names its datasource inline, so a reader or agent knows where to run it:

```
# Datasource: logs
{service="payments"} | json | event="checkout_failed"
```

The datasource vocabulary is corpus-specific: which names exist, what each is for, and
any sharp edges (fields that aren't labels, tables that need a tenant filter). Define it
once in the corpus README as a short table, and have every runbook use those names. Don't
restate the vocabulary inside runbooks.

## Writing rules

Hard rules — a change that breaks one goes back.

**Plain language.** Short sentences. Direct statements. No color ("smoking gun",
"storm"), no drama, no filler. Technical terms only when they are the real names of
things. If a sentence works without a word, cut the word.

**Don't:**

- Reference incident IDs, customer or organization names, ticket numbers, trace IDs, or
  PR numbers.
- Pin version numbers or current configuration state where these churn — write "check
  the flag / the registry" and say where.
- State the same fact twice in different forms.
- Include example-incident tables or any framing tied to one past event.
- Use emoji.

**Do:**

- Name real file paths, functions, flags, metrics, and tables — and verify each one
  exists in the code before shipping. A claim that doesn't verify gets dropped or
  generalized to its pattern form, never shipped.
- Use sentence case for headings.
- Show wrong-vs-right snippets only where a consistent anti-pattern exists, and keep them
  short.

## What doesn't belong

Retrospectives and post-mortems (records, not triage guides), architecture explanations
(facts about how systems are built belong in architecture docs — the `architecture`
skill in this plugin owns them), tool walkthroughs (next to the tool), one-off customer
workarounds (the customer's ticket). If it would be stale in
three months, it doesn't belong in a runbook.
