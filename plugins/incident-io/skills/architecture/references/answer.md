# Answer an estate question

You have a question about how something is built, deployed, or run — "how does X run",
"what is Y", "where does Z live", "what talks to W" — and want the answer from the
architecture docs, cited, not from general knowledge. General knowledge is exactly what
these docs exist to override: a team's setup differs from defaults in precisely the ways
worth writing down.

## 1. Pin the subject

Reduce the question to the system or identifier it's about: a service name, a hostname,
a cluster, a bucket, a deployment. Keep both the literal identifier (for keyword search
and grep) and the question phrasing (for semantic search).

## 2. Search every surface that exists

Check which surfaces exist in your session and search the ones that do, skipping absent
ones without comment.

**The current workspace.** Look for an architecture corpus in conventional locations:
`architecture/`, `docs/architecture/`, or an architecture directory inside a skill
(`skills/*/architecture/`). Start at
its README — a well-formed corpus has a "Where do I look?" routing table that resolves
most questions in one hop. Don't grep the tree before trying the map; the map exists so
one hop finds the owning file. Grep only when the map misses.

**Installed plugins.** Plugin content available to this session (in Claude Code, plugin
trees live under the plugin root, for example `~/.claude/plugins/`). Look for
architecture directories and their README maps the same way.

**Your organization through incident.io.** Call `document_search` on your incident.io
MCP connection — the identifier via `keywords`, the question via `queries`. Results
carry a source `provider` and generated `tags`; architecture-shaped documents describe
systems and infrastructure rather than procedures. Read candidates with `document_show`
before trusting them.

**Other providers' search tools**, when the session has them and the user has pointed
you at them.

## 3. Answer from the owning doc

- **Quote identifiers verbatim** — project IDs, cluster and pool names, hostnames,
  subscription names. A paraphrased identifier is worse than none.
- **Cite the doc** each fact came from, and the authoritative config repo where the doc
  names one.
- **Respect what the docs deliberately don't hold.** Values that churn — replica counts,
  resource limits, machine types, current flag state — are pointed at, not copied
  (that's the format's provenance rule). Answer with where the current value lives, not
  a number the docs never promised. If the workspace holds that config, read the live
  value and say where it came from.
- **Keep it short.** Most questions resolve to a few sentences and one or two doc
  references.

## 4. When the docs don't cover it

Say so explicitly. Answer from other evidence if you have it — the workspace's own
config, deploy manifests, service definitions — clearly labeled as "from the code, not
the docs". Never silently substitute general knowledge for a missing doc.

Then note the gap as a curation candidate: a question the docs couldn't answer is a
section waiting to be written. If the user wants it fixed now, that's the Write job —
see [write.md](write.md).

## Rules

- Read-only, always: this job explains; it never mutates, flips flags, or runs commands
  that change state.
- Route, don't absorb: if the question is really "how do I fix this failure", ground the
  component here, then hand over to the runbook that owns the failure (the `runbooks`
  skill's Find job).
