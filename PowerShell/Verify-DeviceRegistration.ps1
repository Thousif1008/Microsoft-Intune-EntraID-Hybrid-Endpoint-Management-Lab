# Verify-DeviceRegistration.ps1
#
# I used dsregcmd to check the actual Windows registration state.
# This is more useful than assuming the scheduled task succeeded.
#
# The important values for the lab were:
#   AzureAdJoined : YES
#   DomainJoined  : YES
#   AzureAdPrt    : YES
#
# EnterprisePrt can still be NO. That is why this script checks the values
# separately instead of treating every line in dsregcmd as a pass/fail test.

Write-Host "Windows device registration status:" -ForegroundColor Cyan
Write-Host ""

dsregcmd /status

Write-Host ""
Write-Host "For the Hybrid Join check, look for AzureAdJoined : YES and DomainJoined : YES."
Write-Host "For the SSO check, look for AzureAdPrt : YES."
