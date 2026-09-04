# Hermes Auditor Verdict — 2026-09-03

**Generated:** 2026-09-03T14:00:03.139922+00:00
**Verdict:** 🟡 NOT HEALTHY (criteria failing below)

## Operational health criteria

| Criterion | Status |
|---|---|
| ≤25 created/24h | ❌ |
| no runaway >25% | ❌ |
| syscron 100% ok | ❌ |
| net debt ≤0 | ✅ |
| no starved real-signals >7d | ❌ |

## The 5-bucket

**1. Rate of creation:** 1721 in last 24h vs 7d baseline 1211.6 ± 410.5 (z=+1.2, OK)

**2. Rate of resolution:** 1725 in last 24h

**3. Net debt:** -4 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** D06 (719), D47 (719)

**5. Starved real-signals (open warning+ >24h):**
  - #17614 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #18425 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #19601 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #21230 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #22705 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h

## Open queue snapshot

**Total open:** 135
  - critical: 110
  - warning: 25

## Infrastructure

**syscron_health:** 129/138 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*