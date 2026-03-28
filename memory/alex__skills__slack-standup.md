# Skill: Slack Standup

## Purpose
Generate a daily standup summary from ClickUp task status and recent activity, and post it to the appropriate Slack channel. Keeps Tiffany and any collaborators informed without manual status updates.

## Trigger
- Scheduled: Weekdays at 9:00 AM ET
- Manual: "post standup" or "what's the status?"

## Inputs
1. **ClickUp** — tasks completed yesterday, tasks in progress, tasks due today
2. **Slack** — key threads or decisions from yesterday
3. **Memory** — yesterday's daily log, any carryover items
4. **Blockers** — anything flagged as blocked in ClickUp

## Process
1. Pull tasks completed since last standup from ClickUp
2. Pull tasks currently in progress
3. Identify tasks due today
4. Check for any blocked items
5. Scan Slack for decision threads Alexandre participated in
6. Format and post

## Output Format
Post to Slack in mrkdwn:
```
*Daily Standup — [date]*

*Done yesterday:*
- [task] (list: [ClickUp list])
- [task]

*In progress:*
- [task] — [% or status note]
- [task]

*Today's priorities:*
- [task] — due [date]
- [task]

*Blockers:*
- [blocker] — waiting on [who/what]
(or "None")

*Notes:*
- [any relevant context from Slack threads or decisions]
```

## Constraints
- Keep it under 20 lines
- Only include tasks from active backlogs (NPE, OpenClaw, Web Dev, Rainmaker)
- Don't include Finnick's internal tasks — this is for Tiffany's human-facing work
- If nothing was completed yesterday, say so — don't pad
- Post to #standup channel (or Tiffany DM if no channel configured)
