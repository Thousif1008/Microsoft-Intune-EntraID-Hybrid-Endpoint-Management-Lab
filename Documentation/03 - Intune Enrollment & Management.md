# 03 - Intune Enrollment & Management

I moved `WIN11-CLIENT01` from the on-premises Active Directory environment into Microsoft Intune management. This stage covered the tenant MDM configuration, automatic enrollment, the Group Policy used for enrollment, the user's licensing and group membership, the Windows enrollment process, and the final MDM checks.

One important detail is the UPN change that happened during the lab. Some earlier screenshots still show `areddy@thousiflab.com` because they were taken before the UPN was changed to the Microsoft Entra namespace. Later screenshots show `areddy@thousiflab.onmicrosoft.com`. The screenshots are kept in the state in which they were actually taken.

---

## 01 - MDM Auto Enrollment

I first checked that Microsoft Intune was configured as the Mobile Device Management authority for the tenant.

The Intune tenant status showed:

- **Tenant name:** `thousiflab.onmicrosoft.com`
- **Tenant location:** Asia Pacific (India) 01
- **MDM authority:** Microsoft Intune
- **Account status:** Active
- **Service release:** 2607
- **Total enrolled devices:** 0
- **Total Intune licenses:** 25

At this stage there were no enrolled devices because the Windows client had not completed Intune enrollment yet.

![Intune Tenant Status](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/01%20-%20MDM%20Auto%20Enrollment/04%20-%20Intune%20Tenant%20Status%20Active.png)

*Figure 1 — Intune tenant status showing Microsoft Intune as the MDM authority.*

The Windows automatic enrollment settings were then configured in Intune.

The configuration used a limited user scope rather than applying enrollment to everyone. The screenshot shows **Some** selected for the MDM user scope and **1 group selected**.

The MDM endpoints were also present:

- **MDM terms of use URL:** `https:portal.manage.microsoft.comTermsofUse.aspx`
- **MDM discovery URL:** `https:enrollment.manage.microsoft.comenrollmentserverdiscovery.svc`
- **Disable MDM enrollment when adding a work or school account on Windows:** No
- **MDM compliance URL:** `https:portal.manage.microsoft.com?portalAction=Compliance`

Windows Information Protection was not being used here, with the WIP user scope set to **None**.

![Intune Automatic Enrollment](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/01%20-%20MDM%20Auto%20Enrollment/06%20-%20Intune%20Automatic%20Enrollment.png)

*Figure 2 — Intune automatic MDM enrollment configuration.*

Automatic MDM enrollment was also configured through the on-premises Group Policy.

The Group Policy Management Editor showed:

**Enable automatic MDM enrollment using default Azure AD credentials:** Enabled

The separate **Disable MDM Enrollment** setting remained **Not configured**.

![GPO Intune Auto Enrollment](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/01%20-%20MDM%20Auto%20Enrollment/21-GPO%20Intune%20Auto%20Enrollment.png)

*Figure 3 — Group Policy configured to enable automatic MDM enrollment.*

The screenshot folder structure for this stage was also captured and shows the four parts used for the Intune enrollment documentation:

- MDM Auto Enrollment
- Intune Enrollment
- Device Management
- MDM Verification

![Intune Enrollment Group](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/02%20-%20Intune%20Enrollment/18-Intune%20Enrollment%20Group.png)

*Figure 4 — Screenshot structure used for the Intune Enrollment & Management stage.*

---

## 02 - Intune Enrollment

Before enrolling the Windows client, I checked the main test account in Microsoft Entra ID.

The account was **Arjun Reddy**, and the license page showed:

- **Intune:** Active
- **Azure Active Directory Premium P1:** Active

Both licenses were assigned directly to the user.

![Arjun Reddy Intune License](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/02%20-%20Intune%20Enrollment/19-Intune%20User%20License.png)

*Figure 5 — Arjun Reddy had active Intune and Azure AD Premium P1 licenses.*

The `GRP-Intune-Users` group was also checked. At that point, the group contained two members:

- Ahmed Khan
- Arjun Reddy

The screenshot still showed Arjun Reddy with the earlier UPN:

`areddy@thousiflab.com`

This screenshot was taken before the UPN was changed to the Microsoft Entra namespace used later in the synchronization and SSO stages.

![Intune Enrollment Group](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/02%20-%20Intune%20Enrollment/18-Intune%20Enrollment%20Group.png)

*Figure 6 — `GRP-Intune-Users` containing Ahmed Khan and Arjun Reddy.*

The Windows client was then checked before Intune enrollment.

The signed-in user was **Arjun Reddy**, while the machine was still connected to the on-premises `THOUSIFLAB` AD domain. There was no separate Intune management connection shown yet.

![Windows Pre Intune Enrollment](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/02%20-%20Intune%20Enrollment/20-Windows%20Pre%20Intune%20Enrollment.png)

*Figure 7 — Windows client state before Intune enrollment.*

The enrollment process was then triggered from Windows through the Enterprise Management scheduled tasks.

The `PushLaunch` task was shown running successfully and was used to trigger the enrollment activity.

![Intune PushLaunch Success](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/02%20-%20Intune%20Enrollment/28-Intune%20PushLaunch%20Success.png)

*Figure 8 — `PushLaunch` task completing successfully during the Intune enrollment process.*

---

## 03 - Device Management

After enrollment, the Windows client appeared in the Microsoft Intune device list.

The device shown was:

`WIN11-CLIENT01`

The Intune device view showed:

- **Managed by:** Intune
- **Ownership:** Corporate
- **Compliance:** Compliant
- **OS:** Windows
- **OS version:** `10.0.26200.8875`
- **Primary user UPN:** `areddy@thousiflab.onmicrosoft.com`

The device also had a recorded last check-in time.

![Intune Client Device](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/03%20-%20Device%20Management/30-Intune%20Client%20Device.png)

*Figure 9 — `WIN11-CLIENT01` appearing in Intune as a corporate, compliant device managed by Intune.*

I then checked the Windows client from the **Managed by Thousiflab** page.

The page showed that the organization was managing settings and applications through MDM, with **Security** listed under the areas managed by Thousiflab.

The connection information showed the Intune management server and an exchange ID.

The **Device sync status** showed:

**The sync was successful**

with the recorded sync time:

`08-08-2026 23:26:02`

![Windows Intune Managed Sync Success](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/03%20-%20Device%20Management/29-Windows%20Intune%20Managed%20Sync%20Success.png)

*Figure 10 — Windows showing that the device was managed by Thousiflab and the Intune device sync completed successfully.*

At this point the client was being actively managed through Intune rather than only being a member of the on-premises AD domain.

---

## 04 - MDM Verification

The final verification was performed from the Windows client with:

```cmd
dsregcmd status
```

The SSO section showed:

```text
AzureAdPrt : YES
```

The same output also showed:

```text
EnterprisePrt : NO
OnPremTgt : NO
CloudTgt : YES
```

The diagnostic information identified the account being used for the session:

```text
Executing Account Name : THOUSIFLAB\areddy, areddy@thousiflab.onmicrosoft.com
```

The key sign-in check passed:

```text
KeySignTest : PASSED
```

The diagnostic section also showed that several device properties had been updated through MDM:

```text
DisplayNameUpdated : Managed by MDM
OsVersionUpdated   : Managed by MDM
HostNameUpdated    : YES
```

The displayed name and OS version were reported as managed by MDM, and the host name update was also confirmed.

![DSREGCMD MDM Verification](../Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/04%20-%20MDM%20Verification/33-DSREGCMD%20MDM%20Verification.png)

*Figure 11 — `dsregcmd status` confirming the Azure AD PRT and MDM-related device updates.*

---

## Result

The Intune enrollment and management process was:

`thousiflab.com` on-premises AD

→ automatic MDM enrollment configured in Intune

→ MDM auto-enrollment enabled through Group Policy

→ Arjun Reddy licensed for Intune and Entra ID P1

→ `GRP-Intune-Users` used for the enrollment scope

→ Windows client enrollment triggered through the Enterprise Management task

→ `WIN11-CLIENT01` appeared in Intune

→ device showed **Managed by Intune**

→ device showed **Corporate** ownership

→ device showed **Compliant**

→ Windows reported a successful Intune management sync

→ `dsregcmd status` confirmed `AzureAdPrt : YES`

→ `KeySignTest : PASSED`

→ MDM-related device updates were confirmed

The earlier screenshots showing `areddy@thousiflab.com` belong to the stage before the UPN update. The later Intune and MDM screenshots show the synchronized identity as:

`areddy@thousiflab.onmicrosoft.com`

This completed the Windows MDM enrollment and verification stage of the lab.