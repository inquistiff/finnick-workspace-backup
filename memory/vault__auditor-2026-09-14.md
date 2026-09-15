# Hermes Auditor Verdict — 2026-09-14

**Generated:** 2026-09-14T14:00:02.606769+00:00
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

**1. Rate of creation:** 17 in last 24h vs 7d baseline 631.0 ± 294.9 (z=-2.1, LOW)

**2. Rate of resolution:** 17 in last 24h

**3. Net debt:** +0 (created - resolved). Steady.

**4. Top-3 runaways (>25% of 24h volume):** D-LATENCY (7)

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

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*