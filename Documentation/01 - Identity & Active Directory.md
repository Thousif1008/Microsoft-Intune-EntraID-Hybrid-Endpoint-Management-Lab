# 01 - Identity & Active Directory
 
I started by setting up the Active Directory and Microsoft Entra identity pieces needed for the rest of the lab.
 
---
 
## 01 - Entra ID User Management
 
Ahmed Khan was created directly in Microsoft Entra ID as a Member account and was used during the initial cloud-side identity and group setup.
 
The account details were:
 
- **Display name:** Ahmed Khan 
- **UPN:** `ahmed.khan@thousiflab.onmicrosoft.com` 
- **User type:** Member 
- **Account status:** Enabled 
 
![Ahmed Khan Entra User](./01%20-%20Entra%20ID%20User%20Management/10%20-%20Ahmed%20Khan%20Entra%20User%282%29.png) 
 
*Figure 1 — Ahmed Khan user account in Microsoft Entra ID.* 
 
Ahmed was a cloud-created account and was not used for the later on-premises Windows client and Intune workflow. The main account for that part of the lab was `areddy`, which was created in on-premises Active Directory and later synchronized to Microsoft Entra ID. 
 
---
 
## 02 - Entra Device Join & Registration 
 
The Microsoft Entra device join settings were configured so that device joining was limited to selected users rather than being open to everyone. 
 
The selected group was: 
 
`GRP-Intune-Users` 
 
![Entra Device Join Group Selection](./02%20-%20Entra%20Device%20Join%20%26%20Registration/07%20-%20Entra%20Device%20Join%20Group%20Selection%283%29.png) 
 
*Figure 2 — Group selected for Microsoft Entra device joining.* 
 
The device join settings showed the following values: 
 
- **Users may join devices to Microsoft Entra:** Selected 
- **Selected members:** 1 member selected 
- **Users may register their devices with Microsoft Entra:** None 
- **Require MFA to register or join devices with Microsoft Entra:** No 
- **Maximum number of devices per user:** 50 
 
![Entra Device Join Settings](./02%20-%20Entra%20Device%20Join%20%26%20Registration/08%20-%20Entra%20Device%20Join%20Settings%283%29.png) 
 
*Figure 3 — Microsoft Entra device join and registration settings.* 
 
The Windows client was also checked from **Settings → Accounts → Access work or school**. At this point, the machine was connected to the local `thousiflab.com` Active Directory domain. 
 
![Windows 11 Current State](./02%20-%20Entra%20Device%20Join%20%26%20Registration/09%20-%20Windows%2011%20Current%20State%283%29.png) 
 
*Figure 4 — Windows client connected to the on-premises Active Directory domain.* 
 
---
 
## 03 - Entra ID Licensing 
 
Microsoft Entra ID P1 was added as a trial for the lab. 
 
The Microsoft 365 admin center showed: 
 
**Microsoft Entra ID P1 Trial** 
 
with a quantity of: 
 
**25 licenses** 
 
![Entra ID P1 Trial Added](./03%20-%20Entra%20ID%20Licensing/05%20-%20Entra%20ID%20P1%20Trial%20Added%284%29.png) 
 
*Figure 5 — Microsoft Entra ID P1 trial added to the tenant.* 
 
The trial added 25 Entra ID P1 licenses to the tenant. 
 
---
 
## 04 - UPN Suffix 
 
The on-premises Active Directory domain remained: 
 
`thousiflab.com` 
 
An additional UPN suffix was added: 
 
`thousiflab.onmicrosoft.com` 
 
The suffix was configured through: 
 
**Active Directory Domains and Trusts → UPN Suffixes** 
 
![AD UPN Suffix Configured](./04%20-%20UPN%20Suffix/22-AD%20UPN%20Suffix%20Configured%283%29.png) 
 
*Figure 6 — `thousiflab.onmicrosoft.com` added as an alternative UPN suffix.* 
 
I added this suffix so the AD users could use the same UPN namespace as the Microsoft Entra tenant before sync. 
 
---
 
## 05 - AD User Configuration 
 
The main user for the later Windows, Entra Connect, SSO and Intune workflow was **Arjun Reddy**. 
 
The Active Directory account used: 
 
- **SAM account name:** `areddy` 
- **Original UPN:** `areddy@thousiflab.com` 
- **Pre-Windows 2000 logon:** `THOUSIFLAB\areddy` 
 
The account was located in the Enterprise user structure in Active Directory. 
 
![AD User UPN Before Change](./05%20-%20AD%20User%20Configuration/23-AD%20User%20UPN%20Before%20Change%283%29.png) 
 
*Figure 7 — Arjun Reddy's Active Directory account before the UPN change.* 
 
This was the on-premises account I used for the later synchronization and Intune work. 
 
---
 
## 06 - UPN Update 
 
The existing AD users using the old `@thousiflab.com` suffix were prepared for the Microsoft Entra namespace. 
 
Before making the change, I checked the existing user UPNs with PowerShell. 
 
![AD Users Before UPN Update](./06%20-%20UPN%20Update/24-AD%20Users%20UPN%20Before%20Update%20Script%284%29.png) 
 
*Figure 8 — Active Directory users and their original UPN values before the update.* 
 
The UPN update was performed with PowerShell: 
 
```powershell 
Get-ADUser -Filter * -Properties UserPrincipalName | 
Where-Object {$_.UserPrincipalName -like "*@thousiflab.com"} | 
ForEach-Object { 
    Set-ADUser $_ -UserPrincipalName ($_.SamAccountName + "@thousiflab.onmicrosoft.com") 
} 
``` 
 
The script changed matching users to the new UPN suffix while keeping their existing `SamAccountName`. 
 
For the main test account, the change was: 
 
`areddy@thousiflab.com` 
 
to: 
 
`areddy@thousiflab.onmicrosoft.com` 
 
The same change was applied to the other matching users. 
 
---
 
## 07 - UPN Verification 
 
I checked the users again after the update. The accounts now showed the new: 
 
`@thousiflab.onmicrosoft.com` 
 
suffix. 
 
![AD Users After UPN Update](./07%20-%20UPN%20Verification/25-AD%20Users%20UPN%20After%20Update%283%29.png) 
 
*Figure 9 — Active Directory users after the PowerShell UPN update.* 
 
For the main test account, the final identity was: 
 
`areddy@thousiflab.onmicrosoft.com` 
 
The account was ready for the Microsoft Entra Connect synchronization stage. 
 
---
 
## Result 
 
The AD and Microsoft Entra identity setup was completed. The on-premises domain remained `thousiflab.com`, while the Microsoft Entra namespace used for the main synchronized account was `thousiflab.onmicrosoft.com`. Ahmed remained a cloud-only account, and `areddy` was prepared with the updated UPN for the next stage of the lab: Microsoft Entra Connect, synchronization, SSO and Hybrid Microsoft Entra Join.