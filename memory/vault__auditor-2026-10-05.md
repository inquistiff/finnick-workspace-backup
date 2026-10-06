# Hermes Auditor Verdict — 2026-10-05

**Generated:** 2026-10-05T14:00:03.183526+00:00
**Verdict:** 🟡 NOT HEALTHY (criteria failing below)

## Operational health criteria

| Criterion | Status |
|---|---|
| ≤25 created/24h | ❌ |
| no runaway >25% | ✅ |
| syscron 100% ok | ❌ |
| net debt ≤0 | ❌ |
| no starved real-signals >7d | ❌ |

## The 5-bucket

**1. Rate of creation:** 2613 in last 24h vs 7d baseline 1564.0 ± 614.8 (z=+1.7, OK)

**2. Rate of resolution:** 2607 in last 24h

**3. Net debt:** +6 (created - resolved). Queue growing.

**4. Top-3 runaways (>25% of 24h volume):** none

**5. Starved real-signals (open warning+ >24h):**
  - #110300 (warning, D10): T1-exhausted: D10 same-body ×5075

## Open queue snapshot

**Total open:** 11
  - critical: 3
  - warning: 8

## Infrastructure

**syscron_health:** 120/130 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
3. **Queue is leaking** — investigate top check_ids by 24h fire rate.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*