# Native ZeroClaw Cron Jobs

**Status:** ✅ Active  
**Scheduler:** Enabled in config.toml  
**Jobs Configured:** 3

---

## Current Scheduled Jobs

| Job | Schedule | Next Run | Prompt |
|-----|----------|----------|--------|
| **Weekly Email** | Mon 8am UTC | Mar 22 08:00 | Content Creator nurture campaign |
| **Weekly Review** | Fri 5pm UTC | Mar 19 17:00 | Analytics Reporter metrics |
| **Monthly Summary** | 28-31st 4pm UTC | Mar 28 16:00 | Executive metrics review |

---

## View All Jobs

```bash
docker exec zeroclaw-marketing zeroclaw cron list
```

**Output:**
```
🕒 Scheduled jobs (3):
- 704880ac... | Cron { expr: "0 17 * * 5" } | next=2026-03-19T17:00:00+00:00
    prompt: Weekly review: Analytics Reporter performance metrics
- 9d0fc24a... | Cron { expr: "0 8 * * 1" } | next=2026-03-22T08:00:00+00:00
    prompt: Weekly email: Content Creator nurture campaign
- 55674514... | Cron { expr: "0 16 28-31 * *" } | next=2026-03-28T16:00:00+00:00
    prompt: Monthly summary: Executive metrics and campaign review
```

---

## Add New Cron Job

```bash
docker exec zeroclaw-marketing zeroclaw cron add '<CRON_EXPR>' '<PROMPT>' --agent
```

**Examples:**

```bash
# Daily BookBub check at 9am (during campaigns)
docker exec zeroclaw-marketing zeroclaw cron add "0 9 * * *" "SEO Specialist: BookBub campaign analysis" --agent

# Bi-weekly StoryOrigin promo research (1st & 15th at 10am)
docker exec zeroclaw-marketing zeroclaw cron add "0 10 1,15 * *" "Social Strategist: StoryOrigin group promos" --agent

# Cover review on first of month at 11am
docker exec zeroclaw-marketing zeroclaw cron add "0 11 1 * *" "Brand Guardian: ZAHANARA cover checklist" --agent
```

---

## Cron Expression Format

Standard 5-field cron format: `min hour day month weekday`

| Field | Values | Examples |
|-------|--------|----------|
| Minute | 0-59 | `0` = top of hour, `30` = half past |
| Hour | 0-23 | `8` = 8am UTC, `17` = 5pm UTC |
| Day | 1-31 | `1` = 1st, `15` = 15th, `28-31` = last few days |
| Month | 1-12 | `*` = every month |
| Weekday | 0-6 | `1` = Monday, `5` = Friday, `*` = every day |

**Common patterns:**
- `0 8 * * 1` = Every Monday at 8am
- `0 17 * * 5` = Every Friday at 5pm
- `0 9 * * 1-5` = Weekdays at 9am
- `*/30 * * * *` = Every 30 minutes
- `0 16 28-31 * *` = Last few days of month at 4pm

---

## Manage Existing Jobs

### Pause a Job
```bash
docker exec zeroclaw-marketing zeroclaw cron pause <task-id>
```

### Resume a Paused Job
```bash
docker exec zeroclaw-marketing zeroclaw cron resume <task-id>
```

### Update Schedule
```bash
docker exec zeroclaw-marketing zeroclaw cron update <task-id> --expression '0 10 * * 1'
```

### Remove a Job
```bash
docker exec zeroclaw-marketing zeroclaw cron remove <task-id>
```

**Get task ID from `zeroclaw cron list` output (e.g., `704880ac-0de0-41db-9155-8a072ee51a0f`)**

---

## One-Time Scheduled Tasks

### Run Once at Specific Time
```bash
docker exec zeroclaw-marketing zeroclaw cron add-at "2026-04-01T14:00:00Z" "Relaunch plan: Mini-relaunch campaign" --agent
```

### Run Once After Delay
```bash
docker exec zeroclaw-marketing zeroclaw cron once "30m" "Quick check: BookBub performance" --agent
docker exec zeroclaw-marketing zeroclaw cron once "2h" "Email draft review" --agent
docker exec zeroclaw-marketing zeroclaw cron once "1d" "Tomorrow's content plan" --agent
```

---

## How Native Cron Works

### Execution
1. Scheduler runs inside ZeroClaw daemon
2. At scheduled time, job triggers automatically
3. Agent receives prompt as if from user
4. Response generated using SOUL.md, STYLE.md, AGENTS.md
5. Output saved via agent tools (memory, file_write)

### Persistence
- Jobs stored in ZeroClaw database
- Survive container restarts
- Run even if no one is logged in
- No external Task Scheduler needed

### Monitoring
Check logs for cron executions:
```bash
docker logs zeroclaw-marketing --follow | grep -i cron
```

---

## Auto-Approval Required

For jobs to run **fully automated** without waiting for approval:

**Edit `config.toml`:**
```toml
[autonomy]
auto_approve = [
    "file_read",
    "file_write",      # Required for saving output
    "memory_recall",
    "memory_save",     # Required for long-term context
    "web_search_tool"
]
```

Then restart:
```bash
docker compose down && docker compose up -d
```

---

## Cost Management

### Estimated Costs
- **Weekly email:** ~$0.05 (Claude Sonnet 4)
- **Weekly review:** ~$0.04 (Claude Sonnet 4)
- **Monthly summary:** ~$0.06 (Claude Sonnet 4)

**Monthly cost:** ~$2.50 (3 jobs × 4-5 runs/month)

### Use Free Models
Add `hint:draft` to force Ollama:
```bash
docker exec zeroclaw-marketing zeroclaw cron add "0 8 * * 1" "hint:draft Weekly email outline generation" --agent
```

---

## Difference: Native vs Bash Script

| Feature | Native ZeroClaw Cron | Bash Script |
|---------|---------------------|-------------|
| **Visibility** | Shows in `zeroclaw cron list` ✅ | External, not visible ❌ |
| **Persistence** | Survives restarts ✅ | Needs Task Scheduler ❌ |
| **Cross-platform** | Works on Windows/Linux/Mac ✅ | Needs bash (Git Bash on Windows) ⚠️ |
| **Management** | CLI commands (pause/resume/update) ✅ | Manual script editing ❌ |
| **Monitoring** | Built-in logs ✅ | External log files ⚠️ |
| **Auto-approval** | Configurable in config.toml ✅ | N/A - runs externally ⚠️ |

**Recommendation:** Use native ZeroClaw cron for all automated tasks.

---

## Timezone Settings

Default timezone is **UTC**. To use your local timezone:

```bash
docker exec zeroclaw-marketing zeroclaw cron add "0 8 * * 1" "Weekly email" --agent --tz America/New_York
```

Common timezones:
- `America/New_York` (EST/EDT)
- `America/Los_Angeles` (PST/PDT)
- `America/Chicago` (CST/CDT)
- `Europe/London` (GMT/BST)
- `UTC` (default)

---

## Troubleshooting

### Jobs not running
1. Check scheduler is enabled: `grep "enabled = true" config.toml`
2. Check logs: `docker logs zeroclaw-marketing --tail 100`
3. Verify cron syntax: `zeroclaw cron list` shows next run time

### Jobs run but no output
1. Enable `file_write` in `auto_approve` (config.toml)
2. Check agent logs for approval prompts
3. Verify workspace has `output/` folder

### Want to test immediately
```bash
# Trigger job manually (doesn't wait for schedule)
docker exec zeroclaw-marketing zeroclaw agent -m "Weekly email: Content Creator nurture campaign"
```

---

## Next Steps

1. **Monitor first runs:** Check output after Mar 19 (review), Mar 22 (email)
2. **Add more jobs:** BookBub analysis, StoryOrigin promos, cover reviews
3. **Optimize costs:** Use `hint:draft` for utility tasks
4. **Enable auto-approval:** Add `file_write` to config.toml

---

**Status:** All jobs scheduled and active ✅  
**Pairing Code:** 265994  
**Dashboard:** http://localhost:42617
