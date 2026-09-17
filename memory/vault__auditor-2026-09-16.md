# Hermes Auditor Verdict — 2026-09-16

**Generated:** 2026-09-16T14:00:02.918921+00:00
**Verdict:** 🟡 NOT HEALTHY (criteria failing below)

## Operational health criteria

| Criterion | Status |
|---|---|
| ≤25 created/24h | ❌ |
| no runaway >25% | ❌ |
| syscron 100% ok | ❌ |
| net debt ≤0 | ✅ |
| no starved real-signals >7d | ❌ |

## The 5-bucket

**1. Rate of creation:** 53 in last 24h vs 7d baseline 384.1 ± 342.0 (z=-1.0, OK)

**2. Rate of resolution:** 54 in last 24h

**3. Net debt:** -1 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** D03 (30)

**5. Starved real-signals (open warning+ >24h):**
  - #97219 (warning, D23): D-Check D23: Integration Health

## Open queue snapshot

**Total open:** 2
  - critical: 1
  - warning: 1

## Infrastructure

**syscron_health:** 128/138 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*