# ZeroClaw Marketing Research Agent — Docker Desktop Setup

A hardened, isolated ZeroClaw deployment for **marketing research and planning only**.

## What this agent CAN do

- **Web research** — audience analysis, competitor research, tropes, trends, ad angles (DuckDuckGo or Brave Search)
- **Draft marketing plans** — launch calendars, email/social sequences, ad copy variants
- **Summarize content** — articles, podcasts, YouTube transcripts into actionable bullet points
- **Take notes** — store and recall research findings in workspace markdown files

## What this agent CANNOT do (by design)

| Disabled capability | Why |
|---|---|
| Shell access | No `rm`, `curl`, `wget`, `ssh`, `docker`, or destructive commands |
| Browser automation | No headless browsing or computer-use |
| Filesystem outside workspace | Cannot read/write outside `/zeroclaw-data/workspace` |
| Composio / OAuth tools | No direct access to TikTok, X, Gmail, Google Drive, KDP, etc. |
| Cron / Scheduler | No autonomous scheduled tasks |
| Hardware / Peripherals | No GPIO, serial, or probe access |
| HTTP requests | Disabled by default; enable selectively via `config.toml` |

## Prerequisites

- **Docker Desktop** installed and running on Windows/Mac/Linux
- An **LLM API key** (OpenRouter, OpenAI, Anthropic, etc.)
- *(Optional)* A [Brave Search API key](https://brave.com/search/api) for higher-quality web search

## Quick Start

### 1. Navigate to this directory

```powershell
cd deploy\marketing
```

### 2. Create your `.env` file

```powershell
copy .env.example .env
```

Edit `.env` and set your `API_KEY`:

```ini
API_KEY=sk-or-v1-your-openrouter-key-here
PROVIDER=openrouter
```

### 3. Start the agent

```powershell
docker compose up -d
```

### 4. Check it's healthy

```powershell
docker compose ps
docker logs zeroclaw-marketing
```

### 5. Pair your client

The gateway requires pairing before accepting requests:

```powershell
curl -X POST http://localhost:3000/pair
```

Save the returned bearer token — you'll use it for all subsequent requests.

### 6. Send a research task

```powershell
curl -X POST http://localhost:3000/webhook ^
  -H "Authorization: Bearer YOUR_TOKEN" ^
  -H "Content-Type: application/json" ^
  -d "{\"message\": \"Research the top 5 BookTok trends for dark romance in 2025. Summarize each trend with audience size estimates, key hashtags, and content angles for a launch campaign.\"}"
```

## Architecture

```
┌─────────────────────────────────────────────────┐
│  Docker Desktop                                 │
│                                                 │
│  ┌───────────────────────────────────────────┐  │
│  │  zeroclaw-marketing  (distroless image)   │  │
│  │                                           │  │
│  │  Tools enabled:                           │  │
│  │    ✅ web_search_tool (DuckDuckGo/Brave)  │  │
│  │    ✅ file_read / file_write (workspace)  │  │
│  │    ✅ memory_store / memory_recall        │  │
│  │    ❌ shell, browser, http_request        │  │
│  │    ❌ composio, cron, hardware            │  │
│  │                                           │  │
│  │  Volumes:                                 │  │
│  │    📁 config.toml (read-only mount)       │  │
│  │    📁 marketing-sandbox (workspace)       │  │
│  └──────────────┬────────────────────────────┘  │
│                 │ :3000 (localhost only)         │
└─────────────────┼───────────────────────────────┘
                  │
            Your browser / curl
```

## Security Hardening Summary

| Layer | Setting |
|---|---|
| **Container** | Read-only root filesystem, `no-new-privileges`, all capabilities dropped |
| **User** | Runs as non-root (uid 65534) |
| **Network** | Gateway bound to `127.0.0.1` on host (not exposed to LAN) |
| **Config** | Mounted read-only — agent cannot weaken its own policy |
| **Autonomy** | `supervised` level, `workspace_only = true` |
| **Shell** | Only safe read-only commands (`ls`, `cat`, `grep`, etc.) |
| **Resources** | Capped at 1 CPU, 1 GB RAM |
| **Cost** | Daily limit $5, monthly limit $50, warnings at 80% |

## Using Brave Search (recommended for deep research)

1. Get a free API key at [brave.com/search/api](https://brave.com/search/api)
2. Update your `.env`:

```ini
WEB_SEARCH_PROVIDER=brave
BRAVE_API_KEY=BSA-your-key-here
```

3. Restart: `docker compose restart`

## Enabling HTTP Requests (optional, for specific APIs)

If you need the agent to call specific research APIs (e.g., Notion, ClickUp):

1. Edit `config.toml`:

```toml
[http_request]
enabled         = true
allowed_domains = ["api.notion.com", "api.clickup.com"]
```

2. Restart: `docker compose restart`

> **Warning:** Only allow-list domains you trust. Never add broad domains like `*.google.com`.

## Using Local Ollama Instead of Cloud LLMs

To use a local Ollama instance running on your host machine:

1. Update `.env`:

```ini
API_KEY=http://host.docker.internal:11434
PROVIDER=ollama
ZEROCLAW_MODEL=llama3.2
```

2. Restart: `docker compose restart`

> `host.docker.internal` resolves to your host machine from inside Docker Desktop.

## Workflow: "You Propose, I Approve"

Instruct the agent with a system-level workflow template:

```
You are a marketing research assistant. For every task:

1. State the campaign goal
2. Present audience insights with sources
3. Build an angle matrix (hook × audience × channel)
4. Propose a channel plan with rationale
5. Draft a content calendar (7-30 days)
6. Suggest A/B test ideas

NEVER take external actions. Always output drafts for my review.
I will copy approved content to my real accounts manually.
```

## Stopping the Agent

```powershell
docker compose down
```

To also remove the workspace data volume:

```powershell
docker compose down -v
```

## Troubleshooting

| Issue | Fix |
|---|---|
| `API_KEY not set` | Ensure `.env` exists and `API_KEY` is filled in |
| Container unhealthy | Check logs: `docker logs zeroclaw-marketing` |
| Port 3000 in use | Change `HOST_PORT=3001` in `.env` |
| Brave search not working | Verify `BRAVE_API_KEY` is set and `WEB_SEARCH_PROVIDER=brave` |
| Ollama connection refused | Ensure Ollama is running and `host.docker.internal` resolves |
