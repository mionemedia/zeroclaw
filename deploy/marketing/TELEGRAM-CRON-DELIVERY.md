# Delivering Cron Job Output to Telegram

## Problem

Current cron jobs save output to markdown files in `output/` folder instead of delivering to Telegram.

## Solution

Add `delivery` configuration to cron jobs to send results directly to your Telegram chat.

---

## Your Telegram Chat ID

From `config.toml`:
- **Your Chat ID:** `8203092181`
- **Bot Username:** @Kuffsbot
- **Channel:** `telegram`

---

## Update Existing Jobs to Deliver to Telegram

**Easiest Method:** Ask the agent to do it for you.

Message @Kuffsbot on Telegram:

```
Update all my cron jobs to deliver results to my Telegram chat instead of saving files
```

The agent will use the `cron_update` tool with delivery settings for each job.

### Manual Update (Advanced)

If you want to update jobs manually, you need to use the `cron_update` tool with a JSON patch structure. The CLI `zeroclaw cron update` command does NOT support delivery settings.

Job IDs from `cron list`:

1. **Weekly Email Draft:** `7136776a-ba73-437a-9d78-4bcb55aa6241`
2. **BookBub Daily Check:** `499ea6f4-5933-4ca0-8ab2-f34adfc3b263`
3. **Weekly Review:** `174a3745-2a13-431d-ae63-a45b1b59b636`
4. **Monthly Review:** `de7e86b2-2670-4aa4-b35d-f60e769920f4`
5. **Mini-Relaunch Kickoff:** `87d171b2-8a63-4ad1-b540-ae9fb1203d7d`
6. **StoryOrigin Promos:** `1126ef13-b39b-4960-978c-0bb793cc8ade`
7. **MiBlart Cover Arrival:** `bc4ff07b-4246-4c94-9e6a-ef6232582c89`

---

## Create New Jobs with Telegram Delivery

When creating new cron jobs via the agent, include delivery configuration:

### Example: Agent Request

**Your message to @Kuffsbot:**
```
Create a cron job to check BookBub performance every day at 10:30am EST and send the results to me on Telegram
```

**What the agent will do:**
```json
{
  "name": "BookBub Daily Check",
  "schedule": {
    "kind": "cron",
    "expression": "30 10 * * *",
    "timezone": "America/New_York"
  },
  "job_type": "agent",
  "prompt": "SEO Specialist: BookBub campaign performance analysis",
  "delivery": {
    "mode": "announce",
    "channel": "telegram",
    "to": "8203092181"
  }
}
```

### More Examples

**Weekly email draft delivered to Telegram:**
```
Create a weekly cron job for Monday 9am EST to draft nurture email and deliver it to Telegram
```

**Cover review checklist:**
```
Schedule a monthly job on the 1st at 11am EST to run the cover review checklist and send results to my Telegram
```

**Mini-relaunch planning:**
```
Create a one-time job for April 1st at 2pm EST to draft the mini-relaunch plan and send it to me on Telegram
```

---

## How Telegram Delivery Works

1. **Cron job triggers** at scheduled time
2. **Agent processes** the prompt with SOUL.md, STYLE.md, agents
3. **Output generated** (analysis, draft, checklist, etc.)
4. **Delivered to Telegram** via @Kuffsbot to chat ID `8203092181`
5. **You receive** the message directly in your Telegram chat

### What You'll Receive

- ✅ Full text output from the agent
- ✅ Markdown formatting (bold, lists, code blocks)
- ✅ Long responses split into multiple messages if needed
- ✅ Immediate notification when job completes

### What You WON'T See

- ❌ No more files in `output/` folder
- ❌ No need to check Docker logs
- ❌ No need to SSH into container

---

## Discord Alternative (Future)

If you set up Discord, ask the agent:

```
Update my cron jobs to deliver to Discord channel <CHANNEL_ID> instead
```

---

## Verify Delivery Settings

After updating, check the job configuration:

```bash
docker exec zeroclaw-marketing zeroclaw cron list
```

Look for delivery info in the output.

---

## Test Immediately

Trigger a job manually to test Telegram delivery:

```bash
docker exec zeroclaw-marketing zeroclaw cron run <JOB_ID>
```

You should receive the output in Telegram within seconds.

---

## Troubleshooting

### Not receiving Telegram messages?

1. **Check bot is paired:** Verify pairing code in Docker logs
2. **Check chat ID:** Must be `8203092181` (your allowed user ID)
3. **Check Telegram is running:** Look at container logs
4. **Test with manual message:** Send "test" to @Kuffsbot

### Still saving to files?

Jobs without `delivery` configuration will default to saving files. Make sure you've updated all jobs with the `--delivery-*` flags.

---

## Summary

**Current state:** Jobs save to `output/*.md` files  
**Desired state:** Jobs deliver to Telegram chat  
**Action needed:** Update 7 existing jobs with delivery settings  
**Your Chat ID:** `8203092181`  
**Bot:** @Kuffsbot
