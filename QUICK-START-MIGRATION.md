# 🚀 Quick Start: v0.7.0 Testing

**Current Status:** On branch `test/v0.7.0-migration` (v0.7.0 codebase)

---

## ⚡ Fast Track (Copy-Paste)

### 1. Dry Run Migration

```powershell
cd H:\GitHub\zeroclaw-main
.\migrate-to-v0.7.0.ps1 -DryRun
```

### 2. Run Migration

```powershell
.\migrate-to-v0.7.0.ps1
```

### 3. Build v0.7.0

```powershell
cargo build --release --features telegram
```

### 4. Start Test Bot

```powershell
# Check production bot is still running
docker ps | Select-String zeroclaw-marketing

# Start test bot (port 42618, different from production)
docker compose -f docker-compose-test.yml up -d --build
```

### 5. Watch Logs

```powershell
docker logs zeroclaw-test --tail 50 -f
```

### 6. Test in Telegram

```
hint:vault test v0.7.0 migration
```

---

## 📊 System State

| Component | Version | Port | Container Name | Status |
|-----------|---------|------|----------------|--------|
| **Production** | v0.4.3 | 42617 | `zeroclaw-marketing` | ✅ Running |
| **Test** | v0.7.0 | 42618 | `zeroclaw-test` | ⏳ Ready to start |

---

## 🎯 What's Different?

### Config Location
```
OLD: H:\GitHub\zeroclaw-main\deploy\marketing\config.toml
NEW: C:\Users\[You]\.zeroclaw\config.toml
```

### Migration Auto-Created
- ✅ Backup of old config (if exists)
- ✅ Copied config.toml → `~/.zeroclaw/`
- ✅ Copied SOUL.md, BRIEF.md

---

## ✅ Success Indicators

Watch for these in `docker logs zeroclaw-test`:

```
✓ Config loaded from: ~/.zeroclaw/config.toml
✓ Telegram channel listening...
✓ Session persistence enabled
✓ Restored 1 session(s) from disk
```

---

## 🔄 Quick Commands

```powershell
# Check test bot status
docker ps | Select-String zeroclaw-test

# View logs
docker logs zeroclaw-test --tail 50

# Stop test bot (keeps production running)
docker compose -f docker-compose-test.yml down

# Restart test bot
docker compose -f docker-compose-test.yml restart

# Switch back to production branch
git checkout feature/v0.4.3-with-customizations
```

---

## 📝 Full Documentation

See `V0.7.0-MIGRATION-GUIDE.md` for comprehensive testing checklist and troubleshooting.

---

## 🛡️ Safety Guarantee

**Your production bot (v0.4.3) is untouched!**
- Different container name
- Different port
- Separate config location
- Can run both simultaneously

**Rollback:** Just stop the test container. Production keeps running.
