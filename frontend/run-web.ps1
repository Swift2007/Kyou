# Launch Kyou on Chrome web with the required env defines.
# Usage: .\run-web.ps1   (from C:\Projects\Kyou\frontend)
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $scriptDir

if (!(Test-Path 'env.json')) {
    Write-Error 'env.json not found in frontend/. Copy env.json.example to env.json first.'
    exit 1
}

Write-Host "Starting Kyou on Chrome web..." -ForegroundColor Cyan
Write-Host "  cwd: $scriptDir" -ForegroundColor Gray
Write-Host "  defines: --dart-define-from-file=env.json" -ForegroundColor Gray
Write-Host ""

flutter run -d chrome --dart-define-from-file=env.json
