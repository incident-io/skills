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

## 2. Search the places in order

[where-docs-live.md](where-docs-live.md) owns the places and the order — read it before
searching, even when you think you know where the docs are.

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

First make sure that is what happened. A place you couldn't reach is not a place with no
docs, and reporting an unreachable corpus as a missing one sends someone to write a
document that already exists. Name what you couldn't search.

Once it's genuinely a gap, say so explicitly. Answer from other evidence if you have it — the workspace's own
config, deploy manifests, service definitions — clearly labeled as "from the code, not
the docs". Never silently substitute general knowledge for a missing doc.

Then note the gap as a curation candidate: a question the docs couldn't answer is a
section waiting to be written. If the user wants it fixed now, that's the Write job —
see [write.md](write.md).

## Rules

- Read-only, always: this job explains; it never mutates, flips flags, or runs commands
  that change state.
