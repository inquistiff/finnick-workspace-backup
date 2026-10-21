# Hermes Auditor Verdict — 2026-10-20

**Generated:** 2026-10-20T14:00:02.760224+00:00
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

**1. Rate of creation:** 2065 in last 24h vs 7d baseline 2413.4 ± 888.9 (z=-0.4, OK)

**2. Rate of resolution:** 2058 in last 24h

**3. Net debt:** +7 (created - resolved). Queue growing.

**4. Top-3 runaways (>25% of 24h volume):** none

**5. Starved real-signals (open warning+ >24h):**
  - #145600 (warning, D10): T1-exhausted: D10 same-body ×21621
  - #157944 (warning, D08): T1-exhausted: D08 same-body ×7214

## Open queue snapshot

**Total open:** 19
  - critical: 3
  - info: 1
  - warning: 15

## Infrastructure

**syscron_health:** 114/129 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
3. **Queue is leaking** — investigate top check_ids by 24h fire rate.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*