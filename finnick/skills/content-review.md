# Skill: Content Review (QA Layer)

## Purpose
Review any content output — from Finnick, Alexandre, or a specialist agent — against Definition of Done (DOD) and acceptance criteria before it reaches Tiffany.

## Trigger
- A specialist agent returns completed work
- Finnick finishes a draft (email, blog post, document, etc.)
- Manual: "review this" or "QA check"

## Inputs
1. **Content to review** — the actual output
2. **Task context** — original request, acceptance criteria, DOD from ClickUp
3. **Tiffany's voice profile** — direct, warm but not soft, no fluff, smart and systems-oriented
4. **Format requirements** — if specified (word count, structure, platform constraints)

## QA Checklist
Run every item. If any fail, fix before passing to Tiffany.

### Grammar & Mechanics
- [ ] No spelling errors
- [ ] No grammatical errors
- [ ] Consistent tense and voice
- [ ] No orphaned formatting (broken links, unclosed tags, stray markdown)

### Tone & Voice
- [ ] Matches Tiffany's voice: direct, confident, no corporate fluff
- [ ] No passive voice where active is better
- [ ] No filler phrases ("I just wanted to...", "I hope this finds you well...")
- [ ] Reads like a human wrote it, not an AI

### Completeness
- [ ] All acceptance criteria from the task are met
- [ ] All sections/parts requested are present
- [ ] Links work (if any)
- [ ] Attachments included (if required)

### Formatting
- [ ] Correct format for the platform (email vs. blog vs. Slack vs. doc)
- [ ] Headers, spacing, and structure are clean
- [ ] Under any specified length limits

### Accuracy
- [ ] Facts are verifiable (no hallucinated stats or claims)
- [ ] Names spelled correctly
- [ ] Dates and numbers are accurate
- [ ] No contradictions with known context (check memory)

## Process
1. Pull the task's DOD and acceptance criteria
2. Run the full QA checklist against the content
3. If all pass: mark as "Ready for Review" and send to Tiffany
4. If any fail: fix what can be fixed, flag what can't, re-run checklist
5. Log the review in daily memory

## Output
Deliver to Tiffany with a one-line summary:
```
Ready for your review: [task name]
QA: All checks passed / [N] items flagged
[Link to content or inline content]
```

If items were flagged but not fixable:
```
Ready for your review: [task name]
QA: [N] items need your input:
- [issue 1]
- [issue 2]
[Link to content]
```

## Constraints
- Never pass content to Tiffany that has grammar errors — fix them
- Never pass content with placeholder text ("[INSERT X]") — flag it
- If acceptance criteria are missing from the task, note it but still QA against general standards
- This is Finnick's gatekeeper function — nothing gets through without this check
