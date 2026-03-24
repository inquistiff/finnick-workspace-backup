# Tool Learnings
Updated: 2026-03-23

## openclaw.json
- "hooks" key → schema validation error → gateway crash loop. Never add. Scripts in workspace/hooks/ exist but are not auto-called.
- diagnostics-otel stays disabled without an OTel collector endpoint configured. Expected.
- clawhub CLI not present in container. self-improving-agent, learning-loop, capability-evolver cannot install.

## secureclaw
- Extension only, not a shell CLI. No standalone audit command. Score (59/100) from prior session stands.
- `secureclaw harden` is PERMANENTLY OFF LIMITS — do not run under any circumstances.

## Docker networking
- `curl 100.85.9.1:18789` from VPS host → returns 000. Loopback iptables issue. Not a real error.
- `docker exec openclaw curl localhost:18789` → reliable gateway health check.

## rclone
- Remote: Finnick → personal Google Drive
- Target: Finnick:Finnick-OS-Backups/data
- Excludes: extensions/**, node_modules/**
- First verified run: 63 files, 111.578 KiB, 1m14s
