# Find a runbook

You have a symptom in hand and want the runbook that owns it — nothing more. This is a
lookup, not a diagnosis: it ends when you're holding the right entry point. To then work
through the runbook, see [follow.md](follow.md).

## 1. Pin the symptom

Reduce it to the literal, greppable string a runbook routes on: the error message, alert
name, error code, exception class, or log event name. A verbatim string beats a
paraphrase — it's what indexes, greps, and document search all match on. Keep a looser
conceptual phrasing too ("connection pool exhausted under load") for the semantic search
in step 3.

## 2. Search every surface that exists

Check which of these surfaces exist in your session, and search the ones that do. Skip
what's absent without comment — the procedure is the same whether one surface exists or
all of them.

**The current workspace.** Look for a corpus in conventional locations: `runbooks/`,
`docs/runbooks/`, `ops/runbooks/`, or a `runbooks/` directory inside a skill
(`skills/*/runbooks/`). If a corpus has a README index, match its routing table on your
string first — a hit names exactly one entry runbook. Otherwise grep the corpus for the
literal string, then for title keywords.

**Installed plugins.** Plugin content available to this session (for example, plugin
trees mounted read-only for the agent, or plugins installed locally). In Claude Code,
installed plugin trees live on disk under the plugin root (for example
`~/.claude/plugins/`); in other agents, whatever paths the session exposes as plugin or
skill content. Search their trees the same way: README index first if present, then grep.

**Your organization through incident.io.** Call `document_search` on your incident.io MCP
connection, passing both forms of the symptom: the literal string via `keywords`, the
conceptual phrasing via `queries`. This covers documents synced from providers like
Notion, Confluence, and GitHub, plus content from repos and spaces your organization has
connected to incident.io — teams often keep runbooks in places your workspace can't see.
Results carry a source `provider` (github, notion, ...) and generated `tags`:
runbook-shaped documents commonly carry a `runbook` tag, and many teams title their
runbooks with a `Runbook: <subject>` prefix — use both to spot candidates among mixed
matches, without treating their absence as disqualifying. Read promising candidates with
`document_show` before trusting a match; a summary that mentions your string is a lead,
not a confirmation.

**Other providers' search tools.** If the session has search tools for a documentation
provider (a Notion search tool, a wiki search) and the user has pointed you at it, search
there too, the same two ways.

## 3. Pick one owner

- **Rank matches**: an exact or near-exact title match wins; then a match on routing
  criteria (the literal strings in a runbook's "Use this when" section); then a body
  match. A runbook that *names your symptom as its subject* beats one that mentions it in
  passing.
- **Dedupe by title.** The same runbook often exists on two surfaces — in a repo and in
  the synced copy of that repo. Treat documents with the same title as one runbook, and
  prefer the copy that lives next to the code (workspace or plugin) — it's the version
  most likely to be current.
- **Confirm it's an entry point.** Entry runbooks own routing for a symptom family;
  mechanism and technique runbooks are chain targets. If your best match is a mechanism
  runbook, check whether an entry runbook chains to it — starting at the entry gets you
  the discriminating steps you'd otherwise skip. (Tiers and chaining are defined in
  [format.md](format.md); a chain is a link whose text is the target runbook's exact
  title.)

Name exactly one runbook and say in one line why it's the right one. Finding ends here —
to run it, hand to [follow.md](follow.md).

## 4. When no runbook owns it

Say so plainly — that's a real finding, not a dead end. Then:

- Name the nearest neighbors you rejected and why they don't fit, so the reader isn't
  left wondering whether you missed them.
- If the corpus has general techniques (scoping the blast radius, correlating against
  recent deploys), suggest the one that would retire the most hypotheses fastest.
- **Offer to write the missing runbook.** The moment a symptom has no owner is the best
  moment to capture one — the details are fresh and the gap is proven. See
  [write.md](write.md). If now isn't the time, record it as a curation candidate so the
  next `curate` run picks it up.
