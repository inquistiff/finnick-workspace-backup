# Hermes Auditor Verdict — 2026-08-25

**Generated:** 2026-08-25T14:00:02.129201+00:00
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

**1. Rate of creation:** 1511 in last 24h vs 7d baseline 990.9 ± 484.1 (z=+1.1, OK)

**2. Rate of resolution:** 1511 in last 24h

**3. Net debt:** +0 (created - resolved). Steady.

**4. Top-3 runaways (>25% of 24h volume):** D06 (719), D47 (718)

**5. Starved real-signals (open warning+ >24h):**
  - #6693 (warning, D55): D-Check D55: Google Token Health
  - #6694 (warning, D-PWG-REFUSED): D-PWG-REFUSED: prod-write-gate.sh refusal/partial-release th
  - #17614 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #18425 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h
  - #19601 (critical, D10): self_healer-STUCK: D10 non-recovering for 24.0h

## Open queue snapshot

**Total open:** 99
  - critical: 90
  - warning: 9

## Infrastructure

**syscron_health:** 130/138 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*