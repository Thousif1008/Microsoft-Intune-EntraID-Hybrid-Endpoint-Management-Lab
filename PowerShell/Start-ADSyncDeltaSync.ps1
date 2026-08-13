# Start-ADSyncDeltaSync.ps1
#
# A Delta Sync is the smaller/faster sync used for recent changes.
# I used this after changing users and UPNs so the changes were sent to
# Microsoft Entra without starting another full synchronization.
#
# Run it on the server where Microsoft Entra Connect is installed.

Import-Module ADSync

Write-Host "Starting a Delta Sync..." -ForegroundColor Cyan

$result = Start-ADSyncSyncCycle -PolicyType Delta

# In the lab this returned Success when the synchronization completed normally.
$result | Format-List
