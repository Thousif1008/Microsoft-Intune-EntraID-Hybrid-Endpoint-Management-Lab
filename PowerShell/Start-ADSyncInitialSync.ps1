# Start-ADSyncInitialSync.ps1
#
# An Initial Sync is the full synchronization cycle.
# I used this for the first/full sync stage of the lab.
#
# Run it on the server where Microsoft Entra Connect is installed.
# This does not create the users by itself; it tells Entra Connect to start
# a full synchronization of the configured scope.

Import-Module ADSync

Write-Host "Starting an Initial Sync..." -ForegroundColor Cyan

$result = Start-ADSyncSyncCycle -PolicyType Initial

# Show the result returned by Entra Connect. In the lab the expected result was Success.
$result | Format-List
