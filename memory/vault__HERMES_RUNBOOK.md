<!-- owner: Tiffany last-verified: 2026-05-08 -->

# Hermes / Finnick Runbook

**Purpose:** the canonical service inventory, config map, secret map, network map, and recovery procedures for finnick-prod. The "what is" of the live system.

**This is REFERENCE only.** For:
- *Why* it's structured this way → [ARCHITECTURE.md](ARCHITECTURE.md) + [decisions/](decisions/)
- *How* to perform a procedure → [playbooks/](playbooks/)
- *History* of changes → [CHANGELOG.md](CHANGELOG.md)
- *Vocabulary* (D33, F1, etc.) → [GLOSSARY.md](GLOSSARY.md)

**Editing:** run `/runbook-update` first. See [CONTRIBUTING.md](CONTRIBUTING.md). Never add "additions" sub-headers — append to the canonical section.

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 1. Quick reference — connect

| Resource | How |
|---|---|
| SSH (ops user) | `ssh openclawops@100.85.9.1` (Tailscale) — preferred |
| SSH (public) | `ssh openclawops@64.91.248.32` — Liquid Web public IP, fallback |
| SSH (root) | password disabled — use `openclawops` + `sudo` |
| VPS provider | Liquid Web Cloud VPS, account #376330, Lansing MI |
| Hostname | `finnick-prod` |
| Spec | 12.6 GB RAM / 4 vCPU / 240 GB disk / Ubuntu 24.04 |
| Monthly bill | $56/mo (Liquid Web auto-pay on 22nd) |
| **Life Dash UI** | `http://100.85.9.1/life-dash.html` (Tailscale-only). Root tab `#overview`. |
| **Cron browser** | `http://100.85.9.1/life-dash.html#crons` — canonical UI for all 47 crons. Don't grep `jobs.json` by hand. |
| **Outputs / quality** | `http://100.85.9.1/life-dash.html#outputs` — E16 quality scores + Langfuse cost dashboards. |
| **Langfuse UI** | `https://langfuse.finnick.xyz` (CF Access email-OTP for `tiffanydgerman@me.com`). Internal: `http://127.0.0.1:3000`. |

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 2. Service inventory

Listed in **boot order** — see [§ 6](#6-boot-order-after-reboot). Whenever you add, move, rename, or change the launch mechanism of a service, update this section in the same commit. **Never** add an "additions" sub-header — append to the right tier.

### Tier 0 — Infrastructure

| Service | Where | Launched by | Purpose | Port |
|---|---|---|---|---|
| Tailscale | host | systemd `tailscaled.service` | private mesh network (100.85.9.1 in tailnet) | n/a |
| Caddy | host | systemd `caddy.service` | HTTPS reverse proxy / ACME for Life Dash | 80, 443 |
| UFW firewall | host | systemd `ufw.service` | default DENY incoming, ALLOW tailscale + 80/443/22-on-tailscale | n/a |
| systemd-resolved | host | systemd | local DNS resolver | 53 (loopback) |

### Tier 1 — Datastores

| Service | Where | Launched by | Purpose | Port |
|---|---|---|---|---|
| `pe-postgres` | docker container | `/opt/openclaw/docker-compose.yml` | Engine 19 + Phase E bandit Postgres | 127.0.0.1:5434 |
| `litellm-postgres` | docker container wrapped in systemd | `litellm-postgres.service` (Type=oneshot + RemainAfterExit, runs `docker start litellm-postgres`) | LiteLLM internal Prisma DB — spend tracking, virtual keys | 127.0.0.1:5433 |
| `state.db` | host (sqlite) | hermes-cli + mc_api + self_healer | single sqlite file holding most operational tables — see "state.db tables" below | file: `/home/openclawops/.hermes/state.db` |
| `debug_runs.db` | host (sqlite) | self_healer + mc_api debug/run-all | debug check raw run history (large — periodic vacuum candidate) | file: `/home/openclawops/.hermes/debug_runs.db` |

**state.db tables:** `debug_baselines`, `debug_fix_effectiveness_per_check`, `debug_fix_method_versions`, `debug_kv`, `debug_performance`, `debug_resolutions`, `debug_root_cause_log`, `debug_runs`, `escalation_events`, `escalation_queue`, `learning_escalations`, `fix_attempts` (primary self-healer audit log; columns: `id, attempted_at, check_id, fix_kind, pre_status, fix_applied_response, fix_method, observations, verified_ok, final_status, settle_time_s, caller_source, marker, fix_method_version, who_json, what_json, when_json, where_json, why_candidates_json, how_signature, prior_instance_ids, error_class`). `debug_performance` and `debug_baselines` are tables inside state.db, not separate files.

**Self-healer fix-method registry:**
- `RECOVERY_ACTIONS` dict in `services/debug_checks.py` (~line 5096) maps `check_id → {kind, action, command, auto_safe, reversible}`. NOT `FIX_COMMANDS`.
- P7 checks (D-LOCK, D-MCRESTART, D-LATENCY, D-CAPSKIP) are programmatically registered via `register_p7_checks(...)` (~line 6251).
- `debug_fix_method_versions` tracks fix-method evolution per `(check_id, version)`. INSERT a new row when retiring a fix-method.
- `debug_root_cause_log` columns: `id, check_id, kind, diagnostic_ts, findings, routed_to, status, resolved_at, resolution_notes`. Doctrine §III canonical INSERT: `INSERT INTO debug_root_cause_log (check_id, kind, findings) VALUES ('Dxx', 'fix_failure', 'reason=... evidence=...')`. Use plain `'` apostrophes — `\\'` will fail to parse.
- Always redirect sqlite3 stderr to `2>>/var/log/finnick/self-heal.log`, NOT `2>/dev/null` (swallows schema-drift errors silently).
- Apostrophe-safe SQL: `_VAR_ESC=$(echo "$_VAR" | sed "s/'/''/g")` then `'$_VAR_ESC'` in SQL.
- Self-healer is fresh-process per `*/2 * * * *` cron — fix-method `command` edits land on next cycle without restart.
- **mc_api is a long-running daemon — meta-tuple / check-name / category / `command` string changes in `debug_checks.py` require `sudo systemctl restart hermes-mc-api`** to land in `/debug/checks/{id}` API responses + the apply-fix endpoint. Restart is fast (~6s).
- **`debug_root_cause_log` retention policy** runs daily 03:30 ET via `/home/openclawops/.hermes/scripts/debug_root_cause_log_retention.sh` (openclawops crontab). Deletes (a) `kind='diagnose'` rows >7d, (b) `status IN ('resolved','closed')` rows >30d. Preserves all open non-diagnose rows. Log: `/var/log/finnick/retention.log`.

### Tier 2 — LLM gateway + observability

| Service | Where | Launched by | Purpose | Port |
|---|---|---|---|---|
| `litellm` | docker container | `/opt/openclaw/docker-compose.yml` | OpenAI-compatible LLM proxy, 45 routes / 37 model_name entries, F1 free-only fallback chains | 127.0.0.1:4000 |
| Langfuse stack (6 containers) | docker | `/opt/langfuse/docker-compose.yml` (+ override) | LLM observability: traces, costs, scores, dashboards | 127.0.0.1:3000 (web), 8123 (clickhouse-http), 5432 (lf-postgres), 6379 (redis), 9090 (minio) |

### Tier 3 — Hermes core

| Service | Where | Launched by | Purpose | Port |
|---|---|---|---|---|
| `hermes-mc-api.service` | systemd | `/etc/systemd/system/hermes-mc-api.service`; `sudo systemctl restart hermes-mc-api` | Mission Control / Life Dash backend; uvicorn `mc_api:app`. Hosts `/langfuse/*` proxy router. Logs `/var/log/finnick/mc-api.log`. | 127.0.0.1:7722 |
| `hermes-gateway.service` | systemd | systemd | hermes-cli daemon — receives MCP requests | 127.0.0.1:8019 (uvicorn) |
| `mission-control-api.service` | systemd | runs `python3 /opt/openclaw/mission-control/file-api.py` as **root** | mc_api's file/preview backend | 127.0.0.1:8091 |
| `finnick-ai-rater.service` | systemd | runs `ai_qa_rater.py --loop` as openclawops | E16 quality scoring loop; POSTs scores to Langfuse via `cron_runs.langfuse_trace_id` | n/a (writes to state.db + Langfuse) |
| `escalation-bridge.service` | systemd | runs `escalation_bridge_mcp.py 9100` as openclawops | MCP server for L3 / Cowork queue ops | 127.0.0.1:9100 ⚠️ verify UFW Tailscale-only |
| `hermes-engine19.service` | systemd | uvicorn `app:app` from `/opt/openclaw/engine19` | E19 prompt engineering engine (shadow_compare, auto-promote) | 127.0.0.1:8019 — ⚠️ port collision risk with hermes-gateway; verify with `ss -ltnp \| grep 8019` |
| `finnick-comms-webhook.service` | systemd | python `finnick_comms_webhook.py` from hermes venv | E29 SignalWire inbound voice/SMS/voicemail receiver | 0.0.0.0:7723 (public, behind CF tunnel) |
| `finnick-comms-tunnel.service` | systemd | `cloudflared --config ~/.cloudflared/config.yml tunnel run finnick-comms` | Cloudflared tunnel for `*.finnick.xyz` (Langfuse + finnick-comms-webhook) | 127.0.0.1:20242 (cf metrics) |
| `hermes-gig-webhook.service` | systemd | `python3 ~/.hermes/scripts/gig_webhook.py` | E9 Gig webhook receiver | 127.0.0.1:7100 |
| `hermes-cloudflared.service` | systemd | `~/.hermes/scripts/start_webhook_tunnel.sh` | Cloudflared QUICK tunnel for gig-webhook (separate from finnick-comms-tunnel) | 127.0.0.1:20241 (cf metrics) |
| `experiment-lifecycle.service` | systemd (oneshot) | `python3 /opt/openclaw/mission-control/experiment_lifecycle.py` | E24 experiment lifecycle batch run | n/a (writes to state.db) |

### Tier 4 — Coordination / routing (cold)

| Service | Where | Launched by | Status |
|---|---|---|---|
| `hermes-conductor.service` | systemd | systemd | **inactive + DISABLED** per F10 cold-state. Was the bandit router on :8020. Re-enable: `sudo systemctl enable --now hermes-conductor`. See [decisions/0007-conductor-cold-state-f10.md](decisions/0007-conductor-cold-state-f10.md). |
| `d01_phase_e_snapshot.service` | systemd (oneshot) | systemd | **failing** by design — depends on running conductor. See [§ 8.4](#84-tier-4-known-failing-unit-monitor-not-fix). |

### Tier 5 — Schedulers + crons

| Service | Where | Launched by | Status |
|---|---|---|---|
| Hermes scheduler (47 LLM-bearing crons) | host | hermes-cli, defined in `/home/openclawops/.hermes/cron/jobs.json` (top-level key is `jobs`, NOT `crons`) | **44/47 disabled, 3 meeting-intel intentionally live**. Live: `5a8469445fae`, `03444172d11b`, `748ed111bda9` — all on `groq/llama-3.3-70b-versatile`. Other 44 follow `STAGED_CRON_REENABLE_PROTOCOL.md`. SIGHUP `pgrep -f hermes_cli.main` to reload jobs.json. |
| `self_healer.py` | user crontab `*/2 * * * *` | `cd /opt/openclaw/mission-control/phase5-backend/services && BACKLOG_ENABLED=true BACKLOG_HOURS=24 /usr/bin/python3 self_healer.py >> /var/log/finnick/self-heal.log 2>&1` | runs M1/M3/M4/M5/M8/M9/M10; tracker at `/home/openclawops/.hermes/mission-control/self-heal-tracker.json`; M9 hygiene daily 03:00 via `curl POST /debug/hygiene/run` |
| openclawops crontab | host | `crontab -l` as openclawops | Mission-Control batch scripts (every 5-15 min: `health_score_cache.py`, `telemetry_collector.py`, `cron_run_sweep.py`, `classify_pending_batch.py`, `held_auto_sweep.py`, `scope_*.py`, `oura_sample_pull.py`); Hermes scripts (`process_watchdog.py`, `cron-alert-monitor.py`, `inbox_unsubscribe_scanner.py`, `meds-pm.sh`); security crons under `/opt/hermes/security-crons/` (tier1-infra, tier2-rotation, tier3-agent); `clickup_task_sync.py` */15; `clickup_hygiene.py` weekly Sunday 8pm; `pg_backup.sh` daily 3am |
| root crontab | host | `sudo crontab -l` | `finnick-backup.sh` 02:00, `finnick-statedb-backup.sh` 02:00, `life-dash-backup.sh` 02:15, `finnick-hermes-backup.sh` 02:30, `finnick-gdrive-backup.sh` 03:00, `finnick-memory-ingest.sh` 22:30, `finnick-memory-maintenance.sh` 23:00, `deploy_audit_forensic_rotate.sh` 00:05, `e20-auto-ramp.sh` */30 (no-op in cold state) |
| Cowork scheduled tasks | Cowork (laptop-side) | scheduled-task system | `escalation-root-cause-fixer` every 8h; `casa-garnet-weekly-canary` Sunday 00:08 ET; `system-bible-drift-audit` daily 02:00 ET; `phase-e-7day-followup-2026-05-14` one-time |

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 3. Config file map

For every config: who owns it, what consumes it, what triggers reload.

| File | Owner | Mode | Consumed by | How to reload |
|---|---|---|---|---|
| `/opt/openclaw/docker-compose.yml` | root | 644 | docker compose | `cd /opt/openclaw && sudo docker compose up -d --force-recreate <service>` |
| `/opt/openclaw/.env` | openclawops | 600 | docker compose (default `.env`) | container recreate to pick up changes |
| `/opt/openclaw/litellm-config.yaml` | root | 644 | LiteLLM container (mounted at `/app/config.yaml`) | `sudo docker restart litellm` (mount is live) — **parse-check first** per [playbooks/litellm-config-edit.md](playbooks/litellm-config-edit.md) |
| `/opt/openclaw/litellm_hooks/` | openclawops | dir | LiteLLM custom callbacks (`tpd_gate`, `error_logger`, `task_type_enricher`, `cron_tag_emitter`) | `sudo docker restart litellm` |
| `/home/openclawops/.hermes/cron/jobs.json` | openclawops | 644 | hermes scheduler | `kill -HUP $(pgrep -f hermes_cli.main)` (SIGHUP reload) |
| `/home/openclawops/.hermes/.env` | openclawops | 600 | hermes-cli + scheduler | `sudo systemctl restart hermes-gateway` |
| `/etc/systemd/system/hermes-gateway.service` | root | 644 | systemd | `sudo systemctl daemon-reload && sudo systemctl restart hermes-gateway` |
| `/etc/systemd/system/hermes-conductor.service` | root | 644 | systemd | `sudo systemctl daemon-reload && sudo systemctl restart hermes-conductor` |
| `/opt/langfuse/docker-compose.yml` | openclawops | 644 | docker compose | `cd /opt/langfuse && sudo docker compose up -d` |
| `/opt/langfuse/docker-compose.override.yml` | openclawops | 644 | docker compose (memory limits) | same as above |
| `/opt/langfuse/.env` | openclawops | 600 | docker compose | container recreate |
| `/opt/openclaw/mission-control/dash/v5/tabs/architecture.js` | root | 644 | mc_api → Life Dash UI (26-engine map) | reload Life Dash page in browser |

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 4. Secrets map

All secrets live ONLY in these files. Do NOT hardcode in compose / code.

| File | Mode | Owner | Contains |
|---|---|---|---|
| `/home/openclawops/.hermes/secrets/eightsleep.env` | 600 | openclawops | EightSleep API token |
| `/home/openclawops/.hermes/secrets/pe-postgres.env` | 600 | openclawops | Phase E Postgres DSN |
| `/home/openclawops/.hermes/secrets/langfuse.env` | 600 | openclawops | Langfuse public/secret key, host URL, admin user/pass |
| `/opt/openclaw/.env` | 600 | openclawops | `LITELLM_MASTER_KEY` + provider API keys (Anthropic, OpenRouter, Groq, Gemini, DeepSeek, Cerebras, Mistral, OpenAI) + Langfuse keys (`LANGFUSE_HOST=http://host.docker.internal:3000` for the litellm container) |
| `/opt/langfuse/.env` | 600 | openclawops | Langfuse internal (Postgres pw, ClickHouse pw, encryption key, salt, admin pw, project keys) |
| `/home/openclawops/.hermes/.env` | 600 | openclawops | hermes-cli env (Telegram tokens, etc.) |

**Rotation rule:** if a secret is exposed (chat, log, screenshot), it's compromised. Rotate immediately or document the compromise + acceptable-risk justification. Don't pretend it didn't happen.

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 5. Network map

```
                    Internet
                       │
              ┌────────┴────────┐
              │ UFW (default DENY incoming)        │
              │ ALLOW: 22/tailscale0, 80, 443      │
              └────────┬────────┘
                       │
                  finnick-prod (Liquid Web)
                       │
   ┌───────────────────┼───────────────────┐
   │                   │                   │
   │   Caddy :443  ───▶  Life Dash UI       │
   │   Caddy :80   ───▶  ACME challenge     │
   │   Tailscale :22 ───▶ ssh (you)         │
   │   Cloudflared (finnick-comms) ───▶     │
   │     · langfuse.finnick.xyz             │
   │     · finnick-comms-webhook (:7723)    │
   │   Cloudflared (gig-webhook quick)      │
   │     · gig-webhook (:7100)              │
   │                                       │
   └───────────────────────────────────────┘

Internal (127.0.0.1 only):
  4000  litellm proxy
  7100  hermes-gig-webhook receiver
  7722  mc_api
  8019  hermes-gateway uvicorn / hermes-engine19 ⚠️ collision
  8020  hermes-conductor (cold)
  8091  file-api (mission-control-api)
  3000  langfuse-web
  8123  langfuse clickhouse http
  9000  langfuse clickhouse tcp / minio internal
  6379  langfuse redis
  5432  langfuse postgres
  5433  litellm-postgres
  5434  pe-postgres
  9091  langfuse minio console
  2019  caddy admin API
  20241 hermes-cloudflared metrics
  20242 finnick-comms-tunnel metrics

Public-bound (0.0.0.0) — verify UFW drops at perimeter:
  7723  finnick-comms-webhook (intentional — CF tunnel ingress)
  9090  langfuse-minio host port → container :9000
  9100  escalation-bridge MCP ⚠️ verify Tailscale-only ACL
```

**Inter-container** (docker bridge):
- `litellm` → `langfuse-web` via `host.docker.internal:3000` (extra_hosts: host-gateway)
- `litellm` → `litellm-postgres` via Docker default bridge container name resolution
- Langfuse stack containers communicate via the `langfuse_default` bridge network

**Public-port audit:** ports `7723`, `9090`, `9100` are bound to `0.0.0.0` per `ss -ltn`. Confirm UFW deny rules at the public interface: `sudo ufw status verbose`.

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 6. Boot order after reboot

After Liquid Web migrations / planned or unexpected reboots, services come back in this order. **Manually verify each before moving on.** Full procedure in [playbooks/reboot-recovery.md](playbooks/reboot-recovery.md).

| Order | What | Verify with |
|---|---|---|
| 1 | Tailscale | `ssh openclawops@100.85.9.1` works |
| 2 | UFW + caddy | `sudo ufw status`; `systemctl is-active caddy` |
| 3 | docker daemon | `sudo systemctl is-active docker` |
| 4 | `pe-postgres` (compose, auto-up) | `sudo docker ps --filter name=pe-postgres` |
| 5 | `litellm-postgres` (systemd-managed) | `systemctl is-active litellm-postgres && docker ps --filter name=litellm-postgres` |
| 6 | `litellm` (compose, depends on 5) | `sudo docker logs litellm \| grep "Application startup complete"` |
| 7 | Langfuse stack | `cd /opt/langfuse && sudo docker compose ps` — all 6 healthy |
| 8 | `hermes-gateway.service` | `systemctl is-active hermes-gateway` |
| 9 | `hermes-mc-api.service` | `systemctl is-active hermes-mc-api && curl http://127.0.0.1:7722/health` |
| 10 | `mission-control-api.service` | `systemctl is-active mission-control-api && curl http://127.0.0.1:8091/health` |
| 11 | `finnick-ai-rater.service` | `systemctl is-active finnick-ai-rater` |
| 12 | `escalation-bridge.service` | `systemctl is-active escalation-bridge` |
| 13 | `hermes-conductor` | **DELIBERATELY DOWN** per F10. Do not auto-start. |
| 14 | `escalation-root-cause-fixer` scheduled task | scheduled task list shows enabled |
| 15 | hermes scheduler (47 crons) | **DELIBERATELY DOWN** per cold-state. Do not auto-start. |
| 16 | `self_healer.py` user crontab | `tail /var/log/finnick/self-heal.log` shows recent "Cycle complete" lines (~every 2 min) |

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 7. Spend tracking — required state

Spend must be queryable per-cron, per-task_type, per-model. Two parallel sources of truth (intentional — see [decisions/0002-langfuse-self-hosted.md](decisions/0002-langfuse-self-hosted.md) for why both):

**Required for spend tracking to work:**
1. `litellm-postgres` container UP (auto-started by `litellm-postgres.service` on boot)
2. LiteLLM proxy UP and connected to litellm-postgres (Prisma migrations succeed)
3. Langfuse stack UP and reachable from litellm container at `host.docker.internal:3000`
4. `/opt/openclaw/.env` has `LANGFUSE_PUBLIC_KEY`, `LANGFUSE_SECRET_KEY`, `LANGFUSE_HOST=http://host.docker.internal:3000`
5. `/opt/openclaw/litellm-config.yaml` has `success_callback: ["langfuse"]` and `failure_callback: ["langfuse"]` under `litellm_settings:`
6. Crons inject metadata via `_inject_request_metadata` in `scheduler.py` — adds `cron_id`, `task_type`, `workload_class`, `cost_estimated` to body.metadata of every LiteLLM call

**Failure modes:**
- `litellm-postgres` not running → LiteLLM logs `P1001` Prisma errors, `/spend/logs` returns empty, virtual keys break
- Langfuse stack down → success_callback fires but trace creation fails; LiteLLM logs Langfuse errors but does NOT block requests (graceful)
- crons not passing metadata → traces appear in Langfuse without cron_id/task_type → cost-by-cron rollup broken
- Inconsistent metadata across runs → expected; per-call attribution is the source of truth, not per-cron rollup

**Life Dash → Langfuse path:** browser NEVER talks directly to Langfuse. All flows through mc_api `/langfuse/*` proxy router (`/opt/openclaw/mission-control/phase5-backend/routers/langfuse.py`). Keys read from `/home/openclawops/.hermes/secrets/langfuse.env`. Architecture diagram in [ARCHITECTURE.md § Spend tracking](ARCHITECTURE.md#spend-tracking).

**Gotcha — host config split:** `/opt/openclaw/.env` has `LANGFUSE_HOST=http://host.docker.internal:3000` (correct for the LiteLLM container). The mc_api process runs on the host and must NOT inherit that — it reads `LANGFUSE_HOST=http://127.0.0.1:3000` from `secrets/langfuse.env`. The router code defends with: read secrets file first, fall back to env, strip `host.docker.internal` if it leaked through.

**SRE lever — Langfuse killswitch:** see [playbooks/langfuse-killswitch.md](playbooks/langfuse-killswitch.md) when the LiteLLM → Langfuse callback needs to be disabled fast.

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 8. Operating notes by tier

### 8.1 Cold-state subsystems (registry)

When a subsystem is intentionally off, every check that depends on it should KNOW (not independently rediscover). Architecture rationale in [ARCHITECTURE.md § Cold-state](ARCHITECTURE.md#cold-state-pattern). Decision history in [decisions/0007-conductor-cold-state-f10.md](decisions/0007-conductor-cold-state-f10.md).

**Table:** `cold_state_registry` in state.db.

**Subsystem vocabulary** (extend cautiously; lock spelling once chosen):
- `litellm-postgres` — LiteLLM internal Prisma DB
- `hermes-conductor` — bandit routing service
- `all-llm-crons` — 44/47 cold; 3 meeting-intel exceptions live by design (5a8469445fae, 03444172d11b, 748ed111bda9). The `reason` field MUST name the live exceptions.

**Helper:** `services/cold_state.py` — `is_cold(subsystem)`, `cold_reason(subsystem)`, `set_cold(...)`, `clear_cold(...)`. Fail-open (errors return False, legacy classification continues).

**Reference implementations:**
- D33: `services/debug_checks.py:2488+` (search `COLD_STATE_AWARE_V1`)
- Cron-side: `de6_tiered_enforce_flipper.py` (search `_llm_crons_cold_state`), `drift_to_experiment_sweep.py` (search `COLD_STATE_AWARE_V1`)

### 8.2 SMART_ESC_V1 escalation contract

Escalations carry structured fields beyond legacy. Field reference + design rationale in [ARCHITECTURE.md § Escalation contract](ARCHITECTURE.md#escalation-contract).

**Fields accepted by `_check()` in `services/debug_checks.py:329`:** `where`, `why` (list), `evidence` (dict), `related` (list), `next_action`. All optional — 220 existing call sites unaffected.

**Renderer:** `_render_escalation_body(result)` in same file. Empty fields skipped.

**Push path:** `debug_checks.py:493`. Body field gets the rendered SMART_ESC body; metadata JSON gets the raw fields for tooling pivot.

**Already upgraded:** D06, D33. **Priority for upgrade:** D04, D58, D-CAPSKIP, D-LATENCY, D08, D43/D44.

### 8.3 LiteLLM config validation — hard rule

Any edit to `/opt/openclaw/litellm-config.yaml` must be parse-checked BEFORE `sudo docker restart litellm`. The container caches its parse on startup; malformed YAML can sit latent for days. Full procedure in [playbooks/litellm-config-edit.md](playbooks/litellm-config-edit.md).

**Tier-1 (fast):** `sudo python3 -c "import yaml; yaml.safe_load(open('/opt/openclaw/litellm-config.yaml'))"`
**Tier-2 (gold-standard):** dry-boot in throwaway container — see playbook.

**Style:** ✅ block-style lists (`success_callback:\n    - langfuse`); ⚠️ flow-style works ONLY with space after colon; ❌ never `success_callback:["langfuse"]` (silent mis-parse).

### 8.4 Tier 4 known-failing unit (monitor, not fix)

`d01_phase_e_snapshot.service` — oneshot intended to capture Phase E flip-readiness snapshots. Currently fails non-zero because `hermes-conductor` is in cold-state. NOT a real incident. Resolution paths:
1. Stop the timer during cold state: `sudo systemctl stop d01_phase_e_snapshot.timer`
2. Add a cold-state guard to `phase_e_snapshot.py` — return 0 if conductor inactive (preferred)

### 8.5 E13 Constraint Detection (Life OS) — corrected 2026-05-08

E13 detects **Tiffany's life constraints** (energy, sleep, pain, capacity, mental load) so E22 review_classifier can suppress queue items when she's at low capacity. **Principle #4: Finnick still EXECUTES every queue item; E13 only changes the REVIEW SURFACE.** Per architecture.js: "flags blockers before they cause failures."

**NOT to be confused with:** LLM-output classifiers, Langfuse-trace consumers, or `review_classifier_runs` (that's E22's H-05 queue-item classifier on stakes/urgency/reversibility — a different thing).

**Detects 10 types across 3 categories:**

| Category | Types |
|---|---|
| **Health (3)** | `ENERGY_LOW` (Oura readiness <60), `SLEEP_DEBT` (sleep score <65 OR <5h), `PAIN_FLARE` (fibro/ulnar nerve indicators) |
| **Capacity (3)** | `TIME_CRUNCH` (<2h free today), `DEADLINE_PRESSURE` (24-72h high-stakes), `CAPACITY_OVERFLOW` (queue exceeds throughput baseline) |
| **Mental (4)** | `COGNITIVE_LOAD`, `DECISION_FATIGUE`, `SOCIAL_BATTERY_DRAIN`, `CONTEXT_SWITCHING` |

**Severity logic** (per type) — CRITICAL / HIGH / MED / LOW with type-specific thresholds. Output includes `evidence` (what triggered it) + `action` (what to do).

**Wires (per architecture.js):**
- **Inbound:** E12 Archetype profile → E13 (`profile → constraints`); E18 Scope Intelligence resolutions → E13
- **Outbound (LAMBO-2A — SHIPPED):** E13 → E22 review_classifier (`constraints → classifier`); E13 → E12 archetype (`state → archetype` feedback)
- **Read path:** `services/review_classifier.py:_fetch_active_constraints()` polls `/constraints/active`, post-LLM-adjusts `class_stakes` / `class_urgency` based on live constraints

**API endpoints (mc_api):**
- `GET /constraints/types` — full 10-type catalogue
- `GET /constraints/active` — currently-firing constraints (cached)
- `GET /constraints/detect` — run detection now

**Life Dash surface:** `optimize.js` constraint dashboard (`renderConstraintsCard()`, added Tier-3 Phase 6) — severity color-coded chips + 10-type catalogue with active-row highlight.

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 9. Common breakage and fixes

| Symptom | Likely cause | Fix |
|---|---|---|
| `LiteLLM Connection reset by peer` on `/v1/chat/completions` | litellm-postgres down → proxy in restart loop | `sudo docker start litellm-postgres && sudo docker restart litellm` |
| `Database migration failed but continuing startup` in litellm logs | litellm-postgres down (proxy serves anyway, degraded) | same as above; spend tracking + virtual-keys broken until fixed |
| `/tmp/deploy.lock` orphan blocks self_healer | Cowork session crashed mid-deploy | STALE_LOCK_DETECTION_V1 auto-expires >24h. If not: `rm /tmp/deploy.lock` |
| Spend climbing despite F1 fix | fallback chain integrity drifted: `grep -cE 'kimi-k2\|llama-4-scout' /opt/openclaw/litellm-config.yaml` should match baseline (67) | restore from `/opt/openclaw/litellm-config.yaml.bak-pre-*` |
| D55 fires "keepalive cron wedged" | grep keepalive log for `REFRESH_TOKEN_REVOKED` first | re-auth before assuming stale heartbeat |
| `mc_api` 404 on `/api/system/meta` | wrong path — it's at `/mission-control/api/system/meta` | check `/health` first; FastAPI auto-docs at `/docs` |
| Reboot brought hermes-conductor back up | systemd unit was `enabled` | `sudo systemctl stop hermes-conductor && sudo systemctl disable hermes-conductor` per F10 |
| D29 "Cron Config Validator: CHECK CRASHED" | toolset migration produced consumers reading null `toolsets` instead of `enabled_toolsets` | resolved (null-safe shim — backup `services/debug_checks.py.bak-pre-d29-fix-*`) |
| D04 / D06 SH-COMPOSITE inflated by `[timeout]` transients | tracker counted transients toward chronic. CHRONIC_DETECTOR_BODY_AWARE_V1 was applied to chronic-observation but not the persistent-failures tracker | resolved (`services/self_healer.py:~1207-1218` routes transient classes to `tracker["transient_" + cid]`) |
| Empty `transient_<cid>` after first cycle on patched code | tracker save happens at end of cycle (line 1579, before "Cycle complete"). Mid-cycle reads see stale state | informational — wait ~4 min between observations |
| Cron with chained `&&` shows missing_log even when script ran | `cmd1 && cmd2 && cmd3 >> log 2>&1` — redirect ONLY attaches to `cmd3`. Outputs of `cmd1`/`cmd2` go to crontab's mail-to (usually unset) | wrap in `bash -c '... && ... && ...' >> log 2>&1`, OR have script log via Python logging directly (canonical: `de6_tiered_enforce_flipper.py` `_de6_log()`) |
| LAMBO-2C creating "stuck" experiments | When LLM crons are cold, auto-proposer fires placeholder experiments waiting on Dream Cycle (also cold). They accumulate against 4-experiment cap | resolved (cold-state guard in `drift_to_experiment_sweep.py`). For cleanup see [playbooks/stuck-experiment-cleanup.md](playbooks/stuck-experiment-cleanup.md) |
| litellm-config.yaml YAML quirk — container crashes on restart with `could not find expected ':'` | malformed callback section like `success_callback:["langfuse"]` (no space after colon) followed by orphan `- langfuse` lines. Container survives on cached parse; next restart crashloops | **Hard rule:** parse-check BEFORE `docker restart litellm`. See [§ 8.3](#83-litellm-config-validation--hard-rule) and [playbooks/litellm-config-edit.md](playbooks/litellm-config-edit.md). The killswitch script enforces this implicitly. |

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 10. Common diagnostic queries (paste-ready)

```bash
# Cold-state registry — what's intentionally off
sqlite3 /home/openclawops/.hermes/state.db \
  "SELECT subsystem, since, expected_resume, set_by FROM cold_state_registry;"

# Active experiments (anything not resolved)
sqlite3 /home/openclawops/.hermes/state.db \
  "SELECT id, state, phase, day || '/' || total_days AS d, p_better, substr(hypothesis,1,40) \
   FROM experiments WHERE state IN ('proposed','running','paused') ORDER BY created_at;"

# Self-healer tracker — what's accumulating consecutive errors vs transients
sudo python3 -c "import json; t=json.load(open('/home/openclawops/.hermes/mission-control/self-heal-tracker.json')); \
  [print(f'{k:30s}: {v}') for k,v in sorted(t.items()) if not k.startswith(('last_fix_','ok_streak_'))]"

# syscron_health — D33 row-level inspection
sqlite3 /home/openclawops/.hermes/state.db \
  "SELECT id, status, substr(error_msg,1,90) FROM syscron_health WHERE status != 'ok';"

# Live D-check status
curl -s http://127.0.0.1:7722/debug/checks/D33 | python3 -m json.tool

# Pending escalations
curl -s http://127.0.0.1:7722/queue 2>/dev/null | python3 -m json.tool | head -40
sqlite3 /home/openclawops/.hermes/state.db \
  "SELECT id, severity, check_id, substr(title,1,60), created_at FROM escalation_queue \
   WHERE status IN ('pending','polled') ORDER BY id DESC LIMIT 20;"

# Healer effectiveness — heal_rate per check
curl -s http://127.0.0.1:7722/debug/healer-effectiveness | python3 -m json.tool

# Active baselines
sqlite3 /home/openclawops/.hermes/state.db \
  "SELECT check_id, acknowledged_value, acknowledged_status, suppress_until \
   FROM debug_baselines ORDER BY updated_at DESC LIMIT 20;"

# Recent Langfuse audit lines
ssh openclawops@100.85.9.1 \
  'sudo tail -200 /var/log/finnick/mc-api.log | grep "langfuse-proxy.*AUDIT" | tail -20'

# Find recent backups under code trees
ssh openclawops@100.85.9.1 \
  'sudo find /opt/openclaw/mission-control/phase5-backend /home/openclawops/.hermes/scripts -name "*.bak-*" -mtime -7 -ls'
```

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 11. Backup naming convention

Every prod-write edit takes a backup with one of these patterns:

```
<filename>.bak-<short-reason>-<YYYYMMDD-HHMMSS>
<filename>.bak-pre-<sprint-or-feature>-<TS>
```

Examples: `services/debug_checks.py.bak-pre-d29-fix-<TS>`, `routers/langfuse.py.bak-pre-tier3-phase0-20260508T185020`, `litellm-config.yaml.bak-malformed-yaml-found-20260508T185522`.

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 12. Scripts directory — `/opt/openclaw/scripts/`

| Script | Purpose |
|---|---|
| `compliance_audit.py` | NPE/Hermes compliance gates audit |
| `deploy_lock.sh` | STALE_LOCK_DETECTION_V1 (auto-expires `/tmp/deploy.lock` >24h) |
| `e20-auto-ramp.sh` | conductor bandit ramp helper (called by root cron */30; no-op in cold state) |
| `issue_nonce.sh` | issues idempotency nonce for sensitive operations |
| `langfuse-killswitch.sh` | SRE lever — see [playbooks/langfuse-killswitch.md](playbooks/langfuse-killswitch.md) |
| `news_scanner_promote_to_hermes.sh` | promotes news scanner outputs into Hermes memory |
| `rollback_gc.{py,sh}` | rollback / garbage-collection helper |
| `sprint_backup.sh` | sprint-plan backup helper |
| `wave2_migrate.py` | Wave 2 model-expansion migration (one-shot, archival) |

---

<!-- owner: Tiffany last-verified: 2026-05-08 -->

## 13. External anchors

System-bible-adjacent docs that live elsewhere. Read these for vault-side context.

- `/opt/openclaw/data/vault/IDENTITY.md` — Finnick persona (🍵)
- `/opt/openclaw/data/vault/SOUL.md` — operating principles ("Be resourceful before asking")
- `/opt/openclaw/data/vault/AGENTS.md` — workspace conventions
- `/opt/openclaw/data/vault/TOOLS.md` — should mirror this runbook (sync target)
- `/opt/openclaw/mission-control/dash/v5/tabs/architecture.js` — Life Dash 26-engine topology
- `/opt/openclaw/mission-control/phase5-backend/services/SELF-HEALER-DOCTRINE.md` — canonical self-healer doctrine v2.5 (also captured in [decisions/0004-self-healer-doctrine.md](decisions/0004-self-healer-doctrine.md))

For sprint-level history → `OpenClaw/SPRINT_PLAN_*.md`. For session-level memory → `~/.../memory/MEMORY.md`.
