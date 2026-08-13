# Trigger-AutomaticDeviceJoin.ps1
#
# I used this on the Windows client when the machine was already joined to
# the local AD domain but had not completed Hybrid Microsoft Entra Join yet.
#
# The command below starts Windows' built-in Automatic-Device-Join task.
# Starting the task only means Windows launched it successfully. It does not
# by itself prove that the Hybrid Join worked. I checked that separately with
# dsregcmd /status.

$TaskName = "\Microsoft\Windows\Workplace Join\Automatic-Device-Join"

Write-Host "Starting the Automatic-Device-Join task..." -ForegroundColor Cyan

Start-ScheduledTask -TaskName "Automatic-Device-Join" -TaskPath "\Microsoft\Windows\Workplace Join\"

Write-Host "Task start requested." -ForegroundColor Green
Write-Host "Wait a short time, then run Verify-DeviceRegistration.ps1."
