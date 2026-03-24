# HEARTBEAT TASKS

> Reference: [[system/heartbeat-vs-cron]]
- Before running a script/command, confirm it hasn’t already run today (check the cache timestamps first).

## Cadence & Token Budget
- **Run each heartbeat block once per day.** Subsequent prompts in the same window should get `HEARTBEAT_OK` unless something new appears.
  - Morning window: 06:00–09:00 ET
  - Midday window: 12:00–14:00 ET
  - Evening window: 18:00–21:00 ET
- Default to cached data when possible; only re-run a command if the last run is >2 h old or there’s a clear change signal.

## Morning Heartbeat
- Email inbox sweep (priority mail only)
- Calendar delta (next 48 h)
- Weather/travel alerts (Knoxville or current location)
- Oura snapshot + interpretation (`refresh_oura_snapshot.sh` + `interpret_oura.sh`)

## Midday Heartbeat
- Email inbox sweep
- Calendar delta
- Fireflies transcript pull (`make fireflies`) if meetings occurred
- Social/communication mentions (Slack/Telegram/etc.)

## Evening Heartbeat
- Email inbox sweep
- Calendar delta
- Weather/travel alerts for tomorrow
- Automation health check (`make audit` if it hasn’t run in 24 h)
- Social/communication mentions (Slack/Telegram/etc.)

## CLI Output Guardrails
- Filter API/CLI output with `jq`/Python before printing (only keep the fields we need).
- Cache raw responses to disk and reference the file path instead of re-dumping data.
- Avoid rerunning noisy commands unless new data is required; rely on cached results when possible.
