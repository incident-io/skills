# Maintaining the runbooks

The shared contract for the three maintenance modes — `curate`, `split`, and `verify`.
Read this first when the request is to refresh, audit, or verify the runbooks, then read
the matching per-mode reference and follow its workflow. This file holds only what every
mode shares.

## Mode dispatch

| Mode | What it does | `--apply`? | Reference |
|------|--------------|-----------|-----------|
| `curate` | Mine recent closed incidents; propose new/extended runbooks | yes (gated) | [curate.md](curate.md) |
| `split` | Audit for files past one subject or the size ceiling; propose splits | yes (gated) | [split.md](split.md) |
| `verify` | Check code references and chain links against the codebase | no (never edits) | [verify.md](verify.md) |

The first positional argument selects the mode. If it's `maintain` or missing, infer the
mode from the request; if still ambiguous, ask. **Load the matching reference file now**
and follow its workflow.

## The corpus

All modes operate on the corpus home, resolved the same way the write job does — see
[write.md](write.md). Applying changes requires a file-based corpus in the current
workspace. For corpora homed in a provider (e.g. Notion), the modes still produce
proposals; apply them through whatever provider write tools are available, or manually.

When the corpus is homed in a provider, read its runbooks through `document_show` (or
the provider's own tools), and keep the maintenance artifacts — `CURATION_LOG.md` and
`proposals/` — in a local working directory the user names (default:
`runbook-maintenance/` in the current workspace); say where you put them. `--apply` is
never available for a provider-homed corpus — hand the proposal content to the user or
their provider write tools.

- Format rules — [format.md](format.md) is the rule set (tier model, size limits, one
  subject per file, exact-title chain links, verify-before-shipping). A corpus may carry
  its own `FORMAT.md` at its root, which takes precedence. Every proposal and edit obeys
  the rules; don't restate them — read them. A passage restating a skill's subject —
  tool mechanics the format says to chain to a skill — is a `verify` finding like any
  other broken format rule.
- `README.md` — the index at the corpus root. `curate`/`split` update it when files are
  added or split.
- `CURATION_LOG.md` — at the corpus root, created (with `## Entries` and `## Runs`
  sections) by the first run of any mode. Holds processed-incident history (`## Entries`)
  and run records (`## Runs`).
- `proposals/` — every mode's output directory, under the corpus root. Proposals are
  ephemeral review artifacts, not durable history — keep them out of version control
  (add `proposals/` to the corpus `.gitignore` on the first run); the run records are
  the durable history.

## Deterministic chores

Three checks recur across the modes. Run them as stated; don't re-derive or elaborate:

- **Processed IDs** — collect the incident IDs from the lines under `## Entries` in
  `CURATION_LOG.md`.
- **Chain-link check** — for every chain link in every runbook, confirm the target file
  exists and the link text equals the target's H1 exactly (agents resolve chains by
  title search).
- **Inventory** — line-count every runbook; flag files over 170 lines for review.

## Propose-only by default

Every mode defaults to writing a single proposal document under `proposals/` and changing
no runbook file:

- `curate` → `proposals/<YYYY-MM-DD>.md` (+ per-cluster staging under `proposals/<YYYY-MM-DD>/`)
- `split` → `proposals/<YYYY-MM-DD>-splits.md`
- `verify` → `proposals/<YYYY-MM-DD>-verification.md`

## Run records

Every run of any mode appends one line under `## Runs` in `CURATION_LOG.md`, whether
propose-only or apply:

```
<YYYY-MM-DD> | <mode> | <mode summary counts> | <propose|apply> | <warnings or ->
```

Warnings include: format violations found in drafts, fake-extends caught, tool-argument
drift (both defined in [curate.md](curate.md)), and aborted applies. Run records are the
trust gate's evidence and `verify --changed`'s anchor — never skip the append.

## The `--apply` trust gate (curate and split only)

`--apply` writes runbook files directly. Before honoring it, check:

1. **Run history.** At least one prior run record for this mode exists — the mode is
   exercised propose-only before its first apply, by design — and none of the last 3
   (or all, if fewer) records a format violation or fake-extends warning. When this
   drops a first-ever `--apply` to propose-only, say the warm-up is deliberate.
2. **Reviewable diff.** If the corpus home is in a git repository,
   `git status --porcelain <corpus home>` shows no uncommitted changes to runbook files
   that an apply could bury — ignore `proposals/` and `CURATION_LOG.md`, which this
   skill writes itself. If the corpus is not under version control, there is no diff for
   the user to review — drop to propose-only.

If the gate fails, drop to propose-only, tell the user why, and continue — never block,
never partially apply. `--apply` never commits; the user reviews the diff and drives the
commit. No mode posts messages or opens tickets.

## Sub-agent fan-out (shared shape)

- The main thread fans out; sub-agents never spawn sub-agents. Batches of 8–10 in
  parallel.
- Sub-agents never write to real runbook files or `CURATION_LOG.md` — staging files and
  returned findings only; the main thread consolidates and applies.
- Sub-agent prompts are self-contained: absolute paths for everything they touch.

## Shared preconditions

1. The corpus home resolves and its `README.md` is readable (and its `FORMAT.md`, if it
   carries one). If no corpus resolves at all: `curate` offers to bootstrap one first
   (directory plus README, per [write.md](write.md) step 2.3); `split` and `verify`
   report "no corpus found" and stop — there is nothing to audit.
2. Mode-specific preconditions live in each reference file.

## Outputs

- A proposal under `proposals/` and a run record in `CURATION_LOG.md` (always).
- Under `--apply`: real edits plus a diff stat of the corpus home.
- Never: commits, chat posts, or tickets.
