# Skill: Fireflies Transcript Processing

## Purpose
Process Fireflies meeting transcripts into structured action items, decisions, and key takeaways. Ensure nothing said in a meeting gets lost.

## Trigger
- New Fireflies transcript available (webhook or poll)
- Manual: "process the [meeting name] transcript" or "what happened in the call with [person]?"

## Inputs
1. **Fireflies transcript** — full text, speaker labels, timestamps
2. **Fireflies AI summary** — if available (action items, topics, sentiment)
3. **Calendar event** — meeting context, attendees
4. **ClickUp** — existing tasks related to meeting topic (for linking)

## Process
1. Pull the transcript from Fireflies API
2. Read the AI-generated summary first for quick context
3. Scan transcript for:
   - **Decisions made** — anything agreed upon ("let's go with...", "we'll do...", "agreed")
   - **Action items** — commitments with an owner ("I'll handle...", "[Name] will...", "can you...")
   - **Questions raised but not answered** — follow-up needed
   - **Key quotes** — notable statements worth preserving
   - **Deadlines mentioned** — explicit dates or timeframes
4. Cross-reference action items against existing ClickUp tasks
5. Create new ClickUp tasks for action items not already tracked (use task-creation skill)
6. Log meeting summary to daily memory

## Output Format
Post to Slack and save to memory:
```
MEETING SUMMARY: [Title]
Date: [date] | Duration: [length] | Attendees: [names]

DECISIONS:
1. [Decision] — agreed by [who]
2. [Decision]

ACTION ITEMS:
- [ ] [Action] — Owner: [name] — Due: [date if mentioned]
- [ ] [Action] — Owner: [name]
  → ClickUp: [created/linked to existing task]

OPEN QUESTIONS:
- [Question] — needs follow-up with [who]

KEY TAKEAWAYS:
- [1-2 sentence summary of the most important thing discussed]

FULL TRANSCRIPT: [Fireflies link]
```

## Constraints
- Don't summarize pleasantries or small talk — only substantive content
- If speaker attribution is unclear, note it rather than guessing
- Always create ClickUp tasks for action items — don't just list them
- Tag meeting-generated tasks with "meeting-action-item" in ClickUp
- If the transcript is from a recurring meeting (e.g., weekly with Lisa), compare action items to last meeting's to catch anything that fell through
- Respect confidentiality — if the meeting involves external parties, don't post full details to public Slack channels
