# Structure Map — 2026-03-05

This document records the canonical home for each class of note so the vault stays predictable.

## Top-Level Directories
| Path | Purpose |
| --- | --- |
| `inbox/` | Raw inputs that still need sorting (forms, quick captures, pending reviews). Empty when processed. |
| `dashboards/` | Daily/weekly operating surfaces (Daily Operational Dashboard, Q&A log, directive summaries). |
| `areas/` (`01_tiffany-bridges` … `08_ai-systems-lab`) | Domain folders for active areas of life/work. Each folder keeps its own README/index. |
| `projects/` | Active initiatives plus the `initiative-pipeline/` incubator. |
| `archive/` | Cold storage for completed or deprecated material. |
| `system/` | Agent + automation instructions, audits, scripts, templates, structure maps. |
| `memory/` | Long-term human memory snapshots and integrations (Oura, ClickUp, calendars, etc.). |
| Root files (`AGENTS.md`, `SOUL.md`, `USER.md`, `TOOLS.md`, `IDENTITY.md`) | Quick-reference doctrine. |

## Canonical Locations
- **Identity & Mandate** → `IDENTITY.md` (single source of truth). Supporting context lives in `system` if it’s about the agent, or `memory/` if it’s about Tiffany.
- **Operating guardrails** → `system/05_overwhelm-protection-system.md` and friends.
- **Daily logs** → `inbox/` while awaiting processing, then moved into the relevant dashboard/log once handled.
- **External data snapshots** → `memory/` only. If a domain folder needs the data, link to the snapshot instead of copying it.

## Naming & Metadata Rules
1. Use `Title Case.md` for canonical notes (`Core Identity.md` → `IDENTITY.md`).
2. Add YAML frontmatter where aliases are required:
   ```yaml
   ---
   aliases: [Core Identity]
   tags: [identity, system]
   ---
   ```
3. When a note is renamed or moved, let Obsidian update backlinks automatically.
4. Redirect stubs (notes that only point to another note) must include the `aliases` entry and a direct link to the canonical note.
5. Every operational note should declare `area`, `type`, and `status` in its frontmatter for Dataview queries.

## Maintenance Tasks
- **File index**: regenerate `system/audits/<date>_file-index.txt` whenever running a major cleanup.
- **Duplicate scan**: run `system/tools/find_duplicates.py` monthly (script to follow) and resolve any non-empty duplicates immediately.
- **Workspace hygiene**: delete `.obsidian/workspace.json` panes for files that no longer exist after each cleanup session.

_Update this map whenever we add a new area so future reorganizations stay simple._