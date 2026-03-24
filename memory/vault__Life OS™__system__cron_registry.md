# Cron Registry

| Name | Schedule (local) | Purpose | Inputs | Output / Delivery | Notes |
| --- | --- | --- | --- | --- | --- |
| daily-questions | 11:00 AM ET daily (`0 11 * * *` tz=America/New_York) | Run daily questions flow: generate 10 prompts, append to `dashboards/daily-qa-log.md`, and send questions to Tiffany | `daily_questions.py` script (question pool), Oura/ClickUp not required | System event `AUTO_DAILY_QUESTIONS` in main session → triggers assistant to send questions in Telegram | Created 2026-03-01 |
| daily-pulse | 10:30 AM ET daily (`30 10 * * *` tz=America/New_York) | Prompt Tiffany for the daily pulse input (Mode + quick context) | Oura snapshot + current calendar when available | System event `AUTO_DAILY_PULSE` in main session → assistant sends pulse template | Added 2026-03-01 |
| dashboard-refresh | 10:45 AM ET daily (`45 10 * * *` tz=America/New_York) | Run `generate_daily_directive.sh` to refresh Mode & Guardrails + dashboard summary, then post update | Script `~/.openclaw/scripts/generate_daily_directive.sh`, Oura + ClickUp data | System event `AUTO_DASHBOARD_REFRESH` triggers assistant to run script + share summary | Added 2026-03-01 |
