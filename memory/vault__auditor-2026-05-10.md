# Hermes Auditor Verdict — 2026-05-10

**Generated:** 2026-05-10T04:08:36.850274+00:00
**Verdict:** 🟡 NOT HEALTHY (criteria failing below)

## Operational health criteria

| Criterion | Status |
|---|---|
| ≤25 created/24h | ❌ |
| no runaway >25% | ❌ |
| syscron 100% ok | ✅ |
| net debt ≤0 | ✅ |
| no starved real-signals >7d | ✅ |

## The 5-bucket

**1. Rate of creation:** 353 in last 24h vs 7d baseline 49.0 ± 50.4 (z=+6.0, HIGH)

**2. Rate of resolution:** 354 in last 24h

**3. Net debt:** -1 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** trace_id_sweeper_stuck (186)

**5. Starved real-signals (open warning+ >24h):**
  - none

## Open queue snapshot

**Total open:** 11
  - info: 9
  - warning: 2

## Infrastructure

**syscron_health:** 116/116 ok

## Recommended next session focus

2. **Quarantine the runaway** — single check_id is producing >25% of volume.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*