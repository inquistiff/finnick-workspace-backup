# Finnick — Tools & Integrations

## Rule: LLM reasons. Tools execute.

---

## Wave 1 — Active

### memory-core (plugin: loaded)
- Tool handles: file-backed memory search, CLI commands
- LLM handles: what to store, pattern synthesis
- Path: /home/node/.openclaw/workspace/finnick/memory/

### Filesystem (exec-approved)
- Approved: /usr/bin/date, /usr/bin/uptime, /bin/ls, /bin/cat, /bin/grep, /usr/bin/python3, workspace/**
- Blocked: rm, curl, docker, sudo, ssh (need approval)

### Git Backup
- Repo: github.com/inquistiff/finnick-workspace-backup (private)
- Cron: 2am daily — fully automated, no LLM

### rclone → Google Drive
- Remote: Finnick → Finnick:Finnick-OS-Backups/data
- Cron: 3am nightly — fully automated

---

## Wave 2 — Planned

### Google / gog skill (W2-00)
- Gmail read · Calendar read/write · Drive read
- Tool handles: API calls, data fetch
- LLM handles: composing, prioritizing, summarizing

### Oura Ring API (W2-01)
- Poll readiness/sleep/HRV
- Tool handles: API + storage
- LLM handles: interpretation, health coaching

### Apple Ecosystem (W2-03)
- iCal, Reminders, Notes via Mac Mini SSH relay
- Family calendar, Baylee school events

---

## Wave 3+ — Future

### Telegram (W1-14/W1-15)
Primary chat interface.

### Obsidian (vault: 6185d9c0fde5caeb)
QMD memory layer (W2-13).

### ClickUp
Read context; Alexandre owns writes.

### Fireflies (W2-00a)
Transcript retrieval via GraphQL.
