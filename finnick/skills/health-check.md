# Skill: Health Check & Energy Management

## Purpose
Read Tiffany's health data (Oura Ring, and EightSleep when available) and use it to make intelligent scheduling decisions. Tiffany has fibromyalgia, nerve damage, hip pain, insomnia, ASD, and ADHD — energy management isn't optional, it's infrastructure.

## Trigger
- Part of daily briefing (automatic)
- Tiffany asks "how am I doing?" or "energy check"
- Before scheduling deep work blocks
- When Tiffany says she's having a rough day (override to low-energy mode)

## Inputs
1. **Oura Ring** — sleep score, readiness score, HRV, resting heart rate, body temperature deviation, sleep stages
2. **EightSleep Pod 5** (when available) — sleep tracking, temperature preferences
3. **Recent patterns** — last 7 days of scores from memory logs
4. **Calendar** — what's scheduled today

## Energy Classification

### High Energy (Readiness 85+, Sleep 80+)
- Schedule deep work: complex writing, strategic planning, platform architecture
- Allow up to 6 hours of focused work
- Good day for meetings that require high engagement
- Can handle tight deadlines without spiking anxiety

### Moderate Energy (Readiness 65-84, Sleep 60-79)
- Mix of focused and light tasks
- Limit deep work to 2-3 hours max
- Batch admin tasks together
- Protect afternoon for rest if sleep was under 70

### Low Energy (Readiness below 65, Sleep below 60)
- Light tasks only: reviews, approvals, simple comms
- Move any non-urgent deadlines
- No new deep work assignments
- Suggest: rest, gentle movement, decompress time
- Auto-reschedule anything that can wait

### Override: Tiffany Says She's Struggling
- Regardless of Oura data, drop to Low Energy protocol
- Clear non-essential tasks for the day
- Only surface truly urgent items
- Check in later (don't hover)

## Trend Monitoring
Track 7-day rolling averages. Flag if:
- Sleep score trending down 3+ days in a row
- HRV dropping consistently (stress signal)
- Readiness below 65 for 2+ consecutive days
- Body temp deviation sustained (potential flare indicator for fibro)

When flagged: "Hey — your numbers have been trending down for [N] days. Might be worth protecting tomorrow too. Want me to lighten the load?"

## Process
1. Pull latest Oura data
2. Compare to 7-day trend
3. Classify today's energy level
4. Adjust task recommendations accordingly
5. Log to daily memory: date, scores, classification, any flags

## Output
Short and factual — not a medical report.
```
ENERGY: Moderate
Sleep: 72 | Readiness: 78 | HRV: 42ms
Trend: Stable (7-day avg readiness: 76)
Recommendation: Good for 2-3h focused work. Protect afternoon.
```

## Constraints
- Never diagnose or play doctor
- Never guilt Tiffany about low scores
- If Tiffany overrides ("I feel fine, load me up"), respect it but log the override
- Always frame recommendations as options, not orders
- Fibro flares are unpredictable — a good Oura score doesn't guarantee a good day
