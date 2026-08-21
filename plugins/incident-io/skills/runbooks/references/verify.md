# Mode: verify

Check every verifiable claim in the runbooks against the current codebase — symbols,
paths, flags, metrics, log events, SQL tables/columns, CLI commands — plus chain-link
integrity. Findings are the deliverable; **this mode never edits** (auto-fixing risks
cementing the wrong answer — the user decides whether the runbook or the code changes).
The shared contract is in [maintain.md](maintain.md); this file holds the verify-specific workflow.

## Parameters

| Arg | Default | Meaning |
|-----|---------|---------|
| `--only <file>` | all | Verify a single runbook. |
| `--changed` | off | Only runbooks changed since the last verify run record (date from `## Runs` in CURATION_LOG.md). Needs the corpus under version control (`git log --since=<date> --name-only -- <corpus home>`); without that, fall back to verifying all. Use for scheduled runs. |
| `--codebase` | auto | Checkout of the code the runbooks cite. When the corpus lives inside that repo, it's the repo root. When the corpus lives elsewhere, the user must name the checkout — if they haven't, abort naming this flag; never verify against a guess. |

## Preconditions

1. The resolved codebase is plausibly the repo the runbooks cite: spot-check one or two
   frequently-cited paths before fanning out, and abort if they're missing.
2. Chain-link check in the main thread before fanning out: for every chain link, confirm
   the target file exists and the link text equals the target's H1 exactly. Its findings
   go in the report's cross-runbook section — the H1 check matters because agents resolve
   chains by title search.

## What counts as verifiable

Flag and check: file paths and directory paths (including grep scopes inside commands —
a scope that doesn't exist breaks the whole command); function/method/type/constant names
(word-bounded search); CLI subcommands and flags for tools defined in the codebase;
feature-flag names at their definition site; metric names at instrumentation sites; log
event names at emission sites; SQL tables and columns (grep the schema or migrations);
structured IDs (shape only).

Do NOT flag: prose about behavior or mechanism; query-language semantics (the metric and
label names inside DO get checked); syntax of external tools like kubectl; metrics
emitted by third-party exporters or vendor systems; vendor error codes and API strings;
dashboard URLs; paths in repos you don't have; judgment and remediation philosophy.

Verdicts: **VERIFIED** (found as claimed) / **NOT_FOUND** (nowhere in the repo) /
**AMBIGUOUS** (different location or near-miss name — a rename needs human judgment;
never round a fuzzy match up to VERIFIED) / **UNCHECKABLE** (turned out external or
prose — a limit of the check, not a finding; keep it out of the health score).

## Workflow

```
1. Inventory (all, --only, or --changed)
2. Chain-link check in the main thread
3. Fan out sub-agents, 3–4 runbooks each, batches of 8–10
4. Aggregate into one report; health-score per runbook
5. Write the proposal; append the run record; surface
```

Sub-agent prompts are self-contained: the codebase path, the 3–4 runbook paths, the
verifiable/not-verifiable rules above, and the output format. Read-only tools (file
reads, grep, glob, shell for searches) — if a sub-agent proposes a fix, discard it.

Per-runbook sub-agent output:

```
N claims. V verified, M not_found, A ambiguous, U uncheckable.
| Line | Claim | Type | Verdict | Evidence |
```

## Health score

```
health = verified / (verified + not_found + ambiguous) * 100
```

Healthy >85% · Drift >60–85% (mechanical fixes) · Stale >40–60% (needs a review pass) ·
Fiction ≤40% (load-bearing names don't exist — flag for rewrite-from-code or deletion,
top priority).

## Report

`proposals/<YYYY-MM-DD>-verification.md`: summary counts; per-runbook table sorted
health-ascending; Fiction/Stale files with their broken load-bearing references and a
suggested action; Drift files with the mechanical renames; cross-runbook findings (chain
links, same claim answered differently in two files); the uncheckable rate (high means
the extraction rules need tightening); per-runbook detail as an appendix.

Then the run record (see maintain.md) — its date is what `--changed` anchors on next run —
and surface: counts, the worst 3 files with one-line rationale, chain-link findings. Do
not propose edits.

## Anti-patterns

- Editing runbooks from findings (the mode's one absolute).
- Flagging vendor error strings as NOT_FOUND — they're UNCHECKABLE.
- Counting UNCHECKABLE in the health score.
- Rounding a near-miss name (`ErrRequestTimeout` vs `ErrRequestTypeTimeout`) to
  VERIFIED — exact names are load-bearing; near-misses are AMBIGUOUS.
- Extracting pattern-form names ("a `*ForOrg` helper") as claims — only specific names
  are claims.
