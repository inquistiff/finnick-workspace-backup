# NPE OpenAI Business Plan → Anthropic Migration

## 1. Objectives & Success Criteria
- Preserve GPT templates, conversation history, and Projects from the OpenAI Business workspace without data loss.
- Stand up Anthropic/Claude access with least-privilege RBAC, audit logging, and documented operating procedures.
- Maintain continuity for the teams that rely on custom GPTs (Product, CS, Sales) and shared workspaces.
- Achieve feature parity (or documented replacements) before shutting down the OpenAI Business plan.

Success is measured by:
- 100% of prioritized GPTs replicated in Claude and validated by their business owners.
- 100% of tagged Projects migrated or re-created with equivalent metadata.
- Conversation history available to authorized users for compliance look-backs.
- Runbooks + onboarding docs published for Anthropic on day 1.

## 2. Workstreams & Ownership
| Workstream | Owner | Description |
| --- | --- | --- |
| A. Org & Access Foundation | Alexandre (with IT) | Provision Anthropic enterprise org, SSO, RBAC, logging, billing. |
| B. Claude Migration Tool Execution | Alexandre + Ops | Use Claude’s migration feature to import GPTs, chats, Projects. |
| C. Integrations & API Consumers | Product Engineering | Rotate keys, update services that call OpenAI endpoints. |
| D. Validation & Sign-off | Department leads | Each team tests their GPTs/projects and signs off. |
| E. Decommission Plan | IT | Freeze OpenAI Business plan, archive exports, shut down billing. |

## 3. Pre-Migration Checklist (Week 0)
1. **Inventory & Prioritization**
   - Export GPT list from OpenAI Admin console (`/gpts`) with usage stats.
   - Export Projects metadata (owners, linked GPTs, automation hooks).
   - Tag each GPT/Project by priority (Must migrate vs. Archive).
2. **Data Agreement & Legal**
   - Confirm Anthropic DPA and SOC2 packets on file; share with Legal.
   - Document data-retention expectations (e.g., 12 months for chats).
3. **Access Preparation**
   - Decide SSO provider (Okta) and SCIM provisioning.
   - Draft RBAC matrix (Org Admin, Workspace Admin, Builder, Viewer, API-only).
4. **Backups**
   - Run OpenAI data export for the Business org (includes conversations, Projects, GPT configs) and store in encrypted S3 bucket (`s3://npe-ai-backups/<date>`).
   - Snapshot API secrets for services (Rainmaker, HubSpot bridge, etc.).

## 4. Anthropic / Claude Foundation (Week 1)
1. **Org Creation & Network Controls**
   - Create Anthropic enterprise org, enable SSO + MFA enforcement.
   - Add IP allowlist + workspace session timeouts.
2. **Workspace Structure**
   - Create Workspaces aligned to existing OpenAI Projects (e.g., Product R&D, Client Success, Sales Ops).
   - Configure workspace-level document repositories (e.g., link to Obsidian vaults / Google Drive).
3. **RBAC & Provisioning**
   - Import users via SCIM, assign roles per RBAC matrix.
   - Create service accounts for automation/CLI usage (audited API keys stored in 1Password).
4. **Guardrails & Observability**
   - Enable Claude Trust settings (prompt filters, content policies, redaction where needed).
   - Turn on audit logging + export to the central SIEM (Chronicle/Splunk).

## 5. Claude Migration Feature – Execution Plan (Week 2)
Anthropic’s migration assistant supports pulling GPTs, conversations, and Projects by connecting to an OpenAI Business org.

### Step-by-step
1. **Connect Source**
   - Org Admin opens Claude Console → **Settings → Migration → Connect OpenAI**.
   - Authenticate with OpenAI Business admin credentials; grant read scopes.
2. **Select Entities**
   - GPTs tab: select all prioritized GPTs; map each to a target Workspace and owner.
   - Conversations tab: choose date range + user groups (default: last 12 months for Product/CS teams).
   - Projects tab: select Projects tagged “active” in the inventory.
3. **Mapping Options**
   - GPT metadata → Claude: instructions, tools, files, model fallback.
   - Projects → Claude Projects with preserved members + attachments.
   - Conversations → imported into corresponding user inboxes; legacy GPT references flagged for manual review.
4. **Dry Run**
   - Run migration in “Preview” mode for a small subset (e.g., 2 GPTs, 1 Project) to validate fidelity.
   - Document any gaps (missing tool integrations, prompts needing rewrite for Claude).
5. **Full Migration**
   - Execute full run during off-hours.
   - Claude provides a migration report (download and archive).
6. **Post-Migration Tasks**
   - Update GPT owners to verify instructions/output, adjust for Claude-specific tool syntax.
   - Rebuild automations that referenced OpenAI-specific APIs (e.g., function-calling differences).

### What we’ve validated about the Claude migration tool
- Anthropic support confirmed (Feb ’26) that the migration assistant can only copy GPT configs + metadata via OpenAI’s public GPT export endpoints. Conversations and Projects require either OpenAI’s user-level data export or Anthropic’s bulk CSV loader.
- The migration UI exposes three tabs (GPTs, Conversations, Projects). GPTs can be moved end-to-end today; Conversations/Projects require us to supply data files in the formats below.
- We must keep OpenAI admin credentials active until Anthropic signals that every entity finished processing (the tool polls OpenAI’s APIs during import).

## 6. Conversation Export Constraints & Workarounds (OpenAI Business)
OpenAI’s Business plan does **not** expose an org-wide conversation export API. Current options:
1. **Per-user data export:** Each user can visit **Settings → Data controls → Export data** to request a ZIP of their conversations. We can script the combination of those JSON files (Anthropic accepts NDJSON uploads for the conversation tab). Action: send instructions + due dates to all GPT-heavy users and collect exports in `s3://npe-ai-backups/openai-conv/<date>/<user>.zip`.
2. **Admin support ticket:** OpenAI will run a one-time org export for Business customers if Compliance requests it. Submit via the admin console, reference contract ID, and ask for “Organization-wide conversation archive (JSON).” Lead time: ~5 business days.
3. **Third-party capture:** For teams already storing transcripts (e.g., Rainmaker call review in Fireflies/Chorus), we can import from those systems instead of relying on OpenAI.

Workaround flow for Anthropic:
- Aggregate all user ZIPs (or the org export) → run the provided `scripts/anthropic/massage_openai_conversations.py` to convert to Anthropic’s NDJSON schema (conversationId, role, content, timestamp, GPT reference).
- Upload the NDJSON via Claude Migration → Conversations tab.
- Keep the raw ZIPs encrypted for compliance.

## 7. Best Practices for GPT & Project Cutover
- **Version Control:** Keep OpenAI export + Claude import logs side-by-side; track GPT version numbers in ClickUp tasks.
- **Owner Sign-off:** Require each GPT owner to log a test conversation and confirm outputs match expectations.
- **Documentation:** Update SOPs to reference Claude-specific UI (Builder, Workflows) and store links in Obsidian + Confluence.
- **Security:** Assign Secrets via Claude’s encrypted credentials manager; never embed API keys in prompts.
- **Change Freeze:** Once Claude instance is validated, freeze OpenAI GPT editing to avoid divergence during cutover.

## 8. API & Integration Migration
1. **Service Audit**
   - List every app/site calling OpenAI APIs (Rainmaker bots, Fireflies post-processing, HubSpot sequences, etc.).
   - Categorize by runtime (Node, Python, Zapier, Make).
2. **Key Rotation**
   - Generate Anthropic API keys per service account; store in 1Password + environment secrets.
   - Add feature flags to toggle between OpenAI and Anthropic during testing.
3. **Code Updates**
   - Swap SDKs/endpoints (`openai` → `anthropic`, adjust streaming handlers).
   - Update model names and prompt templates to match Claude (e.g., `claude-3-opus`).
4. **Testing**
   - Run regression suite per integration, comparing cost + latency metrics.
5. **Cutover**
   - Schedule cutover windows; monitor logs for failures; roll back if KPIs regress beyond tolerance.

## 9. Validation & Training
- Host enablement sessions for each department (Product, CS, Sales) demonstrating Claude workflows.
- Share quick-reference guides (how to access migrated conversations, where GPTs live, how to submit new bot requests).
- Implement office hours during Week 2 post-cutover for bug triage.

## 10. Decommissioning OpenAI Business Plan
- Keep OpenAI org in read-only mode for 30 days while monitoring Claude adoption.
- After sign-off, revoke user access, delete remaining API keys, and cancel the Business plan subscription.
- Archive final exports + migration reports to long-term storage.

## 11. Timeline (Draft)
| Week | Milestone |
| --- | --- |
| 0 | Inventory complete, backups taken, Anthropic contract finalized |
| 1 | Anthropic org live (SSO, workspaces, RBAC) |
| 2 | Claude migration preview + full import |
| 3 | Integration cutovers + user enablement |
| 4 | OpenAI Business plan decommission |

## 12. Deliverables for Alexandre to Share
- Migration checklist (this doc) in Obsidian/ClickUp.
- Status update template for weekly exec sync (traffic-light view of each workstream).
- Slack update (see below) summarizing next actions + owners.
