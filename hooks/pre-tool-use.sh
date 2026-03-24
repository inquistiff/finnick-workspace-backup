#!/bin/bash
INPUT=$(cat)
TOOL=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name','unknown'))" 2>/dev/null || echo "unknown")
DANGEROUS_PATTERN="^(rm|rmdir|chmod|chown|dd|mkfs|fdisk|kill|killall|shutdown|reboot)$"
if echo "$TOOL" | grep -qE "$DANGEROUS_PATTERN"; then
    echo "BLOCKED: $TOOL requires manual approval" >&2
    exit 2
fi
echo "$(date '+%Y-%m-%d %H:%M:%S') PRE: $TOOL" >> /var/log/finnick-tools.log
exit 0
