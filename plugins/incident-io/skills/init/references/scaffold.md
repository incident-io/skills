# Scaffold and register the plugin

Create the plugin tree in the team's repository and register it with incident.io.
Check-first throughout: on a re-run, most of this file is verification.

## 1. Does a plugin already exist?

`extension_plugin_list` (or the dashboard's Extensions page). If the team already has
a plugin, everything below reduces to: put new skills in it, fix anything the
inventory flagged (sync errors), and re-sync. Never create a second plugin beside a
working one without the user asking for it.

## 2. Resolve the home

Same ladder as every write in this plugin's skills: an existing repository the team
already keeps operational content in wins; a repository the user names comes next;
only then propose a new one. The plugin can live at the repository root or under a
subpath (`plugins/ops/`, `agent/` — the team's call), which keeps it comfortable
inside an existing repo.

Confirm the choice before writing anything: name the repository, the subpath, and
what will be created.

## 3. The tree

The minimum that syncs and serves:

```
<subpath>/
├── README.md            — the skills table and the connections table
└── skills/
    └── <first-skill>/
        └── SKILL.md
```

The structural rules — directory names as identity, descriptions as triggers,
environment-neutral tool naming, what goes in the README's two tables — are the
`skill-authoring` skill's format reference
([../../skill-authoring/references/format.md](../../skill-authoring/references/format.md)).
Hold the scaffold to it from the first file: retrofitting conventions is how registries
drift. The skills themselves are drafted through `skill-authoring`'s create job, per
accepted candidate brief.

## 4. Register

The repository must be reachable through the organization's connected GitHub or
GitLab integration — the inventory's source-control line has this state; if it's
unknown or missing, ask, and link the user to the dashboard's integrations page
before registering. (Reachability isn't checked at registration — an unreachable
repository surfaces as a `sync_error` in step 5, so a wrong guess here is caught,
just slowly.)

Confirm before calling: name the repository, the subpath, and every skill directory
that will go live — registration enables every skill under the subpath at once, so
pre-existing skills ship to the organization's agents in the same moment. Then, where
the session has the tool:

```
extension_plugin_create(provider: "github", repo_owner: "<owner>",
                        repo_name: "<repo>", subpath: "<subpath, omit for root>",
                        name: "<mount name>")
```

Set `name` deliberately. It defaults to the plugin directory or the repository name, so
two repositories that both keep their plugin at a conventional subpath — `ops/`,
`agent/` — ask for the same mount name. The mount is what agents see, so choose one that
stays distinct across the whole estate rather than relying on the default.

The first sync starts immediately, asynchronously. Without the tool, the dashboard's
Extensions page has the same add flow — walk the user through it with the values
above.

## 5. Verify the sync landed

Don't declare success on registration. Check `extension_plugin_list` a few moments
later: a healthy plugin shows a completed sync and the skills you scaffolded; an
inaccessible repository or malformed tree shows up in `sync_error`. Report either
outcome plainly. After later pushes, plugins re-sync on a schedule;
`extension_plugin_sync(plugin: "<name or id>")` pulls the change now instead.

If the plugin's skills are selected by an allowlist rather than automatically (a
dashboard setting), a new skill also needs enabling there — say so rather than
assuming pickup.

## 6. The run's report

End the whole init run — whichever steps it touched — with the inventory block
(updated for anything created), the proposals accepted and declined, and what happens
next: when agents will see the skills, where feedback will accumulate, and what to
re-run init for. On a first setup this is the team's record of what their estate is;
on a re-run it's the diff. Offer to keep the report in the plugin's repository (a
dated file, or the pull request description) — that's what lets the next run see what
was already considered and declined.
