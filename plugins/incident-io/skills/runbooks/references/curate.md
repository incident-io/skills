# Mode: curate

Mine recent closed incidents for patterns the runbooks don't cover yet, and propose
additions or edits. This is the only mode that fetches incidents (via your incident.io
MCP connection). The shared contract (propose-only default, trust gate, run records,
fan-out shape) is in [maintain.md](maintain.md); this file holds the curate-specific workflow.

## Parameters

| Arg | Default | Meaning |
|-----|---------|---------|
| `--since` | date of the newest `## Entries` line in CURATION_LOG.md; `7d` if the log is empty | Window start for closed incidents. Also accepts `7d`/`30d`/`12h` or `YYYY-MM-DD`. |
| `--apply` | off | Write edits directly (gated — see maintain.md). |

Defaulting `--since` to the last log entry means an irregular cadence can't silently skip
weeks. Get the date from the last line under `## Entries`; don't read the whole log.

### Window size and tranches

Yield depends on your incident volume; longer windows grow linearly. Process windows over
14 days in sequential 7-day tranches, oldest first, each writing its log entries before
the next starts. If a single tranche yields more than 80 incidents after filtering,
process the most recent ~50, log them, and tell the user how many older incidents remain.
Tranches run sequentially because they share the log and the README, and later tranches
benefit from earlier tranches' new runbooks.

## Preconditions

1. `CURATION_LOG.md` is readable. If it doesn't exist yet, create it at the corpus root
   with `## Entries` and `## Runs` sections (the first run of any mode does this — see
   maintain.md); the processed set starts empty.
2. `incident_list` on your incident.io MCP connection responds. If the tool is missing or
   fails, stop and say so — never fabricate an incident list.

## Workflow

```
0. Processed IDs + window start from the log
1. Fetch closed incidents in the window
2. Filter to incidents with a completed investigation
3. Cluster by theme; fan out per-cluster sub-agents to read and draft
4. Corpus index: every runbook's H1, routing, and line count
5. Classify each incident against the index
6. Consolidate staging files into one proposal
7. Apply (only under --apply), then append log entries + run record
8. Surface the outcome
```

## Step 0: read the log

Collect the processed incident IDs from the lines under `## Entries` in
`CURATION_LOG.md`, and the window-start date from the newest entry. Skip any incident
whose ID is in the processed set. If the log was just created, treat the set as empty and
note it in the proposal.

## Step 1: fetch closed incidents

Call `incident_list` on your incident.io MCP connection with:

```
status_category: ["closed", "declined", "merged"]
mode: ["standard"]
created_after: <window start>
include: ["summary", "durations"]
page_size: 50
```

`created_after` is the only time filter the tool has, so a long-running incident created
before the window but closed inside it is missed — occasionally widen the window (or
lower `--since`) to catch them.

If your organization routes real incidents to a specific incident type, filter to it —
and cache its ID in an HTML comment at the top of `CURATION_LOG.md`
(`<!-- PRODUCTION_TYPE_ID: … -->`). If no ID is cached, ask the user whether one incident
type carries production response, then look up that type's ID (from a sample incident's
fields, or the connection's type listing if it has one) and cache it. Never infer the
type yourself — a wrong cached filter silently excludes incidents from every future run.
Exclude incident types that aren't production response (build failures, data-pipeline
jobs) unless asked to include them. Paginate via the `after` cursor, cap at 5 pages.

**Tool arg drift.** If the tool rejects a filter argument, retry once without it and apply
the constraint client-side. Never drop `mode: ["standard"]` — it excludes
test and tutorial incidents cheaply.

**Exclude**: severity informational or near-miss; duration under 5 minutes; summary under
50 characters; IDs already processed. Track exclusion counts for the report.

## Step 2: filter to investigated incidents

`investigation_list` for the survivors; keep incidents with at least one completed
investigation (most recent one if several). If investigations aren't available on your
connection, classify from summaries instead and note the reduced evidence in the proposal.

## Step 3: cluster and fan out

Group by apparent symptom class from summaries; aim for 5–12 clusters, none over ~20
incidents. One sub-agent per cluster, batches of 8, per the shared fan-out shape.

**Exhaustive classify, sampled deep-read.** Every incident gets a classification; the deep
investigation read is sampled — 2–3 representative closed incidents per cluster via
`incident_show` with `include: ["investigation"]`, the rest classified from summary +
hypothesis against those anchors. Don't assume a declined incident is noise; read the
summary first.

Per-cluster sub-agent brief:

- INPUT: incident IDs, cluster theme, the corpus index (step 4 below — build it first if
  fanning out early).
- TASK: read the sampled investigations; scan them for recurrence evidence (investigations
  often cite prior incidents — one in-window incident with real history beats two without);
  read the most-relevant runbook(s); classify each incident (step 5 rules); draft full
  file content for `new`, full diffs for `extends`. **Verify every claim in a draft
  against the code it cites** (word-bounded search, path existence) where the workspace
  holds that code — a claim that doesn't verify is dropped or generalized to the pattern
  form; if the cited code isn't in the workspace, mark the draft unverified in the
  proposal. This is the corpus's core rule; a drafted runbook with an unverified function
  name is a defect.
- OUTPUT: a staging file at `proposals/<YYYY-MM-DD>/<cluster-slug>.md` with a
  classification table, diffs, and drafts. Staging files survive truncated returns and
  let interrupted runs resume.
- CONSTRAINTS: no writes outside the staging file.

## Step 4: corpus index

Read every runbook's H1, `## Use this when` section, and line count. The index is what
incidents are classified against. Note files already over 170 lines — they are split
candidates, not extend targets.

## Step 5: classify

- **skip** — one-off customer request, data fix, or unknown conclusion; no generalizable
  pattern. If you can only state it as "customer X hit Y", skip.
- **matches** — an existing runbook's subject and routing already cover it. No file
  change; record the mapping.
- **extends** — belongs to an existing runbook's **owned subject** and adds a routing
  signature, a discriminator, or a fix direction. Never bolt a second subject onto a
  file — that's `new` or `split`, not `extends`. Propose a targeted diff.
- **new** — a genuinely new subject (component, mechanism, or technique). Needs a
  generalizable pattern, at least two generalizing diagnostic moves, and usually 2+
  incidents of evidence (or one plus cited history). Draft a full file per the format
  rules; subject-named filename, sentence-case H1; add the README index row (see the
  README spec in [format.md](format.md)).
- **split** — would be `extends`, but the target is over 200 lines or the addition is a
  second subject. Propose the new sibling plus the parent's narrowed routing and README
  updates.

## Step 6: proposal

One document at `proposals/<YYYY-MM-DD>.md`: summary counts, a coverage table
(incident → classification → runbook), proposed diffs, full drafts for `new`, and a
review checklist (no incident IDs/customer names in content; every claim verified; every
query names its datasource). Appendix: one paragraph per incident, proposal-only.

## Step 7: apply and log

Under `--apply` (gate passed): apply per incident, transactionally — `extends` edits the
target, `new` writes the file and edits `README.md`, `split` writes the sibling and edits
parent + README. **Fake-extends guardrail:** before logging an `extends`/`new`/`split`,
confirm the file actually changed (`git diff --name-only`, or compare content); no diff,
no log line — downgrade to `matches` or retry.

For every processed incident (including `skip`), append one line under `## Entries`:

```
<YYYY-MM-DD> | <incident_id> | <classification> | <runbook_or_dash> | <short note>
```

Then append the run record under `## Runs` (see maintain.md). In propose-only mode the log
append still happens — a rejected proposal still marks the incident processed; a human
can delete the line to reconsider.

## Step 8: surface

Report: proposal path; counts per classification; the top 3 highest-value proposals with
one-line rationale; warnings (tool arg drift, no-investigation drops, split flags). Under
`--apply`: the diff stat and a reminder to review before committing.

## Anti-patterns

- A new runbook for one incident with no history. Skip and note it.
- Drafting from an investigation hypothesis without confirming the hypothesis was right
  (resolution notes, the fixing PR).
- Extending a file past 200 lines or into a second subject — that's a split.
- A log line with no matching diff (fake extends) — the step 7 guardrail is the check.
- Carrying an unverified claim into a draft because the investigation asserted it.
