# Hermes Auditor Verdict — 2026-10-15

**Generated:** 2026-10-15T14:00:03.450056+00:00
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

**1. Rate of creation:** 3150 in last 24h vs 7d baseline 2167.0 ± 457.9 (z=+2.1, HIGH)

**2. Rate of resolution:** 3147 in last 24h

**3. Net debt:** +3 (created - resolved). Queue growing.

**4. Top-3 runaways (>25% of 24h volume):** none

**5. Starved real-signals (open warning+ >24h):**
  - #136710 (warning, D08): T1-exhausted: D08 same-body ×5834
  - #140806 (warning, D42): T1-exhausted: D42 same-body ×10
  - #143174 (warning, D55): T1-exhausted: D55 same-body ×1650
  - #145600 (warning, D10): T1-exhausted: D10 same-body ×21621

## Open queue snapshot

**Total open:** 11
  - critical: 2
  - warning: 9

## Infrastructure

**syscron_health:** 118/129 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
3. **Queue is leaking** — investigate top check_ids by 24h fire rate.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*