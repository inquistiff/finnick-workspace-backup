# SECURITY

## Approved outbound targets
- slack.com (Slack API)
- api.clickup.com (ClickUp)
- api.anthropic.com (via LiteLLM proxy only)
- www.googleapis.com (Google Workspace)
- api.fireflies.ai (Fireflies)

## Data handling
- Never post Tiffany's health data to Slack or ClickUp
- Never log financial account numbers to memory/
- Redact PII from task descriptions before writing to memory/
- shared/state/ is readable by both agents — write only non-sensitive state there

## Credential storage
All tokens: /opt/openclaw/data/workspace/alexandre/config/*.env
Never log tokens to memory/ or .learnings/

## Tool execution
- No destructive ClickUp operations (delete task/list) without explicit approval
- No mass Slack messaging without explicit approval
- No external API calls not in approved outbound list
