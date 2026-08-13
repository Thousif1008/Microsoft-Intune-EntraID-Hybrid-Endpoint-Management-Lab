# Verify-BitLocker.ps1
#
# I used this to check the final BitLocker state on the Windows client.
# The script is read-only: it does not enable BitLocker or change protectors.
#
# The important things to check are that the OS volume is encrypted and that
# the protection status is On.

Write-Host "BitLocker status for the OS drive:" -ForegroundColor Cyan

Get-BitLockerVolume -MountPoint $env:SystemDrive |
Select-Object MountPoint,
    VolumeStatus,
    ProtectionStatus,
    EncryptionMethod,
    EncryptionPercentage,
    KeyProtector |
Format-List

Write-Host ""
Write-Host "Expected final state: VolumeStatus = FullyEncrypted and ProtectionStatus = On."
