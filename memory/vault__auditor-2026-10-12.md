# Hermes Auditor Verdict — 2026-10-12

**Generated:** 2026-10-12T14:00:03.371512+00:00
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

**1. Rate of creation:** 2195 in last 24h vs 7d baseline 2565.9 ± 1055.6 (z=-0.4, OK)

**2. Rate of resolution:** 2196 in last 24h

**3. Net debt:** -1 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** none

**5. Starved real-signals (open warning+ >24h):**
  - #136710 (warning, D08): T1-exhausted: D08 same-body ×5834
  - #140806 (warning, D42): T1-exhausted: D42 same-body ×10

## Open queue snapshot

**Total open:** 9
  - critical: 2
  - warning: 7

## Infrastructure

**syscron_health:** 118/129 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*