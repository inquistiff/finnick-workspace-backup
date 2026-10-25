# Hermes Auditor Verdict — 2026-10-24

**Generated:** 2026-10-24T14:00:04.934224+00:00
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

**1. Rate of creation:** 204 in last 24h vs 7d baseline 1349.9 ± 1036.8 (z=-1.1, OK)

**2. Rate of resolution:** 207 in last 24h

**3. Net debt:** -3 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** none

**5. Starved real-signals (open warning+ >24h):**
  - #145600 (warning, D10): T1-exhausted: D10 same-body ×21621
  - #157944 (warning, D08): T1-exhausted: D08 same-body ×7214
  - #164287 (warning, D42): T1-exhausted: D42 same-body ×4392
  - #164376 (warning, D55): T1-exhausted: D55 same-body ×3056
  - #166105 (warning, D47): D-Check D47: Disk Usage (/home, /opt)

## Open queue snapshot

**Total open:** 23
  - critical: 5
  - info: 1
  - warning: 17

## Infrastructure

**syscron_health:** 113/129 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*