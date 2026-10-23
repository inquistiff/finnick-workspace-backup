# Hermes Auditor Verdict — 2026-10-22

**Generated:** 2026-10-22T14:00:04.027772+00:00
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

**1. Rate of creation:** 277 in last 24h vs 7d baseline 2138.4 ± 764.7 (z=-2.4, LOW)

**2. Rate of resolution:** 282 in last 24h

**3. Net debt:** -5 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** none

**5. Starved real-signals (open warning+ >24h):**
  - #145600 (warning, D10): T1-exhausted: D10 same-body ×21621
  - #157944 (warning, D08): T1-exhausted: D08 same-body ×7214
  - #164287 (warning, D42): T1-exhausted: D42 same-body ×4392
  - #164376 (warning, D55): T1-exhausted: D55 same-body ×3056
  - #166105 (warning, D47): D-Check D47: Disk Usage (/home, /opt)

## Open queue snapshot

**Total open:** 16
  - critical: 4
  - warning: 12

## Infrastructure

**syscron_health:** 120/129 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*