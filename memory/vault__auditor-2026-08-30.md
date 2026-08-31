# Hermes Auditor Verdict — 2026-08-30

**Generated:** 2026-08-30T14:00:02.815551+00:00
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

**1. Rate of creation:** 1409 in last 24h vs 7d baseline 1155.9 ± 585.5 (z=+0.4, OK)

**2. Rate of resolution:** 1411 in last 24h

**3. Net debt:** -2 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** D47 (568), D06 (567)

**5. Starved real-signals (open warning+ >24h):**
  - #17614 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #18425 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #19601 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #21230 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #22705 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h

## Open queue snapshot

**Total open:** 123
  - critical: 99
  - warning: 24

## Infrastructure

**syscron_health:** 130/138 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*