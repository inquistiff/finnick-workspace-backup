# Hermes Auditor Verdict — 2026-10-23

**Generated:** 2026-10-23T14:00:03.776192+00:00
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

**1. Rate of creation:** 193 in last 24h vs 7d baseline 1728.4 ± 912.9 (z=-1.7, OK)

**2. Rate of resolution:** 182 in last 24h

**3. Net debt:** +11 (created - resolved). Queue growing.

**4. Top-3 runaways (>25% of 24h volume):** WATCHDOG-CPU (53)

**5. Starved real-signals (open warning+ >24h):**
  - #145600 (warning, D10): T1-exhausted: D10 same-body ×21621
  - #157944 (warning, D08): T1-exhausted: D08 same-body ×7214
  - #164287 (warning, D42): T1-exhausted: D42 same-body ×4392
  - #164376 (warning, D55): T1-exhausted: D55 same-body ×3056
  - #166105 (warning, D47): D-Check D47: Disk Usage (/home, /opt)

## Open queue snapshot

**Total open:** 27
  - critical: 4
  - info: 2
  - warning: 21

## Infrastructure

**syscron_health:** 120/129 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
3. **Queue is leaking** — investigate top check_ids by 24h fire rate.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*