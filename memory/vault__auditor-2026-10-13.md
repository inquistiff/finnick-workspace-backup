# Hermes Auditor Verdict — 2026-10-13

**Generated:** 2026-10-13T14:00:02.653349+00:00
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

**1. Rate of creation:** 2036 in last 24h vs 7d baseline 2470.6 ± 1208.1 (z=-0.4, OK)

**2. Rate of resolution:** 2036 in last 24h

**3. Net debt:** +0 (created - resolved). Steady.

**4. Top-3 runaways (>25% of 24h volume):** none

**5. Starved real-signals (open warning+ >24h):**
  - #136710 (warning, D08): T1-exhausted: D08 same-body ×5834
  - #140806 (warning, D42): T1-exhausted: D42 same-body ×10
  - #143174 (warning, D55): T1-exhausted: D55 same-body ×1650

## Open queue snapshot

**Total open:** 10
  - critical: 4
  - warning: 6

## Infrastructure

**syscron_health:** 118/129 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*