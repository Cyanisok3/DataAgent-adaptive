# Vanilla Product Discovery

This directory is intentionally separate from DataAgent's application source.

- `fixture/` contains a deterministic H2 seed and the profile override used only for this study.
- `runs/` holds one immutable evidence bundle per case.
- `logs/` holds local backend logs and is ignored.

The fixture's fixed observation window is 2026-08-03 through 2026-08-16.
It contains no credentials and must not be used as a production configuration.

## Run boundary

Start the unchanged backend through the repository's normal runtime path. Configure a chat and embedding model through the normal DataAgent UI/API only; never write keys to this directory or the repository. The current discovery runtime keeps DataAgent metadata in its normal MySQL database and binds an isolated in-memory H2 business fixture.

Each recorded case must preserve the raw SSE timeline before any human grading.

## Validated run path

The recorded run uses the unchanged checkout at commit `000e97f`, the normal backend on port 8065, and the normal MySQL metadata store. The business datasource is an isolated H2 file generated from `discovery_schema.sql` and `discovery_business_seed.sql`; the generated `.mv.db` file is ignored.

Before the case runner, confirm `curl http://127.0.0.1:8065/api/model-config/check-ready` reports both `chatModelReady` and `embeddingModelReady` as `true`, and confirm the discovery datasource exposes exactly `customers`, `daily_funnel_metrics`, and `orders`.

```bash
DATAAGENT_DISCOVERY_URL=http://127.0.0.1:8065 \
DATAAGENT_DISCOVERY_AGENT_ID=1 \
bash /Users/lofi/Downloads/DataAgent/discovery/run_vanilla_cases.sh
```
