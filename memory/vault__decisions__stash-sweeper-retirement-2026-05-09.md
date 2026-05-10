# ADR — Retire trace_id_sweeper stash-file subsystem

**Status:** ACCEPTED
**Date:** 2026-05-09
**Owner:** Workstream A / conductor-engine agent (originator) + layer3-rcfixer-v4 (this ADR landing)
**Supersedes:** Tier-3 Phase 2A trace_id stash-merge architecture (2026-05-08)
**Related:** ESC-3752, ESC-3762, ESC-3765 (D24 partial migration, separate)

---

## Context

The Tier-3 Phase 2A architecture (2026-05-08) introduced a "belt-and-suspenders" trace_id stash mechanism:

- **Writer:** `/home/openclawops/.hermes/hermes-agent/cron/scheduler.py:1189` writes `/tmp/hermes-trace-ids/{session_id}.txt` after each cron fires, containing `trace_id`, `cron_id`, `session_id`, `ran_at`.
- **Sweeper:** `/opt/openclaw/scripts/trace_id_sweeper.py` runs every 2 min (openclawops crontab) AND every 5 min (systemd timer `trace-id-sweeper.timer`), reads stash files, and merges `langfuse_trace_id` into `cron_runs` via `UPDATE WHERE hermes_session_id=?`.
- **Companion:** `cron_run_hook.py` (DELETED 2026-05-08 23:48 EDT, replaced by `cron_run_sweep.py`) used to insert the `cron_runs` row that the sweeper would later update.

This was meant to give the post-run hook a fast path to attach the Langfuse trace_id without round-tripping to Langfuse for the lookup.

## Problem

Two failure modes emerged in production within ~24h of Phase 2A landing:

1. **Session ID format mismatch (root architectural bug).** `scheduler.py` writes the stash with `session_id = "cron_<id>_<ts>"`. But `cron_run_sweep.py` writes the corresponding `cron_runs` row with `hermes_session_id = "manual_<id>_<ts>_<hash>"` (whenever the cron is manually invoked or runs via certain hot paths). The sweeper's `UPDATE WHERE hermes_session_id=?` never matches. Stash files orphan permanently.

   Example, 2026-05-09 05:05:27 EDT:
   - Stash file `/tmp/hermes-trace-ids/cron_6d79844a3ef7_20260509_050527.txt` (session_id=`cron_6d79844a3ef7_20260509_050527`)
   - Actual cron_runs row id=22863, hermes_session_id=`manual_6d79844a3ef7_20260509_090526_ba40`
   - Same cron_id (6d79844a3ef7), same wallclock minute, NO match on session_id → never merged

2. **Detector-as-spammer (Principle #29 violation).** When stash files orphaned, `_push_escalation("trace_id_sweeper_stuck", ...)` fired once per stuck file per check tick. With 2-min cron + 5-min systemd timer both running, the same 2 orphan files produced **666 lifetime / 41-per-hour** escalation spam by 2026-05-09 13:00 EDT. The detector had no dedup window.

## Options Considered

**A. Fix the session_id mismatch in `scheduler.py` + `cron_run_sweep.py`.** Align both to write the same canonical session_id (either prefix-stripped, or `manual_*` everywhere, or reuse the stash session_id in cron_run_sweep). Preserves the trace_id fast-path optimization.
- Pros: cleanest fix, preserves the perf benefit.
- Cons: touches two stable subsystems; semantic of "manual_" prefix may be load-bearing elsewhere; ~1-day sprint.

**B. Have sweeper match on `cron_id + timestamp_window` instead of `session_id`.** Use a fuzzy match: same cron_id + ran_at within ±60s.
- Pros: works without touching the writers.
- Cons: false-positive risk when same cron stacks two runs in the window (the original Phase 2A reason session_id was chosen). Would need to be the most recent unset row only.

**C. Retire the stash-merge subsystem entirely.** Drop the fast-path. Have the post-run hook (now `cron_run_sweep.py`) query Langfuse directly for the trace_id keyed on cron_id + timestamp.
- Pros: removes the entire failure surface (script + crontab + timer + escalation type). Less code to maintain.
- Cons: adds a network call per cron run; Langfuse latency risk; loses fast-path for offline scenarios.

**D. STOPGAP NOW + decide A/B/C later.** Remove the `_push_escalation` call from the sweeper (log-only mode), let stashes pile up silently in `/tmp/hermes-trace-ids/orphan/`, and pick a real fix in the next sprint.

## Decision

**D (stopgap) → C (retire) over the next sprint.**

D was shipped 2026-05-09 17:12:39 EDT by Workstream A:
- `cp trace_id_sweeper.py.bak-pre-stopgap-20260509T171239Z trace_id_sweeper.py` (rollback path)
- `_push_escalation` replaced with `logger.warning("STUCK (log-only): ...")`
- Verified: 0 trace_id_sweeper_stuck escalations since 17:12 EDT (vs prior 666 lifetime).

The path forward is C, not A or B:
- A is correct in spirit but expensive — touching `scheduler.py` + `cron_run_sweep.py` for a perf optimization that nobody is currently relying on doesn't pencil out.
- B introduces correctness risk for the fuzzy-window match. Phase 2A explicitly chose session_id over fuzzy match for this reason.
- C eliminates an entire class of failure (no more stash files, no more sweeper cron, no more dedup escalations). The Langfuse direct-lookup latency penalty is small (~50ms p50) and only fires post-run, off the critical path.

## Implementation Plan (for the sprint that lands C)

1. Update `cron_run_sweep.py` to fetch `langfuse_trace_id` directly from Langfuse using cron_id + ran_at window when `langfuse_trace_id IS NULL` after insert. (Langfuse public API supports filter by tags and time range.)
2. Remove the stash write block in `scheduler.py:1176-1197`.
3. Remove `trace_id_sweeper.py` from `/opt/openclaw/scripts/`.
4. Remove openclawops crontab entry `*/2 * * * * /usr/bin/python3 /opt/openclaw/scripts/trace_id_sweeper.py`.
5. Disable + remove `trace-id-sweeper.timer` and `.service` from `/etc/systemd/system/`.
6. Remove `trace_id_sweeper_stuck` and `trace_id_sweeper_backlog` from any escalation classifiers / debug check registry.
7. E2E: confirm a cron run produces a `cron_runs` row with `langfuse_trace_id` populated within 10s.

## Rollback / Recovery

If C goes badly:
- `cp /opt/openclaw/scripts/trace_id_sweeper.py.bak-pre-stopgap-20260509T171239Z /opt/openclaw/scripts/trace_id_sweeper.py` (restore the original)
- Re-add the stash write block to `scheduler.py` from `git show <pre-removal>:scheduler.py`
- Re-create the systemd unit + crontab entries
The whole thing can be reverted in <30 min.

If D's stopgap needs to be reverted (unlikely):
- `cp /opt/openclaw/scripts/trace_id_sweeper.py.bak-pre-stopgap-20260509T171239Z /opt/openclaw/scripts/trace_id_sweeper.py`

## Sources

- `/opt/openclaw/scripts/trace_id_sweeper.py` (post-stopgap)
- `/opt/openclaw/scripts/trace_id_sweeper.py.bak-pre-stopgap-20260509T171239Z` (pre-stopgap, audited diff)
- `/home/openclawops/.hermes/hermes-agent/cron/scheduler.py:1176-1197` (stash writer)
- `/home/openclawops/.hermes/scripts/cron_run_sweep.py` (cron_runs writer with `manual_*` session_id format)
- `/home/openclawops/.hermes/backups/cron_run_hook.py.deleted-20260509T034835` (predecessor)
- ESC-3752 (original architectural-debt observation)
- ESC-3762 (urgent handoff to conductor agent)
- HERMES_RUNBOOK.md § Tier 3 services (no current entry for trace-id-sweeper.timer — should be REMOVED on C landing)

## Owners + Acknowledgement

- Authored by: layer3-rcfixer-v4 (2026-05-09 22:15 UTC)
- Stopgap (D) shipped by: Workstream A / conductor-engine agent (2026-05-09 17:12 EDT)
- ACK contract: this ADR is the formal record of the stopgap + retirement plan. ESC-3762's ACK contract (06:00 UTC tomorrow) is hereby satisfied by this document.
- Sprint owner for C landing: TBD (suggest conductor agent + 1-day slot).
