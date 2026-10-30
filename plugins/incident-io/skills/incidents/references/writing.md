# Writing

Incidents generate five kinds of writing, and each goes somewhere different.

## The five surfaces

- **Update message** — a point-in-time status update posted to the incident channel, a
  running narrative the response team reads. Set via `incident_update`'s `message`.
- **Summary** — the persistent description of what the incident *is*, kept current.
  Set via `incident_update`'s `summary`. It replaces; it doesn't append.
- **Postmortem** — the after-the-fact writeup, its own document with its own flow.
- **Stakeholder comms** — customer emails, exec briefings, status-page wording, for
  people *outside* the response. Never posted as an incident update.
- **Channel message** — a finding, a fix or a stack trace shared into the incident's
  channel with `incident_message`, for the responders. It changes nothing on the
  incident; see below.

If a request is only structured changes (status, severity, a field) and there's no extra
context to add about the change, **write no message at all** — each structured change
already renders its own row in the channel, so a message restating it is noise. Context
is what responders did, found or decided that no update has said yet, such as the fix
behind a resolve or the reason for a pause: when there is some, the message carries it.
Resolving and closing also bring a stale summary up to date, as `references/lifecycle.md`
says.

## Drafting versus posting

`incident_update` either posts a change (`action: execute`) or drafts it as a
suggestion (`action: suggest`) — a card in the channel that a person accepts, edits or
declines. Which one the user wants is in how they ask:

- **They want it posted or shared**, whether they hand you the text or leave the
  wording to you → execute. Posting is the deliverable; write what they left to you
  from the incident's context and post it.
- **They want a draft, a suggestion, or something to review** → suggest. The card is
  the deliverable, not prose: **never write the update into your reply instead**,
  however obvious the content is from the thread. Write it from the conversation and
  let them accept it.
- **They ask for a change without saying what it should be** → that is a request for a
  draft too. Fill sensible fields from the incident's context rather than asking what
  to write; the card is where they correct you.

From here a draft posts no card anyone can see. So after drafting, show its changes in your
reply (status, severity, message) and wait: this is the one exception to never writing the
update into your reply. Apply exactly what they approve with `incident_update`
(`action: execute` and its `suggestion_id`).

To change an existing draft, revise it with `action: edit_suggestion`. The revision replaces
the original, so there is no second draft to post or dismiss. Execute the `suggestion_id` it
returns once they've said to send it; until then, show the revision and wait. You can't dismiss a draft from here: if they don't want it, say
it can be dismissed in Slack or the dashboard.

## Update messages

Before writing an update, read the Update format section of the organisation's
configuration: it holds the guidelines every update follows and the format this
organisation chose. If the user asks for something different, do what they asked.

## Summaries

The summary is the incident's record of where things stand. Before writing one, read the
Summary format section of the organisation's configuration: it holds the guidelines every
summary follows and the format this organisation chose. Follow it even when the current
summary is shaped differently, because the format may have changed since it was written.
If the user asks for something different, do what they asked.

## Channel messages

A channel message shares something into the incident's channel: what someone found, a
fix that's out, the stack trace the responders need. It is not an update, so a status or
progress change still goes through `incident_update`. When the user's own work moved the
status, post one update, not an update plus a channel message: the new status, with a
message naming what they did and its PR or commit. The update already reaches the channel; add a channel message only when they
asked for the channel separately.

It posts under the user's name, and they can't edit or delete it afterwards:

- **Post when asked.** "Post that to the channel" is the go-ahead: write it and post it.
  Never post findings or conclusions of your own that nobody asked to share.
- **Keep their certainty and framing.** "Looks like the missing index, still confirming"
  stays tentative, and "pushed a fix" stays a fix, not a resolution. Say "the issue" or
  "the cause", not "root cause", unless they did. Name no one they didn't name.
- **Lead with the takeaway** in a sentence or two, with no headers or bullets; code, logs
  and detail go in `thread_message`. A short confirmation needs no thread.
- **Say when there's no channel.** An incident with no channel has nowhere to post: say
  so rather than claiming it went out.

## Stakeholder comms

Comms for people outside the response are drafts you produce and the user sends — you
never send them yourself, so don't say an email "has gone out" or a status page "is
updated"; say you've drafted it and where they can send it from. A status page update
goes through `status_page_update`, which drafts it for a human to publish —
publishing emails and texts every subscriber, so it is never yours to do. Match the
register to the audience: a customer email leads with impact and what you're doing
about it in plain language; an exec briefing is impact, mitigation, and ETA, short.

## Keep your analysis honest

This spans everything you write. Your own read of the cause is a **hypothesis**, and
it stays one until a responder independently states it as fact, because a
confident-sounding agent guess written into an update or summary becomes the thing
everyone else anchors on.

- Never call your own analysis confirmed, established, or verified.
- Someone asking whether it's the cause is not confirmation. Neither is your own
  earlier message sounding sure.
- Asked directly, give your best read and label it: "that's our leading theory", "we
  haven't proven that yet".
- If the incident has an AI investigation, its findings carry their own confidence
  levels — **preserve that hedging** when you relay them; don't harden "possible"
  into "the cause".
- An update speaks for the responders. Once one of them has stated the cause, write it
  as they did, without hedging it, even when the investigation's view is the only thing
  new since the last update: that view isn't the responders' news, so it never leads the
  draft or replaces their cause. Where the investigation disagrees, tell the user outside the draft, with
  the investigation's reason, and let them decide whether it goes in.
