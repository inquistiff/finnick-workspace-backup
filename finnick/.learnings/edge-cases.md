# Edge Cases & Gotchas
Updated: 2026-03-23

## OpenClaw hooks — UNRESOLVED
- Correct hooks registration format for OpenClaw 2026.3.13 unknown
- Attempted openclaw.json "hooks" key → crash loop
- Scripts exist: workspace/hooks/pre-tool-use.sh, post-tool-use.sh, stop.sh
- Not currently called. Research correct format before W1-15.
- Do NOT add hooks key to openclaw.json until format is confirmed.

## Self-improvement capabilities — PERMANENT GAP
- clawhub not found in container
- self-improving-agent, learning-loop, capability-evolver: all blocked
- Manual replacement: this .learnings/ system
- Review whether clawhub becomes available in future OpenClaw releases

## LiteLLM / Anthropic key
- Key exposed in chat session on 2026-03-23
- Rotation pending — user action required at console.anthropic.com
- After rotation: update key in LiteLLM config and verify routing
