# Get-BraveUninstallCommand.ps1
#
# I used this when I needed the uninstall command for the Brave installation
# that was already on the Windows client.
#
# Instead of guessing the command, this checks the Windows uninstall registry
# entries and shows the version and registered uninstall string.
#
# Run it on the Windows client where Brave is installed.

$UninstallPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

Get-ItemProperty $UninstallPaths -ErrorAction SilentlyContinue |
Where-Object { $_.DisplayName -like "*Brave*" } |
Select-Object DisplayName,DisplayVersion,UninstallString |
Format-List

# In the lab the installed version was 151.1.93.134 and the registered
# uninstall command pointed to Brave's setup.exe under the application folder.
