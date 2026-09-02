# Hermes Auditor Verdict — 2026-09-01

**Generated:** 2026-09-01T14:00:03.571937+00:00
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

**1. Rate of creation:** 1692 in last 24h vs 7d baseline 1170.4 ± 531.4 (z=+1.0, OK)

**2. Rate of resolution:** 1689 in last 24h

**3. Net debt:** +3 (created - resolved). Queue growing.

**4. Top-3 runaways (>25% of 24h volume):** D47 (705), D06 (703)

**5. Starved real-signals (open warning+ >24h):**
  - #17614 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #18425 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #19601 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #21230 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #22705 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h

## Open queue snapshot

**Total open:** 131
  - critical: 104
  - warning: 27

## Infrastructure

**syscron_health:** 128/138 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
3. **Queue is leaking** — investigate top check_ids by 24h fire rate.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*