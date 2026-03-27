# Finnick — Tools & Integrations

## Rule: LLM reasons. Tools execute.

**Last verified:** 2026-03-26 | **Source of truth:** `finnick-telegram-bot-v2.py` TOOLS list

---

## Live Tools (17 total)

### Health
- `get_oura_data` — Readiness, sleep, HRV, activity from Oura Ring

### Tasks & Work
- `get_clickup_tasks` — Pull backlog (program / webdev / rainmaker)
- `create_clickup_task` — Add a new task to ClickUp
- `update_task_status` — Mark tasks in progress, complete, blocked, etc.
- `add_task_comment` — Log notes or updates to a task

### Calendar
- `get_calendar_events` — Google Calendar (work/schedule)
- `get_ical_events` — Apple/iCloud Calendar (personal/family)

### Email
- `search_gmail` — Search Gmail inbox
- `check_icloud_mail` — Search iCloud/personal email

### Meetings
- `search_meetings` — Search Fireflies transcripts by topic
- `get_action_items` — Pull open action items from recent meetings

### Notion
- `search_notion` — Search Notion workspace / Life OS
- `get_notion_page` — Fetch full content of a specific page

### Memory & Files
- `write_memory` — Persist something important to long-term memory on disk
- `read_memory` — Read recent memory entries or search by keyword
- `read_file` — Read any file in workspace (SOUL.md, USER.md, config, etc.)
- `list_files` — List files in a workspace directory

---

## Architecture Note

Finnick's tools are defined in `finnick-telegram-bot-v2.py` as Python dicts in OpenAI function-calling format. They are sent directly to LiteLLM in each API call. They are NOT OpenClaw gateway tools. To add a new tool: (1) add a definition to the `TOOLS` list, (2) add a handler in `execute_tool()`, (3) redeploy the bot.

---

## Planned (Wave 2+)

### Google Drive (W2-00)
- Gmail compose · Calendar write · Drive read/write

### Apple Ecosystem (W2-03)
- iCal write, Reminders, Notes via MacBook Pro Apple Bridge (port 3200)

### Obsidian (W2-13)
- QMD memory layer, vault: 6185d9c0fde5caeb

### Image Generation (W3-03)
- Native Gemini API for illustrations
