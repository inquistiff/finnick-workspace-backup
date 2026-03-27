# Skill: Task Creation

## Purpose
Create properly formatted ClickUp tasks from conversations, Slack messages, meeting notes, or Tiffany's verbal instructions. Ensure every task has the right structure so nothing falls through the cracks.

## Trigger
- Tiffany says "create a task for..." or "add this to ClickUp"
- Action items extracted from Fireflies transcripts
- Slack messages tagged with action items
- Alexandre identifies something that needs tracking during a conversation

## Inputs
1. **Task description** — what needs to be done (from conversation or transcript)
2. **Context** — which project/backlog this belongs to
3. **Priority** — if stated; otherwise Alexandre classifies
4. **Due date** — if stated; otherwise suggest based on urgency
5. **Assignee** — Tiffany, Finnick, Alexandre, or unassigned

## Task Template
Every task created must include:

```
Title: [Clear, action-oriented — starts with a verb]
List: [ClickUp list — NPE Backlog, OpenClaw Backlog, Web Dev, Rainmaker, Personal]
Priority: [Urgent / High / Normal / Low]
Due date: [date or "No date"]
Assignee: [person/agent]
Tags: [relevant tags]

Description:
**Context:** [Why this task exists — 1-2 sentences]
**Acceptance Criteria:**
- [ ] [Specific, measurable outcome]
- [ ] [Another outcome]
**Notes:** [Any additional context, links, references]
```

## Process
1. Parse the input for task details
2. Determine the correct ClickUp list based on context:
   - NPE work → NPE Backlog
   - Platform/infrastructure → OpenClaw Backlog
   - Website work → Web Dev Backlog
   - Sales/revenue → Rainmaker Backlog
   - Personal/home/family → Personal list
3. Write acceptance criteria — be specific enough that "done" is unambiguous
4. If priority or due date not specified, suggest based on context
5. Create task in ClickUp via API
6. Confirm creation to Tiffany with task link

## Constraints
- Never create a task without at least one acceptance criterion
- Title must be action-oriented (verb first): "Build X", "Fix Y", "Write Z" — not "X feature" or "Y issue"
- If the task is vague, ask one clarifying question before creating
- Don't create duplicate tasks — search ClickUp first
- Always tag tasks that came from meetings with "meeting-action-item"
- Log task creation in daily memory
