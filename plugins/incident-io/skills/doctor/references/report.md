# The report

Every doctor run ends in this shape, whether it covered the whole estate or one
plugin. Its job is to be actionable on a skim and safe to file: the snapshot tells
the reader the estate's shape in five lines, the findings list tells them what to do
next and who does it, and only the briefs ask for sustained reading.

## Format

```markdown
# Estate review — <date> — <scope: whole estate | plugin/area>
<owner and cadence, once a standing review has agreed them>

<the situating block from orient.md — Session / This repo / Account / Health with
status glyphs — now reflecting anything the review verified>

## Findings, most actionable first

1. <glyph> <what and where, one line> — "<verbatim anchor>" (<file:line>) →
   **route:** <skill-authoring brief below | init: <the gap> | a change in the
   plugin's repository | dashboard: <the page> | previously declined, still
   recurring>
2. …

## Healthy

<the one-line credits: plugins synced, skills with good funnels, connections in
place — so the reader knows what was checked, not just what failed>

## Not readable from this session

<each surface the review couldn't reach, and where the answer lives>

## Briefs

<one per skill needing edits: the verified issues, the strengths to keep, ready to
hand to skill-authoring's improve job>
```

Rules the format encodes:

- **The reply opens at the header.** Working narration ("the sweep is back, one
  correction before I write up…") belongs in the run, not the reply — the first line
  the reader sees is `# Estate review`. Fold any last-minute correction into the
  finding it corrects.
- **The snapshot leads.** A reader who stops after the situating block still knows
  the estate's shape and whether anything is on fire — it mirrors the dashboard's
  own rollup, so the two never disagree. The review updates the block where it
  verified something orientation only summarized.
- **A finding is one line, maybe two.** What and where, the verbatim anchor, the
  route. Everything else — the reasoning, the related occurrences, the suggested
  edit — lives in that skill's brief. A findings list that needs paragraph-length
  entries is a briefs section leaking upward.
- **File findings carry their anchor.** A `file:line` goes stale the moment the file
  is edited; pair it with a short verbatim quote of the offending line so the reader
  can still find it after the numbers drift.
- **Findings carry routes, not instructions.** The brief carries the detail; the
  finding says who acts. Purely informational findings (a deliberate removal, a
  caution) route to the Healthy section or a note line — they still appear, they
  just ask nothing.
- **Healthy and unreadable are first-class sections.** A review that only lists
  problems can't be told apart from a review that only looked for them.
- **Nothing in the report has been changed by the run.** If a sentence would start
  "I fixed", the run went past its mandate.

## Cadence

Doctor is built to recur. When the user wants a standing review, agree the two
parameters and record them in the report header from then on:

- **Owner** — who reads the report and hands briefs on. A report nobody owns is
  noise.
- **Cadence** — weekly suits most estates; after each growth moment (a new
  connection, a new team's plugin) is the other natural trigger.

A scheduled run behaves exactly like an invoked one: same checks, same report,
propose-only. What accumulates between runs is the team's record — reports and
declined findings kept in the plugin's repository (the same home init's reports use),
which is what lets the next run say "previously declined, still recurring" instead of
re-escalating. Doctor never files that record itself: offer it, and on a scheduled
run deliver the report and say where it should be kept — a human lands it.
