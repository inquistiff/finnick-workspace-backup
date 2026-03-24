# Finnick — HEARTBEAT

*Stub. Full intelligent system: Wave 2-07a.*

## Current (Wave 1 stub)
Nightly cron at 11pm: writes tool-generated timestamp, logs execution.

## Full System (W2-07a)
Will: review conversations → extract facts → update MEMORY.md → prune stale entries → fresh session.

## Known Bugs (community)
1. Stale timestamp (#44993): timestamps via `date` command, never LLM
2. LLM hallucination (#49086): ALL timestamps from tool/script, validated post-write
3. Cron lane backlog (#42097): set timeouts, monitor /var/log/finnick-memory.log

## heartbeat-state.json Schema
{"last_run": "<ISO from date>", "unix_ts": <epoch>, "status": "ok|warn|fail",
 "session_count_today": 0, "memory_entries_added": 0, "memory_entries_pruned": 0, "notes": ""}

Cron: 0 23 * * * /usr/local/bin/finnick-memory-maintenance.sh
