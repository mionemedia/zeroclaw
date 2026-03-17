# ZeroClaw Marketing Agent — Get Pairing Code
# Double-click this file or run it in PowerShell to see the current pairing codes.

Write-Host "`n=== ZeroClaw Pairing Codes ===" -ForegroundColor Cyan
Write-Host ""

$logs = docker logs zeroclaw-marketing --tail 30 2>&1 | Out-String

# Gateway pairing code
if ($logs -match '│\s+(\d{6})\s+│') {
    Write-Host "  Web Dashboard code:  $($Matches[1])" -ForegroundColor Green
} else {
    Write-Host "  Web Dashboard code:  (already paired or container not running)" -ForegroundColor Yellow
}

# Telegram bind code
if ($logs -match 'One-time bind code:\s+(\d{6})') {
    Write-Host "  Telegram /bind code: $($Matches[1])" -ForegroundColor Green
} else {
    Write-Host "  Telegram /bind code: (already bound or not configured)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Container status:" -ForegroundColor Cyan
docker ps --filter "name=zeroclaw-marketing" --format "  {{.Names}}  {{.Status}}"
Write-Host ""
Read-Host "Press Enter to close"
