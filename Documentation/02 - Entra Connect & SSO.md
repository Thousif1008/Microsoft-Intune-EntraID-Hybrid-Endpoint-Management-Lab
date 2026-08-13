# 02 - Entra Connect & SSO

I connected the on-premises `thousiflab.com` Active Directory environment to Microsoft Entra ID with Entra Connect, then verified synchronization, Hybrid Microsoft Entra Join and SSO on the Windows client.

The on-premises Active Directory domain is:

`thousiflab.com`

The Microsoft Entra tenant uses:

`thousiflab.onmicrosoft.com`

The main synchronized test identity used in the lab is:

`areddy@thousiflab.onmicrosoft.com`

---

## 01 - Entra Connect Configuration

I configured Microsoft Entra Connect to connect the local `thousiflab.com` Active Directory environment to Microsoft Entra ID.

### Ahmed Khan

Ahmed Khan was present in Microsoft Entra ID as an enabled Member account.

**UPN:** `ahmed.khan@thousiflab.onmicrosoft.com`  
**User type:** Member  
**Account status:** Enabled

At this stage, the account had no assigned roles, applications, or licenses.

![Ahmed Khan - Microsoft Entra ID](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/01%20-%20Entra%20Connect%20Configuration/01%20-%20Ahmed%20Khan%20Entra%20ID%20User.png)

### GRP-Intune-Users

The `GRP-Intune-Users` group was checked and Ahmed Khan was shown as a direct member.

I reused this group for the Intune assignments later in the lab.

![GRP-Intune-Users - Ahmed Khan Member](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/01%20-%20Entra%20Connect%20Configuration/02%20-%20GRP-Intune-Users%20Ahmed%20Khan%20Member.png)

### Administrator roles

The main administrator account was checked in Microsoft Entra ID.

**Administrator:** Thousif Raza Mohammed

The account had the following roles:

- Global Administrator
- Intune Administrator

![Thousif Raza Mohammed - Assigned Roles](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/01%20-%20Entra%20Connect%20Configuration/03%20-%20Thousif%20Raza%20Assigned%20Global%20and%20Intune%20Administrator%20Roles.png)

### Hybrid Microsoft Entra Join configuration

Microsoft Entra Connect was configured for Hybrid Microsoft Entra Join.

The wizard completed the Hybrid Microsoft Entra Join configuration and indicated that additional steps were still required on the Windows device before the device itself would complete the Hybrid Join process.

![Entra Connect Hybrid Join Configuration](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/01%20-%20Entra%20Connect%20Configuration/14-Entra%20Connect%20Hybrid%20Join%20Configuration.png)

---

## 02 - Synchronization

I then checked the synchronization service on the server.

### Microsoft Azure AD Sync service

The **Microsoft Azure AD Sync** service was running and configured to start automatically.

![Microsoft Azure AD Sync service](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/02%20-%20Synchronization/12-Entra%20Connect%20Sync%20Status.png)

### Delta synchronization

A manual delta synchronization was started from PowerShell with:

~~~powershell
Start-ADSyncSyncCycle -PolicyType Delta
~~~

The command returned:

~~~text
Result
------
Success
~~~

![Entra Connect Delta Sync](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/02%20-%20Synchronization/13-Entra%20Connect%20Delta%20Sync.png)

### Synchronization verification

I checked the synchronized users from PowerShell.

The output showed identities using the Microsoft Entra UPN suffix:

`@thousiflab.onmicrosoft.com`

Examples shown included:

- `aturner@thousiflab.onmicrosoft.com`
- `nscott@thousiflab.onmicrosoft.com`
- `acarter@thousiflab.onmicrosoft.com`
- `mocampbell@thousiflab.onmicrosoft.com`
- `fali2@thousiflab.onmicrosoft.com`
- `adm_domainadmin@thousiflab.onmicrosoft.com`
- `adm_serveradmin@thousiflab.onmicrosoft.com`
- `adm_helpdesk1@thousiflab.onmicrosoft.com`
- `adm_helpdesk2@thousiflab.onmicrosoft.com`
- `hybrid.test@thousiflab.onmicrosoft.com`
- `adm_security@thousiflab.onmicrosoft.com`

A further delta synchronization was performed and also returned **Success**.

![Entra Connect Sync Success](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/02%20-%20Synchronization/27-Entra%20Connect%20Sync%20Success.png)

The delta cycle completed successfully, and the users were synchronized to Microsoft Entra ID.

---

## 03 - SSO & PRT Verification

The Windows client was checked with:

~~~cmd
dsregcmd status
~~~

### Before Hybrid Microsoft Entra Join

The first check showed:

~~~text
AzureAdJoined : NO
EnterpriseJoined : NO
DomainJoined : YES
DomainName : THOUSIFLAB
~~~

At this point, the Windows machine was joined to the local Active Directory domain but was not yet Microsoft Entra joined.

![dsregcmd Before Entra Join](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/03%20-%20SSO%20%26%20PRT%20Verification/11-DSREGCMD%20Before%20Entra%20Join.png)

### Automatic Device Join

I manually ran the Windows Workplace Join task:

~~~cmd
schtasks Run TN "\Microsoft\Windows\Workplace Join\Automatic-Device-Join"
~~~

Windows returned:

~~~text
SUCCESS: Attempted to run the scheduled task
"\Microsoft\Windows\Workplace Join\Automatic-Device-Join".
~~~

![Automatic Device Join Task](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/04%20-%20Hybrid%20Join/15-Automatic%20Device%20Join%20Task.png)

### Hybrid Join confirmed locally

`dsregcmd status` was run again after the scheduled task completed.

The device now reported:

~~~text
AzureAdJoined : YES
EnterpriseJoined : NO
DomainJoined : YES
DomainName : THOUSIFLAB
~~~

The device was now Hybrid Microsoft Entra joined.

![dsregcmd Hybrid Joined](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/03%20-%20SSO%20%26%20PRT%20Verification/16-DSREGCMD%20Hybrid%20Joined.png)

### Primary Refresh Token verification

The SSO state was then checked in the same `dsregcmd status` output.

The important value was:

~~~text
AzureAdPrt : YES
~~~

The diagnostic section also showed:

~~~text
Executing Account Name : THOUSIFLAB\areddy, areddy@thousiflab.onmicrosoft.com
KeySignTest : PASSED
~~~

`AzureAdPrt : YES` and `KeySignTest : PASSED` confirmed the cloud SSO state for `areddy`.

![PRT and SSO Verification](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/03%20-%20SSO%20%26%20PRT%20Verification/26-DSREGCMD%20PRT%20Success.png)

One value remained:

~~~text
EnterprisePrt : NO
~~~

So the evidence supports a working Azure AD PRT and cloud SSO state, but not a successful Enterprise PRT.

---

## 04 - Hybrid Join

The final device state was checked from the Microsoft Entra admin center.

### WIN11-CLIENT01

The device list showed:

`WIN11-CLIENT01`

The device information showed:

- Enabled: Yes
- OS: Windows
- Version: `10.0.26200.8875`
- Join type: **Microsoft Entra hybrid joined**
- Owner: None
- MDM: None

![WIN11-CLIENT01 - Hybrid Microsoft Entra Joined](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/04%20-%20Hybrid%20Join/17-Entra%20Client01%20Hybrid%20Joined.png)

The Entra admin center also showed the device as **Microsoft Entra hybrid joined**.

### Automatic Device Join task

I also checked the `Automatic-Device-Join` task under:

`Task Scheduler Library → Microsoft → Windows → Workplace Join`

The task was present and showed the successful execution used during the join process.

![Automatic Device Join Task](../Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/04%20-%20Hybrid%20Join/15-Automatic%20Device%20Join%20Task.png)

The client initially reported:

`AzureAdJoined : NO`

After the task was run, the device changed to:

`AzureAdJoined : YES`

Microsoft Entra later reported the machine as:

**Microsoft Entra hybrid joined**

---

## Final Result

Entra Connect was configured and the delta synchronization completed successfully. The users were synchronized to Microsoft Entra ID, and `WIN11-CLIENT01` remained joined to the local `THOUSIFLAB` domain before becoming Microsoft Entra hybrid joined.

The SSO checks showed `AzureAdJoined : YES`, `DomainJoined : YES`, `AzureAdPrt : YES` and `KeySignTest : PASSED`. `EnterprisePrt : NO` remained unchanged.

This completed the identity synchronization and SSO foundation for the Intune and endpoint-management stages that followed.