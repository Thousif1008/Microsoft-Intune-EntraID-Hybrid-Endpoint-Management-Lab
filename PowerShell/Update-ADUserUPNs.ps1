# Update-ADUserUPNs.ps1
#
# I used this when the AD users were still using @thousiflab.com.
# The lab needed the users to use the Microsoft Entra namespace:
# @thousiflab.onmicrosoft.com
#
# The script keeps the existing SAM account name and changes only the UPN suffix.
# Run this on the domain controller in an elevated PowerShell window.
#
# Before using the change, you can preview the affected users with:
# Get-ADUser -Filter * -Properties UserPrincipalName |
# Where-Object {$_.UserPrincipalName -like "*@thousiflab.com"} |
# Select-Object SamAccountName,UserPrincipalName

Import-Module ActiveDirectory

$OldSuffix = "@thousiflab.com"
$NewSuffix = "@thousiflab.onmicrosoft.com"

Get-ADUser -Filter * -Properties UserPrincipalName |
Where-Object { $_.UserPrincipalName -like "*$OldSuffix" } |
ForEach-Object {
    $NewUPN = $_.SamAccountName + $NewSuffix

    # Show what is being changed so the output is easy to follow.
    Write-Host "Updating $($_.SamAccountName): $($_.UserPrincipalName) -> $NewUPN"

    Set-ADUser -Identity $_ -UserPrincipalName $NewUPN
}

# Check the result after the update.
Write-Host "`nUPN update completed. Current UPNs:" -ForegroundColor Green
Get-ADUser -Filter * -Properties UserPrincipalName |
Select-Object SamAccountName,UserPrincipalName |
Format-Table -AutoSize
