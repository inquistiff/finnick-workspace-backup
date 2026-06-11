# Hermes Auditor Verdict — 2026-06-10

**Generated:** 2026-06-10T14:00:01.862074+00:00
**Verdict:** 🟡 NOT HEALTHY (criteria failing below)

## Operational health criteria

| Criterion | Status |
|---|---|
| ≤25 created/24h | ✅ |
| no runaway >25% | ❌ |
| syscron 100% ok | ❌ |
| net debt ≤0 | ✅ |
| no starved real-signals >7d | ❌ |

## The 5-bucket

**1. Rate of creation:** 9 in last 24h vs 7d baseline 23.6 ± 13.8 (z=-1.1, OK)

**2. Rate of resolution:** 17 in last 24h

**3. Net debt:** -8 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** D-LATENCY (4), D03 (4)

**5. Starved real-signals (open warning+ >24h):**
  - #6614 (warning, D-PWG-REFUSED): D-PWG-REFUSED: prod-write-gate.sh refusal/partial-release th
  - #6616 (warning, ?): PR_FILING_BLOCKED_0005
  - #6617 (warning, ?): PR_FILING_BLOCKED_0003
  - #6686 (warning, D04): D-Check D04: Error Rate
  - #6687 (warning, D36): D-Check D36: Experiment Pipeline

## Open queue snapshot

**Total open:** 12
  - critical: 2
  - warning: 10

## Infrastructure

**syscron_health:** 130/136 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*