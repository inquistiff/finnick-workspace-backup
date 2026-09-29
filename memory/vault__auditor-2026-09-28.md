# Hermes Auditor Verdict — 2026-09-28

**Generated:** 2026-09-28T14:00:02.467450+00:00
**Verdict:** 🟡 NOT HEALTHY (criteria failing below)

## Operational health criteria

| Criterion | Status |
|---|---|
| ≤25 created/24h | ❌ |
| no runaway >25% | ❌ |
| syscron 100% ok | ❌ |
| net debt ≤0 | ❌ |
| no starved real-signals >7d | ❌ |

## The 5-bucket

**1. Rate of creation:** 324 in last 24h vs 7d baseline 1243.4 ± 440.2 (z=-2.1, LOW)

**2. Rate of resolution:** 322 in last 24h

**3. Net debt:** +2 (created - resolved). Queue growing.

**4. Top-3 runaways (>25% of 24h volume):** D23 (150), D06 (149)

**5. Starved real-signals (open warning+ >24h):**
  - #106279 (warning, D10): T1-exhausted: D10 same-body ×17
  - #108709 (warning, D55): T1-exhausted: D55 same-body ×10940

## Open queue snapshot

**Total open:** 5
  - critical: 2
  - warning: 3

## Infrastructure

**syscron_health:** 130/138 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
3. **Queue is leaking** — investigate top check_ids by 24h fire rate.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*