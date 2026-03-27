# Skill: Task Triage

## Purpose
Evaluate incoming ClickUp tasks and classify them by urgency, effort, and who should handle them (Tiffany, Finnick, Alexandre, or a specialist agent).

## Trigger
- New task lands in Finnick's ClickUp queue
- Tiffany says "triage my tasks" or "what should I work on?"
- Scheduled: End of day, triage anything that came in during the day

## Inputs
1. **Task details** — title, description, due date, priority, tags, list/project
2. **Tiffany's current capacity** — Oura readiness (if available), calendar load today
3. **Existing task load** — what's already in progress or due soon
4. **Agent capabilities** — what Finnick and Alexandre can handle vs. what needs Tiffany

## Process
1. Read the task fully — title, description, acceptance criteria, attachments
2. Classify:
   - **Urgency**: Blocking (do now), Today, This Week, Backlog
   - **Effort**: Quick (<15 min), Medium (15-60 min), Deep (1+ hours)
   - **Owner**: Tiffany (requires human judgment/approval), Finnick (orchestration/automation), Alexandre (PM/Slack/task management), Specialist (writing, research, design)
3. If task is ambiguous or missing acceptance criteria, flag it — don't guess
4. Check for dependencies: does this task block or get blocked by anything?
5. Assign and notify

## Routing Rules
**Tiffany gets:**
- Strategic decisions, final approvals, client-facing calls
- Anything tagged "tiffany-only" or "approval-needed"
- Creative direction decisions

**Finnick handles:**
- Research compilation, content drafts, email drafts
- Health data interpretation, scheduling optimization
- Grocery lists, meal planning, travel logistics
- Any task that can be done without Tiffany's real-time input

**Alexandre handles:**
- Task creation/updates in ClickUp
- Slack communications and standup summaries
- Meeting prep docs, Fireflies transcript processing
- Backlog grooming and status tracking

**Specialist agents (future):**
- Long-form writing, graphic design, data analysis

## Output
Update the ClickUp task with:
- Assigned owner
- Priority classification
- Effort estimate
- Any flags (missing info, blocked, etc.)

Notify Tiffany via Slack only if something is Blocking urgency or requires her input.

## Constraints
- Never auto-assign Blocking tasks to Tiffany on low-energy days without flagging it
- If more than 5 tasks are due today, surface only top 3 and batch the rest
- Don't silently drop tasks — everything gets classified, even if it goes to Backlog
