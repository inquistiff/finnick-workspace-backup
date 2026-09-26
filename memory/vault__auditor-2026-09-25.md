# Hermes Auditor Verdict — 2026-09-25

**Generated:** 2026-09-25T14:00:02.544845+00:00
**Verdict:** 🟡 NOT HEALTHY (criteria failing below)

## Operational health criteria

| Criterion | Status |
|---|---|
| ≤25 created/24h | ❌ |
| no runaway >25% | ❌ |
| syscron 100% ok | ❌ |
| net debt ≤0 | ✅ |
| no starved real-signals >7d | ✅ |

## The 5-bucket

**1. Rate of creation:** 1492 in last 24h vs 7d baseline 920.7 ± 470.7 (z=+1.2, OK)

**2. Rate of resolution:** 1493 in last 24h

**3. Net debt:** -1 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** D06 (705), D23 (704)

**5. Starved real-signals (open warning+ >24h):**
  - none

## Open queue snapshot

**Total open:** 4
  - critical: 2
  - warning: 2

## Infrastructure

**syscron_health:** 130/138 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*