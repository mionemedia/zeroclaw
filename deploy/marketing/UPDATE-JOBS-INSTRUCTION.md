# Instructions for Agent to Update Cron Jobs with Telegram Delivery

**Send this exact message to @Kuffsbot on Telegram:**

```
Use cron_list tool to see all scheduled jobs, then use cron_update tool to update each job with this delivery configuration:

{
  "mode": "announce",
  "channel": "telegram", 
  "to": "8203092181"
}

Update all jobs you find. Show me the results.
```

---

## What This Does

1. **cron_list** - Agent lists all 7 current cron jobs
2. **cron_update** - Agent updates each job with Telegram delivery
3. **Results** - Agent shows you what was updated

---

## Expected Result

Each job will be updated to send output to your Telegram chat (8203092181) instead of saving to files.

---

## Verify

After agent completes, verify with:

```bash
docker exec zeroclaw-marketing zeroclaw cron list
```

Look for delivery configuration in the output.
