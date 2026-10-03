# Hermes Auditor Verdict — 2026-10-02

**Generated:** 2026-10-02T14:00:02.889582+00:00
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

**1. Rate of creation:** 2235 in last 24h vs 7d baseline 1083.7 ± 427.3 (z=+2.7, HIGH)

**2. Rate of resolution:** 2236 in last 24h

**3. Net debt:** -1 (created - resolved). Queue draining.

**4. Top-3 runaways (>25% of 24h volume):** D06 (715), D23 (715), D32 (715)

**5. Starved real-signals (open warning+ >24h):**
  - #110300 (warning, D10): T1-exhausted: D10 same-body ×5075
  - #110301 (warning, D55): T1-exhausted: D55 same-body ×11608

## Open queue snapshot

**Total open:** 7
  - critical: 3
  - warning: 4

## Infrastructure

**syscron_health:** 129/138 ok

## Recommended next session focus

1. **Fix syscron_health errors first** — they block trust in all other signals.
2. **Quarantine the runaway** — single check_id is producing >25% of volume.
4. **Volume above threshold** — escalations creating faster than baseline.

---

*Auditor daily cron — W3.4. Source: /home/openclawops/.hermes/scripts/auditor_daily.py*