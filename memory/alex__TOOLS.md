# TOOLS

## Wave 1 Active
- Slack: post to #alexandre-ea, read messages
  Bot token: config/slack.env (SLACK_BOT_TOKEN)
  App token: config/slack.env (SLACK_APP_TOKEN)
  Team: npeteam.slack.com | Bot user: alexandre_ea

## Wave 1 Pending
- ClickUp API (W1-19a): read Program Backlog, write task statuses
  Token: config/clickup.env (CLICKUP_TOKEN)
  Team ID: 6921343

## Wave 2+ Planned
- Google Workspace CLI (W2-02): Calendar, Drive, Gmail
- Fireflies (W2-xx): meeting transcription
  Token: config/fireflies.env (FIREFLIES_KEY)
- Make (automation triggers)

## Tool-First Checklist
Before answering "what's the status of X":
1. ClickUp task? → call ClickUp API
2. Slack message? → search Slack
3. Google file? → search Drive
Answer from memory only if ALL tools are unavailable.

## LiteLLM
URL: http://127.0.0.1:4000/v1/chat/completions
Model: claude-sonnet-4-6
Key: sk-finnick-lllm-9e6ddd906af7ab21

## Apple Ecosystem (via MCP → MacBook Pro → Tailscale)
MCP Server: `apple` (SSE at http://100.106.13.95:3100/sse)
Requires: Tiffany's MacBook Pro awake + Tailscale connected
Available: iMessage, Apple Notes, Apple Reminders, Calendar, Contacts, Mail, Maps
If Mac is offline → tell Tiffany tools are temporarily unavailable, don't fail silently.
See /skills/imessage/SKILL.md for iMessage rules (always draft before sending, never send without approval).
