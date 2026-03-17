# ZeroClaw Marketing Deployment — System Brief

**Version:** 0.4.3 (with custom marketing enhancements)  
**Last Updated:** 2026-03-17  
**Owner:** mionemedia  
**Purpose:** Autonomous marketing agent for Odin Smalls' ZAHANARA dark cultivation fantasy series

---

## What is ZeroClaw?

**ZeroClaw** is a Rust-first autonomous AI agent runtime designed for performance, efficiency, and extensibility. It's a self-hosted alternative to cloud-based AI assistants, giving you complete control over your agent's behavior, data, and costs.

**Key Features:**
- **Multi-channel support** — Telegram, Discord, CLI, web dashboard
- **Tool execution** — File operations, web search, shell commands, memory management
- **Multi-provider routing** — Dynamically switch between AI models based on task complexity
- **Security-first** — Pairing codes, rate limiting, workspace sandboxing
- **Cost optimization** — Hybrid free (Ollama) + paid (OpenRouter) model routing

---

## Your Deployment Overview

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│  ZeroClaw Marketing Agent (Docker Container)            │
├─────────────────────────────────────────────────────────┤
│  Channels: Telegram ✅ | Dashboard ✅ | CLI ✅           │
│  Providers: OpenRouter (Claude) + Ollama (local)        │
│  Memory: SQLite with auto-save                          │
│  Workspace: Sandboxed /zeroclaw-data/workspace          │
└─────────────────────────────────────────────────────────┘
          │                    │                    │
          ▼                    ▼                    ▼
    Telegram Bot      Web Dashboard         Ollama (local)
    (8711868088)    localhost:42617      host.docker.internal:11434
```

### Soul Stack (Agent DNA)

Your agent's personality and behavior are defined by three core markdown files:

| File | Purpose | What It Defines |
|------|---------|-----------------|
| **SOUL.md** | Identity & boundaries | Who the agent is, hard limits, operating principles |
| **STYLE.md** | Voice protocol | How to communicate (professional vs casual modes) |
| **AGENTS.md** | Team workflows | Orchestrator logic and specialist coordination |

**Additional Resources:**
- **`agents/`** — Specialist persona library (Book Co-Author, SEO Specialist, etc.)
- **`knowledge/`** — Your Obsidian vault with ZAHANARA lore and research
- **`output/`** — Where the agent saves all deliverables (accessible from host)

---

## Model Routing Strategy

Your deployment uses **intelligent cost optimization** via hybrid provider routing:

### Default Behavior
- **Provider:** OpenRouter (Claude Sonnet 4)
- **Use Case:** Marketing content, book chapters, brand strategy
- **Cost:** ~$0.003 per request (premium quality)

### Smart Routing via Hints

The agent automatically selects the most cost-efficient model:

| Hint | Model | Provider | Cost | Use Case |
|------|-------|----------|------|----------|
| `default` | Claude Sonnet 4 | OpenRouter | $$ | Final content, client-facing |
| `hint:marketing` | Claude Sonnet 4 | OpenRouter | $$ | Campaigns, brand work |
| `hint:book` | Claude Sonnet 4 | OpenRouter | $$ | Book chapters |
| `hint:deep` | Claude Sonnet 4.5 | OpenRouter | $$$ | Strategic analysis |
| `hint:final` | Claude Sonnet 4 | OpenRouter | $$ | Publication polish |
| **`hint:draft`** | llama3.2 | Ollama | FREE | Brainstorming, outlines |
| **`hint:brainstorm`** | llama3.2 | Ollama | FREE | Idea generation |
| **`hint:outline`** | llama3.2 | Ollama | FREE | Structure planning |
| **`hint:seo`** | deepseek-r1 | Ollama | FREE | Keyword research |
| **`hint:code`** | qwen2.5-coder | Ollama | FREE | Programming tasks |
| **`hint:fast`** | gemma3:4b | Ollama | FREE | Quick summaries |

**Cost Optimization:** 80% savings by using free Ollama for drafts/utility, premium Claude only for final polish.

---

## Access Points

### 1. Web Dashboard
**URL:** http://localhost:42617  
**Features:**
- Real-time chat interface
- Pairing code management
- System status and metrics
- WebSocket chat support

**First-time setup:**
1. Navigate to http://localhost:42617
2. Enter pairing code (check logs: `docker logs zeroclaw-marketing`)
3. Start chatting with your agent

### 2. Telegram Bot
**Bot Username:** @Kuffsbot  
**Bot ID:** 8711868088  
**Allowed Users:** 8203092181 (your Telegram ID)

**Features:**
- Stream mode: Partial (see responses as they're generated)
- Document uploads: ✅ (attach files, agent downloads them)
- Voice messages: ✅
- Mention mode: Off (responds to all messages)

### 3. CLI (inside container)
```bash
docker exec -it zeroclaw-marketing zeroclaw status
docker exec -it zeroclaw-marketing zeroclaw memory list
docker exec -it zeroclaw-marketing zeroclaw tools list
```

---

## Configuration Details

### Environment Variables
```bash
# Provider Configuration
PROVIDER=openrouter
API_KEY=sk-or-v1-***  # OpenRouter API key
OLLAMA_URL=http://host.docker.internal:11434

# Model Selection
ZEROCLAW_MODEL=anthropic/claude-sonnet-4

# Gateway
ZEROCLAW_GATEWAY_PORT=42617
ZEROCLAW_ALLOW_PUBLIC_BIND=true

# Cost Limits
COST_LIMIT_DAILY_USD=5.00
COST_LIMIT_MONTHLY_USD=50.00
```

### Workspace Structure
```
/zeroclaw-data/workspace/
├── AGENTS.md          # Orchestrator + team roster (auto-loaded)
├── SOUL.md            # Agent identity & boundaries (auto-loaded)
├── STYLE.md           # Marketing voice protocol (auto-loaded)
├── agents/            # Specialist personas (Book Co-Author, etc.)
│   └── [specialist-name].md
├── knowledge/         # Obsidian vault (read-only)
│   └── [your notes and research]
└── output/            # Deliverables (agent writes, you read)
    └── [generated content]
```

### Security Features
- **Pairing required:** One-time codes for new clients
- **Rate limiting:** 5 pairs/min, 30 webhooks/min
- **Workspace sandboxing:** Agent can't access host filesystem
- **Allowed commands only:** `ls`, `cat`, `head`, `tail`, `wc`, `grep`, `find`, `echo`, `pwd`
- **Forbidden paths:** `/etc`, `/root`, `/home`, system directories blocked

---

## Daily Operations

### Starting the Agent
```bash
cd H:\GitHub\zeroclaw-main\deploy\marketing
docker compose up -d
docker logs zeroclaw-marketing --tail 50  # Check status
```

### Stopping the Agent
```bash
docker compose down
```

### Viewing Logs
```bash
docker logs zeroclaw-marketing --tail 100 --follow
```

### Getting Pairing Code
```bash
docker logs zeroclaw-marketing | grep "pairing code"
# Look for the box with 6-digit code
```

### Checking System Status
```bash
docker exec zeroclaw-marketing zeroclaw status
```

### Accessing Output Files
Generated content is automatically saved to:
```
H:\GitHub\zeroclaw-main\deploy\marketing\output\
```

---

## Specialist Agents

Your orchestrator coordinates these specialist agents (stored in `agents/` folder):

1. **Book Co-Author** — Chapter writing, voice consistency, marketability
2. **Social Media Strategist** — Multi-platform campaigns, content calendars
3. **LinkedIn Content Creator** — Thought leadership, professional posts
4. **Brand Guardian** — Voice consistency, positioning, messaging framework
5. **SEO Specialist** — Keyword research, optimization, trend analysis
6. **Executive Summary Generator** — Concise reports, data visualization

**How it works:**
- User gives task: "Write a LinkedIn post about leadership"
- Orchestrator reads `agents/linkedin-content-creator.md`
- Adopts that specialist's workflow and deliverable format
- Executes task using appropriate model (free draft → premium final)
- Saves output to `output/` folder

---

## Cost Management

### Daily Budget: $5.00
**Typical Usage:**
- 10 final marketing posts (Claude): ~$0.30
- 50 brainstorming sessions (Ollama): $0.00
- 5 book chapter drafts (Ollama): $0.00
- 3 polished chapters (Claude): ~$0.45
- **Total:** ~$0.75/day (well under budget)

### Monthly Budget: $50.00
**Projected:** ~$22.50/month at current usage

### Cost Warnings
- System warns at 80% of budget
- Agent automatically switches to free models if approaching limit

---

## Troubleshooting

### Issue: Dashboard won't load
**Solution:**
```bash
docker logs zeroclaw-marketing  # Check for errors
curl http://localhost:42617/health  # Test backend
```

### Issue: Ollama models not working
**Solution:**
1. Check Ollama is running: `ollama list`
2. Verify host networking: `docker logs zeroclaw-marketing | grep "host.docker.internal"`
3. Pull missing models: `ollama pull llama3.2`

### Issue: Telegram bot not responding
**Solution:**
1. Verify bot token: `echo $TELEGRAM_BOT_TOKEN`
2. Check allowed users in `config.toml`
3. Restart containers: `docker compose down && docker compose up -d`

### Issue: Out of OpenRouter credits
**Solution:**
1. Add credits at https://openrouter.ai
2. Or switch to free-only mode: Edit `config.toml` → set `default_provider = "ollama"`

---

## Git Workflow

### Current Branch
`feature/v0.4.3-with-customizations`

### Custom Commits (Cherry-picked from fork)
1. Marketing deployment configuration (port 42617)
2. Telegram document upload support
3. Output folder for deliverables
4. Agent team volume mounts
5. Hybrid OpenRouter + Ollama routing
6. SOUL.md (agent identity)
7. STYLE.md (voice protocol)

### Upstream
**Repo:** https://github.com/zeroclaw-labs/zeroclaw  
**Version:** v0.4.3

---

## Key Files Reference

| File | Purpose | Location |
|------|---------|----------|
| **SOUL.md** | Agent identity | `deploy/marketing/SOUL.md` |
| **STYLE.md** | Voice protocol | `deploy/marketing/STYLE.md` |
| **AGENTS.md** | Orchestrator | `deploy/marketing/AGENTS.md` |
| **config.toml** | Full config | `deploy/marketing/config.toml` |
| **docker-compose.yml** | Deployment | `deploy/marketing/docker-compose.yml` |
| **.env** | Secrets | `deploy/marketing/.env` (gitignored) |
| **Dockerfile** | Build spec | `Dockerfile` |

---

## Technical Stack

- **Runtime:** Rust 1.94 (compiled binary)
- **Container:** Docker with multi-stage build
- **Database:** SQLite (memory + sessions)
- **Frontend:** Vite + TypeScript (compiled to static assets)
- **Backend:** Axum web framework
- **Embedding:** rust-embed for dashboard assets
- **Providers:** OpenRouter API + Ollama local
- **Channels:** Telegram Bot API + WebSocket gateway

---

## Next Steps

1. **Test the agent:**
   - Send "hello" via Telegram
   - Visit http://localhost:42617
   - Ask: "hint:brainstorm Generate 5 book title ideas"

2. **Create specialist agents:**
   - Add new files to `H:\GitHub\agency-agents\`
   - Restart containers to load them

3. **Monitor costs:**
   - Check OpenRouter dashboard: https://openrouter.ai/credits
   - Review agent logs for model selection

4. **Optimize workflows:**
   - Update AGENTS.md with new orchestration rules
   - Add more routing hints in config.toml
   - Refine STYLE.md for better voice consistency

---

## Support & Documentation

- **ZeroClaw Docs:** https://docs.zeroclaw.ai (if available)
- **Upstream Repo:** https://github.com/zeroclaw-labs/zeroclaw
- **OpenRouter Docs:** https://openrouter.ai/docs
- **Ollama Docs:** https://ollama.ai/docs

---

**Built with ⚡ by mionemedia**  
**For:** ZAHANARA dark cultivation fantasy marketing
