# Hermes Auditor Verdict — 2026-09-18

**Generated:** 2026-09-18T14:00:02.790947+00:00
**Verdict:** 🟡 NOT HEALTHY (criteria failing below)

## Operational health criteria

| Criterion | Status |
|---|---|
| ≤25 created/24h | ❌ |
| no runaway >25% | ❌ |
| syscron 100% ok | ❌ |
| net debt ≤0 | ❌ |
| no starved real-signals >7d | ✅ |

## The 5-bucket

**1. Rate of creation:** 408 in last 24h vs 7d baseline 247.3 ± 276.1 (z=+0.6, OK)

**2. Rate of resolution:** 406 in last 24h

**3. Net debt:** +2 (created - resolved). Queue growing.

**4. Top-3 runaways (>25% of 24h volume):** D53 (319)

**5. Starved real-signals (open warning+ >24h):**
  - none

## Open queue snapshot

**Total open:** 5
  - critical: 3
  - warning: 2

## Infrastructure

**syscron_health:** 128/138 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
3. **Queue is leaking** — investigate top check_ids by 24h fire rate.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*