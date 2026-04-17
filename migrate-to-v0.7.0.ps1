# ZeroClaw v0.7.0 Migration Script
# Migrates from deploy/marketing/ structure to ~/.zeroclaw/ structure

param(
    [switch]$DryRun,
    [switch]$Force
)

Write-Host "🦀 ZeroClaw v0.7.0 Migration Script" -ForegroundColor Cyan
Write-Host ""

# Paths
$oldConfigDir = "H:\GitHub\zeroclaw-main\deploy\marketing"
$newConfigDir = "$env:USERPROFILE\.zeroclaw"
$backupDir = "$env:USERPROFILE\.zeroclaw-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

# Check if old config exists
if (!(Test-Path "$oldConfigDir\config.toml")) {
    Write-Host "❌ Old config not found at: $oldConfigDir\config.toml" -ForegroundColor Red
    exit 1
}

Write-Host "📋 Migration Plan:" -ForegroundColor Yellow
Write-Host "  FROM: $oldConfigDir"
Write-Host "  TO:   $newConfigDir"
Write-Host ""

# Backup existing config if it exists
if (Test-Path "$newConfigDir\config.toml") {
    Write-Host "⚠️  Existing config found in $newConfigDir" -ForegroundColor Yellow
    
    if (!$Force -and !$DryRun) {
        $response = Read-Host "Create backup and overwrite? (y/N)"
        if ($response -ne "y") {
            Write-Host "❌ Migration cancelled" -ForegroundColor Red
            exit 0
        }
    }
    
    if (!$DryRun) {
        Write-Host "📦 Creating backup: $backupDir" -ForegroundColor Green
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        Copy-Item "$newConfigDir\*" $backupDir -Recurse
    }
}

# Create new config directory
if (!$DryRun) {
    Write-Host "📁 Creating directory: $newConfigDir" -ForegroundColor Green
    New-Item -ItemType Directory -Path $newConfigDir -Force | Out-Null
}

# Migrate files
$filesToMigrate = @(
    @{Source="config.toml"; Dest="config.toml"; Required=$true}
    @{Source="SOUL.md"; Dest="SOUL.md"; Required=$false}
    @{Source="BRIEF.md"; Dest="BRIEF.md"; Required=$false}
)

foreach ($file in $filesToMigrate) {
    $sourcePath = Join-Path $oldConfigDir $file.Source
    $destPath = Join-Path $newConfigDir $file.Dest
    
    if (Test-Path $sourcePath) {
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would copy: $($file.Source)" -ForegroundColor Cyan
        } else {
            Write-Host "  ✓ Copying: $($file.Source)" -ForegroundColor Green
            Copy-Item $sourcePath $destPath -Force
        }
    } elseif ($file.Required) {
        Write-Host "  ❌ Missing required file: $($file.Source)" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "📝 Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Build ZeroClaw v0.7.0:"
Write-Host "     cd H:\GitHub\zeroclaw-main"
Write-Host "     cargo build --release --features telegram"
Write-Host ""
Write-Host "  2. Create new docker-compose.yml:"
Write-Host "     Copy H:\GitHub\zeroclaw-main\docker-compose.yml"
Write-Host "     Update volume mount to: ~/.zeroclaw:/zeroclaw-data/.zeroclaw"
Write-Host ""
Write-Host "  3. Test the container:"
Write-Host "     docker compose -f docker-compose-test.yml up -d"
Write-Host ""
Write-Host "  4. Verify bot works in Telegram"
Write-Host ""
Write-Host "  5. If successful, update production:"
Write-Host "     docker compose -f deploy/marketing/docker-compose.yml down"
Write-Host "     docker compose up -d"
Write-Host ""

if ($DryRun) {
    Write-Host "✓ Dry run complete - no changes made" -ForegroundColor Cyan
} else {
    Write-Host "✓ Migration complete!" -ForegroundColor Green
    if (Test-Path $backupDir) {
        Write-Host "  Backup saved to: $backupDir" -ForegroundColor Gray
    }
}
