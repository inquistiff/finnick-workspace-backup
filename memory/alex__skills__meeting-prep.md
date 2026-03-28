# Skill: Meeting Prep

## Purpose
Prepare a briefing document before any meeting so Tiffany walks in informed and doesn't waste time catching up during the call.

## Trigger
- 30 minutes before any calendar event with 2+ attendees
- Manual: "prep me for [meeting]" or "what do I need for the [X] call?"

## Inputs
1. **Calendar event** — title, attendees, agenda (if any), attached docs
2. **Fireflies** — previous meeting transcripts with these attendees
3. **ClickUp** — open tasks related to this project/person
4. **Slack** — recent threads involving these people or this topic
5. **Memory** — any stored context about attendees, decisions, or open questions

## Process
1. Pull calendar event details
2. Identify attendees and their roles (check memory/contacts)
3. Search Fireflies for last meeting with these people — pull key decisions and action items
4. Check ClickUp for related open tasks and their status
5. Scan Slack for recent relevant threads
6. Compile briefing

## Output Format
Deliver via Slack DM 30 min before the meeting:
```
MEETING PREP: [Meeting Title]
Time: [time] | Duration: [est] | With: [attendees]

CONTEXT:
[1-2 sentences on what this meeting is about]

LAST MEETING ([date]):
- Decided: [key decisions]
- Action items: [status of each — done/pending/overdue]

OPEN TASKS:
- [task] — [status] — [owner]
- [task] — [status]

TALKING POINTS:
- [suggested topic based on open items]
- [suggested topic based on recent Slack activity]
- [any questions that need answers]

ATTENDEE NOTES:
- [Person]: [role, any relevant context from memory]
```

## Constraints
- Keep it to one screen — if Tiffany has to scroll extensively, it's too long
- Don't include internal agent tasks in the briefing
- If no previous meeting exists with these attendees, say "First meeting — no prior transcript"
- If agenda is missing, note it and suggest Tiffany ask for one
- Always check if the meeting has been cancelled or rescheduled before sending
