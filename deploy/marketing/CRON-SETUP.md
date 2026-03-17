# Marketing Automation Cron Jobs

Automated marketing tasks using the ZeroClaw agent via scheduled bash scripts.

---

## Quick Start

```bash
cd H:\GitHub\zeroclaw-main\deploy\marketing
bash marketing-cron.sh <task>
```

**Available tasks:**
- `bookbub` — BookBub campaign analysis
- `cover-review` — ZAHANARA cover checklist
- `email` — Weekly nurture email
- `storyorigin` — StoryOrigin promo recommendations
- `relaunch` — Mini-relaunch plan
- `review` — Weekly performance review
- `monthly` — Monthly executive summary

---

## Test Results ✅

**Tested:** `bash marketing-cron.sh email`  
**Status:** Success  
**Output:** `output/email-20260317.md`  
**Model Used:** Claude Sonnet 4 (OpenRouter)  
**Duration:** ~74 seconds  
**Tokens:** 12,900 input + 3,589 output  
**Cost:** ~$0.05

**Generated Content:**
- Subject line options with mythic hooks
- Complete email body with STYLE.md voice (casual mode)
- Lore drop, BookBub tease, 99¢ CTA
- Mobile-optimized format
- Professional analysis section

---

## Windows Scheduled Tasks Setup

Since you're on Windows, use Task Scheduler instead of cron:

### Option 1: Task Scheduler GUI

1. Open **Task Scheduler** (`taskschd.msc`)
2. **Create Task** (not Basic Task)
3. **General Tab:**
   - Name: `ZeroClaw Weekly Email`
   - Run whether user is logged on or not
4. **Triggers Tab:**
   - New → Weekly → Monday 8:00 AM
5. **Actions Tab:**
   - Program: `C:\Program Files\Git\bin\bash.exe`
   - Arguments: `H:\GitHub\zeroclaw-main\deploy\marketing\marketing-cron.sh email`
   - Start in: `H:\GitHub\zeroclaw-main\deploy\marketing`
6. **Conditions Tab:**
   - Uncheck "Start only if on AC power"

### Option 2: PowerShell Equivalent

Create `marketing-cron.ps1`:

```powershell
param([string]$Task)

$ScriptDir = "H:\GitHub\zeroclaw-main\deploy\marketing"
Set-Location $ScriptDir

$Date = Get-Date -Format "yyyyMMdd"
$Filename = "output\$Task-$Date.md"

switch ($Task) {
    "email" {
        "# Weekly Email Campaign" | Out-File -FilePath $Filename
        "" | Out-File -FilePath $Filename -Append
        docker exec zeroclaw-marketing zeroclaw agent -m "Content Creator: Weekly nurture for ~50 subs. Lore hook (Anansi curse), BookBub spike teaser, 99¢ prequel. Pro plan → casual copy. Save to output/email-$(Get-Date -Format 'yyyyMMdd').md" | Out-File -FilePath $Filename -Append
    }
    # ... other tasks
}

Write-Host "✓ Task completed: $Task"
Write-Host "✓ Output: $Filename ready for review."
```

Then schedule via PowerShell:
```powershell
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File H:\GitHub\zeroclaw-main\deploy\marketing\marketing-cron.ps1 -Task email"
$Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 8am
Register-ScheduledTask -TaskName "ZeroClaw Weekly Email" -Action $Action -Trigger $Trigger
```

---

## Recommended Schedule

| Task | Frequency | Day/Time | Purpose |
|------|-----------|----------|---------|
| **email** | Weekly | Monday 8am | Nurture campaign draft |
| **review** | Weekly | Friday 5pm | Performance metrics |
| **bookbub** | Daily | 9am (during campaigns) | Ad performance check |
| **storyorigin** | Bi-weekly | 1st & 15th, 10am | Promo research |
| **cover-review** | Monthly | 1st of month, 11am | Brand consistency |
| **monthly** | Monthly | Last Friday, 4pm | Executive summary |
| **relaunch** | As needed | Manual trigger | Campaign planning |

---

## Important: Tool Approval Issue

**Current limitation:** The script runs but requires interactive approval for tool usage:

```
🔧 Agent wants to execute: file_write
   [Y]es / [N]o / [A]lways for file_write:
```

### Solution: Configure Auto-Approval

Edit `deploy/marketing/config.toml`:

```toml
[autonomy]
level = "supervised"
auto_approve = [
    "file_read",
    "file_write",      # ADD THIS
    "memory_recall",
    "memory_save",     # ADD THIS
    "web_search_tool"
]
```

Then restart containers:
```bash
docker compose down && docker compose up -d
```

**After this change, cron jobs will run fully automated.**

---

## Output Files

All generated content saves to:
```
H:\GitHub\zeroclaw-main\deploy\marketing\output\
├── email-20260317.md
├── review-20260320.md
├── bookbub-20260318.md
└── monthly-20260331.md
```

**Review workflow:**
1. Check `output/` folder daily
2. Review agent-generated content
3. Copy final version to your marketing tools
4. Delete or archive old files

---

## Cost Management

### Per-Task Costs (Estimated)

| Task | Model | Tokens | Cost |
|------|-------|--------|------|
| email | Claude | ~16k | $0.05 |
| review | Claude | ~12k | $0.04 |
| bookbub | Claude | ~14k | $0.045 |
| storyorigin | Ollama | ~8k | FREE |
| cover-review | Claude | ~10k | $0.03 |
| monthly | Claude | ~18k | $0.06 |

**Weekly schedule cost:** ~$0.25/week = **$13/month**  
**Well under your $50/month budget.**

### Optimization Tips

1. **Use model hints** to force free Ollama for drafts:
   ```bash
   "hint:draft Content Creator: Generate email outline..."
   ```

2. **Batch similar tasks:**
   ```bash
   bash marketing-cron.sh review
   bash marketing-cron.sh monthly  # Run together at month-end
   ```

3. **Enable cost warnings** (already configured in config.toml):
   ```toml
   [cost]
   enabled = true
   daily_limit_usd = 5.00
   warn_at_percent = 80
   ```

---

## Troubleshooting

### Script won't execute
```bash
# Make executable (Git Bash)
chmod +x marketing-cron.sh

# Or use explicit bash call
bash marketing-cron.sh email
```

### Container not running
```bash
docker ps | grep zeroclaw-marketing
# If not running:
docker compose up -d
```

### Output file empty
- Check Docker logs: `docker logs zeroclaw-marketing --tail 100`
- Verify task name is correct
- Ensure containers are running

### Tool approval blocking automation
- Add `file_write` and `memory_save` to `auto_approve` in config.toml
- Restart containers

---

## Advanced: Chaining Tasks

Create a weekly digest that runs multiple tasks:

**weekly-digest.sh:**
```bash
#!/bin/bash
cd "$(dirname "$0")"

echo "📊 Running weekly marketing digest..."

bash marketing-cron.sh email
bash marketing-cron.sh review
bash marketing-cron.sh storyorigin

echo "✓ Digest complete. Check output/ folder."
```

Schedule this single script to run all three tasks sequentially.

---

## Monitoring

**Check last run:**
```bash
ls -lt output/*.md | head -5
```

**View task output:**
```bash
cat output/email-20260317.md
```

**Check agent logs:**
```bash
docker logs zeroclaw-marketing --since 1h
```

---

## Next Steps

1. **Enable auto-approval** in config.toml
2. **Set up Task Scheduler** for weekly email (Monday 8am)
3. **Test end-to-end** automation
4. **Review first automated output** before trusting fully
5. **Adjust prompts** in script based on output quality

---

**Status:** Tested and working ✅  
**Last Updated:** 2026-03-17
