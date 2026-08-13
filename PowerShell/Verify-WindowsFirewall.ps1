# Verify-WindowsFirewall.ps1
#
# I used the Windows Firewall state as part of the Windows compliance test.
# The normal/compliant state had all three firewall profiles enabled.
#
# This script only checks the current state. It does not turn the firewall
# off or change anything on the machine.

Write-Host "Current Windows Firewall profile state:" -ForegroundColor Cyan

Get-NetFirewallProfile |
Select-Object Name,Enabled,DefaultInboundAction,DefaultOutboundAction |
Format-Table -AutoSize

Write-Host ""
Write-Host "For the compliant state, check that Domain, Private and Public are enabled."
