# Mode: split

Audit the corpus for runbooks that have grown past one subject or the size ceiling, and
propose splits. No incident fetch — this mode reads only the runbooks. The shared contract
is in [maintain.md](maintain.md); this file holds the split-specific workflow.

## Parameters

| Arg | Default | Meaning |
|-----|---------|---------|
| `--apply` | off | Write new files, edit parents, update README.md (gated — see maintain.md). |

## Criteria

The corpus rule is **one subject per file** (see [format.md](format.md)): a subject is a
component, a mechanism, or a technique. Splits exist to restore that invariant, not to
shrink files for its own sake.

Split signals:

1. **A second subject in "Use this when".** Routing bullets that never co-occur on one
   incident and lead to different diagnostics are two subjects sharing a file.
2. **Over 200 lines** (the format ceiling). At that size a second subject is almost
   always hiding inside.
3. **A section other runbooks want to chain to.** If two or more files need to link to
   one section of this file, that section is a subject that should own a file.

Keep signals:

4. **Variants of one mechanism sharing one diagnostic entry.** A class catalog inside
   one subject — say eight known failure classes of one mechanism, each 8–15 lines — is
   healthy; a class is a variant, not a subject.
5. **The extracted piece couldn't stand alone.** If a reader landing on the new file
   would have to read the parent first, the split is wrong (the format's chain rule).

Calibration: picture a 400-line runbook that stated the same diagnostic four times — as a
checklist, a walkthrough, a decision tree, and a class table. Rewritten, it was about 130
lines with no split at all: the four statements collapsed to one, generic steps (scoping,
deploy correlation, backlog checks) became chains to shared runbooks, and one workload's
plumbing left the file. Most oversized files shrink the same way — **removing restatements
and delegating chains comes before splitting**. Only what remains oversized after that
pass has a genuine second subject.

## Workflow

```
1. Inventory: line-count every runbook; flag files over 170 lines
2. Review every flagged file plus any file named in the most recent curate
   proposal's split flags, if that proposal is still present (proposals are ephemeral)
3. Per candidate: restatement/delegation pass first, then the second-subject test
4. Classify: KEEP / TIGHTEN (restatements out, no new file) / EXTRACT (one section
   becomes a sibling) / SPLIT (two peer subjects)
5. Draft the proposal; under --apply, execute per proposal
6. Append the run record; surface
```

Sub-agent fan-out (per the shared shape) only pays above ~8 candidates; below that,
classify in the main thread.

## Proposal

Write `proposals/<YYYY-MM-DD>-splits.md`: the inventory table; per candidate a verdict
with the cohesion rationale; for EXTRACT/SPLIT the full drafted body of each new file
(per the format rules, verified claims only), the parent edits (narrowed "Use this when",
a one-line chain to the new sibling), and the README index changes. Review checklist: each
new file stands alone; its routing signatures moved with it; chain links use exact H1
titles; no content is now stated in two files.

## Apply (only under --apply)

Per proposal, in order: write the new file; edit the parent (remove the moved content,
add the chain line); update `README.md`; then run the chain-link check — for every chain
link, confirm the target exists and the link text equals the target's H1 exactly — and
fix anything it reports. Then the run record and the diff stat. Never commit.

## Anti-patterns

- Splitting on line count without the restatement/delegation pass first.
- Splitting a class catalog into per-class files — classes are variants, not subjects.
- An extract whose "Use this when" can't route a reader without the parent.
- Leaving the moved content in the parent too ("temporarily") — single owner per fact.
