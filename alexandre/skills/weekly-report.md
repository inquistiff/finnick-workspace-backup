# Skill: Weekly Report

## Purpose
Summarize the week's progress across all active backlogs — what got done, what's in progress, what's blocked, and what's coming next week. Gives Tiffany a clean snapshot for weekly planning.

## Trigger
- Scheduled: Friday at 4:00 PM ET
- Manual: "weekly report" or "how'd we do this week?"

## Inputs
1. **ClickUp** — tasks completed this week, tasks moved to in-progress, new tasks created, overdue tasks
2. **Daily memory logs** — Mon-Fri summaries
3. **Slack** — key decisions or announcements this week
4. **Fireflies** — meetings held this week, action items generated

## Process
1. Pull all ClickUp activity for the current week (Mon-Fri)
2. Group by backlog: NPE, OpenClaw, Web Dev, Rainmaker, Personal
3. Calculate: tasks completed, tasks added, net change, overdue count
4. Pull key decisions from daily logs and Slack
5. Identify carryover items for next week
6. Compile report

## Output Format
Deliver via Slack DM and optionally save to Notion.

```
WEEKLY REPORT — Week of [date range]

SUMMARY:
- Completed: [N] tasks
- New tasks added: [N]
- In progress: [N]
- Overdue: [N]

BY BACKLOG:

NPE:
- Done: [list]
- In progress: [list]
- Blocked: [list or "None"]

OpenClaw:
- Done: [list]
- In progress: [list]

[repeat for active backlogs]

KEY DECISIONS THIS WEEK:
- [decision] — [date, context]

MEETINGS:
- [N] meetings held
- Notable: [any meeting with significant outcomes]

CARRYOVER TO NEXT WEEK:
- [task] — [reason it carried over]

NEXT WEEK PRIORITIES:
- [suggested priority 1]
- [suggested priority 2]
- [suggested priority 3]
```

## Constraints
- Group by backlog, not by day — Tiffany thinks in projects, not timelines
- If a backlog had zero activity, still list it with "No activity this week"
- Keep completed task descriptions to one line each
- Don't list sub-tasks — roll up to parent task level
- Suggest next week's priorities based on due dates and momentum, but Tiffany decides
