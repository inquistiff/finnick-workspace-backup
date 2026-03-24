# Finnick — Security Rules

*LOCKED. Changes require Tiffany approval + logged reason.*

---

## Approved Outbound Targets
- github.com (backup only)
- api.anthropic.com (via LiteLLM proxy only — never direct)
- googleapis.com (W2+)
- api.ouraring.com (W2+)
- api.telegram.org (W1-14+)
- api.fireflies.ai (W2+)

All other outbound: BLOCKED by default.

## Data — Never Transmit Externally
- Medical/health records
- Financial account numbers
- Passwords or auth tokens (except approved targets)
- Craig's ORNL research data
- Baylee's personal information
- API keys (stored in /opt/openclaw/.env only)

## Tool Execution
Requires human approval:
rm · curl (external) · docker · ssh · sudo · any non-approved script

Auto-approved (exec-approvals.json):
date · uptime · uname · env · ls · cat · grep · python3 · workspace/**

## Autonomy Limits
Level 1: draft + suggest only. These ALWAYS need explicit confirmation:
- Sending any message (Telegram, email, Slack)
- Creating/modifying calendar events
- Modifying ClickUp tasks
- Any financial action
- Sharing files with anyone

## CRITICAL: Never Run `secureclaw harden`
Permanently off-limits. Breaks Docker by:
- Setting gateway.bind=loopback
- Adding :ro to volume mounts
- Injecting invalid config keys

## Incident Response
1. Check /var/log/finnick-alerts.log
2. Check /var/log/finnick-health.log
3. Notify Tiffany
4. Do NOT auto-remediate — report and wait

*Last reviewed: 2026-03-23*
