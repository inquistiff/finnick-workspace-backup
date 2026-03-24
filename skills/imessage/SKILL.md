# iMessage Skill

## Overview
Finnick can read and send iMessages through the Apple MCP server running on Tiffany's MacBook Pro via Tailscale. This capability is available whenever the Mac is awake and connected to Tailscale.

## When to Use
- Tiffany asks to send a message to someone (Craig, Baylee, Lisa, etc.)
- Tiffany asks "what did [person] say?" or "check my messages"
- A workflow requires notifying someone via text (e.g., grocery list to Craig)
- Tiffany asks to read or search recent conversations

## How to Use
Use the `apple` MCP server tools for messages:
- **Read messages**: Search or list recent messages from a contact
- **Send messages**: Compose and send an iMessage to a specified contact
- **Search**: Find messages containing specific keywords or from specific people

## Important Rules
1. **NEVER send a message without Tiffany's explicit approval** — always show the draft first
2. **NEVER read messages proactively** — only when asked
3. Keep message tone casual and warm unless Tiffany specifies otherwise
4. For Craig: casual, direct. For Lisa: professional but friendly. For Baylee: mom-mode.
5. If the Mac is offline (Tailscale disconnected or lid closed), tell Tiffany the Apple tools are temporarily unavailable rather than failing silently

## Availability
Requires: MacBook Pro awake + Tailscale connected + supergateway launchd service running
Falls back to: Nothing — iMessage only works through Apple MCP on macOS
Future: Will move to Mac Mini as a permanent always-on node
