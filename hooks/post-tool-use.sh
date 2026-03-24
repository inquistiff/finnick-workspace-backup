#!/bin/bash
INPUT=$(cat)
TOOL=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name','unknown'))" 2>/dev/null || echo "unknown")
echo "$(date '+%Y-%m-%d %H:%M:%S') POST: $TOOL" >> /var/log/finnick-tools.log
exit 0
