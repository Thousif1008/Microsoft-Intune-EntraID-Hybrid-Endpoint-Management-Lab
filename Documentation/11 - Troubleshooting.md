# Troubleshooting and Issues Faced During the Lab

These are the main issues I ran into while building and testing the lab. I kept this list to problems that actually needed troubleshooting or took extra time to figure out.

## 1. AD UPN did not match the Microsoft Entra identity

At the beginning, the users in Active Directory were using the `@thousiflab.com` UPN, while the Microsoft Entra accounts were using the `@thousiflab.onmicrosoft.com`.

The on-premises account was still using the @thousiflab.com suffix while the Microsoft Entra identity used the @thousiflab.onmicrosoft.com namespace.

I fixed this by adding `thousiflab.onmicrosoft.com` as an alternative UPN suffix in Active Directory and then updating the users with PowerShell.

After that, the users had the correct UPN format and were ready for the synchronization workflow.

## 2. UPN changes were not immediately visible in Microsoft Entra

After changing the UPNs in Active Directory, the changes did not appear in Microsoft Entra immediately.

I manually started an Entra Connect delta synchronization using:

```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```

The synchronization completed successfully, and the updated UPNs then appeared in Microsoft Entra.

The UPN change did not appear in Microsoft Entra until the next synchronization.

## 3. Ahmed was not suitable for the hybrid identity testing

Ahmed was a cloud-created account, so he was not the right account for testing the on-premises Active Directory to Microsoft Entra synchronization workflow.

I switched to `areddy` as the main test account because that account was created in the on-premises Active Directory and was the one used for the later synchronization, Intune, Microsoft 365 and Conditional Access work.

## 4. BitLocker would not enable because Secure Boot was not enabled

While testing BitLocker on the Windows VM, BitLocker would not enable.

After checking the VM configuration, I found that Secure Boot was not enabled.

I enabled Secure Boot in VMware and then continued with the BitLocker setup. After that, I was able to add the TPM protector and complete the encryption process.

The final result showed the drive fully encrypted with BitLocker protection enabled.

## 5. Intune Tenant Status showed 401 / No Permission

When I opened **Intune admin center → Tenant administration → Tenant status**, the page showed:

> You don't have access

The error details showed:

> Error code: 401  
> Details: No Permission

At first, I thought this was an Intune permissions issue.

I found that the problem was related to the licensing available in the tenant. I started the **Microsoft Entra ID P1 Trial**, and after the trial was added, the problem was resolved.

### Evidence

![Intune Tenant Status showing 401 No Permission](../Screenshots/11%20-%20Troubleshooting/44-Intune%20Tenant%20Status%20No%20Permission.png)

![Microsoft Entra ID P1 Trial Added](../Screenshots/11%20-%20Troubleshooting/05%20-%20Entra%20ID%20P1%20Trial%20Added.png)

## 6. Outlook would not open because the account had no Exchange Online license

While testing Outlook with the `areddy` account, Outlook would not open correctly and returned a server error.

The error included:

`OwaNoMailboxAndNoLicenseAssignedException`

The same problem appeared when I checked the account on the PC, so it was not an Android-only problem.

The actual issue was that `areddy` did not have an Exchange Online mailbox because the required Microsoft 365 license was missing.

I assigned **Microsoft 365 Business Basic** to `areddy` and waited for the mailbox to provision.

After the license and mailbox were available, Outlook started working on the PC and on the Android Work Profile.

### Evidence

![Outlook No License Error](../Screenshots/11%20-%20Troubleshooting/109-Outlook-No-License-Error.png)

This took some time to figure out because it initially looked like an Outlook or authentication problem, but the actual cause was the missing Exchange Online license.

## 7. Android apps showed "Waiting for install" even though they were already installed

This was one of the biggest troubleshooting issues in the lab and took me roughly a day to figure out.

The applications were already installed on the Android Work Profile, but Intune was showing states such as **Waiting for install**.

During the troubleshooting, I removed Authenticator because I thought it might be related. I later added it back, and the status changed temporarily, but that still did not solve the problem.

I then compared the applications actually present on the Android Work Profile with the applications assigned as **Required** in Intune.

That is where I found the pattern.

**Intune Company Portal was installed on the Android device, but it was not assigned as a Required app in Intune.** The apps on the Work Profile and the Required app assignments in Intune were not fully aligned.

I corrected the Required app assignments so that the apps on the Android Work Profile matched the applications Intune was expected to manage, including Company Portal.

After that, within roughly **5–10 minutes**, the application statuses in Intune changed to **Installed**.

I found the issue by comparing the device state with the Intune assignments and noticing the pattern rather than from a single error message.

The earlier Edge and Outlook reporting problems were part of the same Android application assignment/reporting issue, so I kept them together here instead of listing them as separate problems.

The practical fix was simple: when an Android app is already installed but Intune continues to show **Waiting for install**, check whether that app is assigned as **Required** in Intune.

## 8. Security Defaults had to be disabled before Conditional Access could be enforced

I created the Android Conditional Access policy in **Report-only** first so I could test it without immediately enforcing it.

The policy could be evaluated in Report-only, but I could not switch it to **On** while Security Defaults were enabled.

I disabled **Security Defaults** and then changed the Conditional Access policy to **On**.

After that, I was able to continue with the actual Conditional Access testing.

## 9. The Global Administrator lost access to Microsoft Authenticator

I lost access to Microsoft Authenticator on my main Global Administrator account...

I lost access to Microsoft Authenticator on my main Global Administrator account, and I had not created a passkey for that account.

After I signed out and tried to sign back in, Microsoft asked for Authenticator verification, but my Authenticator was no longer working.

The problem was worse because I was the only Global Administrator at that point.

I remembered that the account was still signed in on **DC01**. From there, I gave the `areddy` account the **Global Administrator** role.

I then signed in as `areddy`, which already had a working passkey and Authenticator.

When I checked the authentication methods for my original account, the **Add authentication method** option was greyed out, so I could not simply add another method directly to that account.

Instead, I used `areddy` to manage the authentication methods and added **SMS** using my phone number.

I then used SMS authentication to recover access to the original administrator account.

### Evidence

![Global Administrator Add Authentication Method Greyed Out](../Screenshots/11%20-%20Troubleshooting/110-GlobalAdmin-Add-Auth-Method-Greyed-Out.png)

I was able to recover the account using the second Global Administrator and SMS authentication.

## 10. I could not initially identify the correct Brave uninstall command

When configuring the Brave Win32 application in Intune, I needed the correct uninstall command for the Brave installation already on the client.

The problem was not that the uninstall command was wrong. I simply could not initially find the registered uninstall command.

I used PowerShell to check the Windows uninstall registry entries and find the installed Brave version and its registered uninstall string:

```powershell
Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*","HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*","HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object {$_.DisplayName -like "*Brave*"} | Select-Object DisplayName,DisplayVersion,UninstallString
```

The result showed:

- **DisplayName:** Brave
- **DisplayVersion:** `151.1.93.134`
- **UninstallString:** the registered Brave `setup.exe` uninstall path

I then used:

```text
"C:\Program Files\BraveSoftware\Brave-Browser\Application\151.1.93.134\Installer\setup.exe" --uninstall
```

I also checked the same Brave version on another laptop and got the same uninstall command,That gave me confidence that the command matched the installed version and the default path.

I used the uninstall information already registered in Windows instead of guessing the command.