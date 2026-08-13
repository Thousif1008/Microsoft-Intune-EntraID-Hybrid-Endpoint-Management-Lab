# Get-ADSyncScheduler.ps1
#
# This is just a quick check for the Microsoft Entra Connect scheduler.
# I used it to see whether the scheduler was enabled and when the next sync
# was expected to run.
#
# Run this on the server where Microsoft Entra Connect is installed.

Import-Module ADSync

# Get-ADSyncScheduler returns the current scheduler configuration.
Get-ADSyncScheduler |
Select-Object SyncCycleEnabled,
    StagingModeEnabled,
    SchedulerSuspended,
    CurrentlyEffectiveSyncCycleInterval,
    NextSyncCycleStartTimeInUTC |
Format-List
