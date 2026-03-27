# Skill: Daily Briefing

## Purpose
Generate Tiffany's morning briefing — a single, scannable summary of what matters today so she can start her day informed without opening 6 apps.

## Trigger
- Cron: Every morning at 7:30 AM ET
- Manual: Tiffany asks "what's on today?" or "morning briefing"

## Inputs
1. **Google Calendar** — today's events and tomorrow's early events
2. **ClickUp** — tasks due today, overdue tasks, tasks assigned to Tiffany
3. **Oura Ring** — last night's sleep score, readiness score, HRV
4. **Slack** — unread DMs and mentions since last check
5. **Gmail** — flagged/starred emails, anything from Lisa or key contacts
6. **Memory** — yesterday's daily log (if exists), any pending decisions

## Process
1. Pull all inputs in parallel
2. Read Oura readiness score:
   - 85+: "High energy day — schedule deep work blocks"
   - 65-84: "Moderate energy — mix of focused and light tasks"
   - Below 65: "Low energy — light tasks only, protect recovery"
3. Check calendar for meetings — flag any with missing prep
4. Pull ClickUp tasks due today, sort by priority
5. Check for any overdue items (flag but don't guilt-trip)
6. Scan Slack/Gmail for anything urgent
7. Compile into briefing format

## Output Format
Deliver via Slack DM to Tiffany. Keep it tight — no fluff.

```
Good morning, Tiffany.

ENERGY: [Readiness score] — [recommendation]
Sleep: [score]/100 | HRV: [value] | [any notable flag]

TODAY'S CALENDAR:
- [time] [event] [prep needed: yes/no]
- [time] [event]

PRIORITY TASKS:
1. [task] — [source: ClickUp list] — [due]
2. [task] — [source] — [due]

OVERDUE (if any):
- [task] — was due [date]

NEEDS ATTENTION:
- [Slack DM from X about Y]
- [Email from Lisa re: Z]

YESTERDAY'S CARRYOVER:
- [anything unfinished from yesterday's log]
```

## Constraints
- Never stack more than 3 priority tasks on a low-energy day
- If readiness is below 55, lead with "Rest day recommended" and only surface truly urgent items
- Don't include tasks assigned to Finnick or Alexandre — only Tiffany's human tasks
- Keep the entire briefing under 30 lines

## Error Handling
- If Oura data unavailable: skip energy section, note "Oura data unavailable — check ring charge"
- If ClickUp unreachable: note it, pull from last cached task list
- If no calendar events: say "Clear calendar today"
