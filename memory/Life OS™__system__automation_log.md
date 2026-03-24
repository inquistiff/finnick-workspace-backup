# Automation Log
Keep this updated whenever we add or run helper scripts so it’s obvious what lives in `system/tools/` and what reports to expect in `system/audits/`.

## Scripts
| Script | Purpose | Output |
| --- | --- | --- |
| `system/tools/find_duplicates.py` | Scans all `.md` files for identical content and writes a JSON report. | `system/audits/<timestamp>_duplicate-report.json` |
| `file-index` one-liner | `find . -name '*.md' | sort` snapshot for audits. | `system/audits/<date>_file-index.txt` |

_Add new rows when more scripts appear (e.g., dashboard refreshers, data ingestors)._
_Add `bin/` to your shell PATH to run these commands without cd’ing into the vault._

### Routines
- `make audit-index` → snapshot md file list
- `make duplicates` → run duplicate scan
- `make audit` → both
