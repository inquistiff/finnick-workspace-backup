# Automation Classification (Heartbeat vs. Cron)

## Cron (fixed-time, scripted jobs)
| Task | Why Cron? |
| --- | --- |
| Daily Pulse prompt (10:30 AM ET) | Needs to fire at a precise time even if there’s no user activity. |
| Dashboard refresh (10:45 AM ET) | Deterministic shell script (`generate_daily_directive.sh`). |
| Daily Questions (11:00 AM ET) | Generates content + delivers it regardless of user presence. |

> All cron jobs live in `system/cron_registry.md` and are backed by `Makefile` targets/scripts where possible.

## Heartbeat (state & inbox sweeps)
| Check | Frequency | Notes |
| --- | --- | --- |
| Email inbox sweep | 3×/day (morning, midday, evening) | Use CLI client (e.g., `himalaya`) to list new priority mail and queue replies/drafts. |
| Calendar delta + prep | 3×/day | Compare next 48 h in iCloud calendar to tasks; flag prep gaps. |
| Weather & travel alerts | Morning + evening | Quick `wttr` call for Knoxville or current travel city. |
| Oura snapshot + interpretation | Morning heartbeat | Run `make oura`; push results to `memory/OURA_*`. |
| Fireflies transcript pull | Midday heartbeat (or after meeting days) | Run `make fireflies`, append summaries where needed. |
| Automation health | Daily | Verify gateway status, cron logs, and `bin/` scripts (`make audit`). |
| Social/communication mentions (Slack/Telegram/etc.) | Daily or when prompted | Use platform CLIs only during heartbeat to avoid unnecessary cron noise. |

Heartbeat items get listed in `HEARTBEAT.md` (below) so the agent knows what to check when the platform pings for a heartbeat.
