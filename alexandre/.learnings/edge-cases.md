# Edge Cases & Gotchas
Updated: 2026-03-23

## Slack channel creation
- Bot lacks channels:write scope
- #alexandre-ea must be created manually by Tiffany, then bot invited
- Do not attempt programmatic channel creation

## Shared directory
- shared/ lives at /opt/openclaw/data/workspace/shared/
- Both agents read/write here — coordinate carefully
- energy-mode.md (Finnick writes) → Alexandre reads before work sessions
