# Hermes Auditor Verdict — 2026-10-01

**Generated:** 2026-10-01T14:00:03.424444+00:00
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

**1. Rate of creation:** 1552 in last 24h vs 7d baseline 1074.9 ± 413.3 (z=+1.2, OK)

**2. Rate of resolution:** 1550 in last 24h

**3. Net debt:** +2 (created - resolved). Queue growing.

**4. Top-3 runaways (>25% of 24h volume):** D06 (718), D23 (718)

**5. Starved real-signals (open warning+ >24h):**
  - #110300 (warning, D10): T1-exhausted: D10 same-body ×5075
  - #110301 (warning, D55): T1-exhausted: D55 same-body ×11608

## Open queue snapshot

**Total open:** 8
  - critical: 4
  - warning: 4

## Infrastructure

**syscron_health:** 128/138 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
3. **Queue is leaking** — investigate top check_ids by 24h fire rate.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*