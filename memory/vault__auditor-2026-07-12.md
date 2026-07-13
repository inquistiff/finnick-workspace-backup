# Hermes Auditor Verdict — 2026-07-12

**Generated:** 2026-07-12T14:00:01.827054+00:00
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

**1. Rate of creation:** 1151 in last 24h vs 7d baseline 1099.3 ± 553.0 (z=+0.1, OK)

**2. Rate of resolution:** 1152 in last 24h

**3. Net debt:** -1 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** D27 (547), D06 (546)

**5. Starved real-signals (open warning+ >24h):**
  - #6614 (warning, D-PWG-REFUSED): D-PWG-REFUSED: prod-write-gate.sh refusal/partial-release th
  - #6616 (warning, ?): PR_FILING_BLOCKED_0005
  - #6617 (warning, ?): PR_FILING_BLOCKED_0003
  - #6686 (warning, D04): D-Check D04: Error Rate
  - #6687 (warning, D36): D-Check D36: Experiment Pipeline

## Open queue snapshot

**Total open:** 52
  - critical: 22
  - warning: 30

## Infrastructure

**syscron_health:** 128/137 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*