# Hermes Auditor Verdict — 2026-10-17

**Generated:** 2026-10-17T14:00:02.975855+00:00
**Verdict:** 🟡 NOT HEALTHY (criteria failing below)

## Operational health criteria

| Criterion | Status |
|---|---|
| ≤25 created/24h | ❌ |
| no runaway >25% | ✅ |
| syscron 100% ok | ❌ |
| net debt ≤0 | ✅ |
| no starved real-signals >7d | ❌ |

## The 5-bucket

**1. Rate of creation:** 2842 in last 24h vs 7d baseline 2222.9 ± 710.9 (z=+0.9, OK)

**2. Rate of resolution:** 2842 in last 24h

**3. Net debt:** +0 (created - resolved). Steady.

**4. Top-3 runaways (>25% of 24h volume):** none

**5. Starved real-signals (open warning+ >24h):**
  - #140806 (warning, D42): T1-exhausted: D42 same-body ×10
  - #145600 (warning, D10): T1-exhausted: D10 same-body ×21621

## Open queue snapshot

**Total open:** 10
  - critical: 3
  - warning: 7

## Infrastructure

**syscron_health:** 119/129 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*