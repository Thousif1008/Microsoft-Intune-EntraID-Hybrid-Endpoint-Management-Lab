\# Microsoft Intune \& Entra ID Hybrid Endpoint Management Lab



\*\*Mohammed Thousif Raza\*\*



I built this lab to put the identity, endpoint management, security, compliance and application pieces together instead of testing each Microsoft service separately.



The environment started with Windows Server 2022 Active Directory and was extended into Microsoft Entra ID and Microsoft Intune. From there, I worked through Hybrid Microsoft Entra Join, automatic MDM enrollment, endpoint security, BitLocker, compliance, Conditional Access, Win32 application deployment, Android Enterprise Work Profile, Android App Protection and Windows BYOD MAM.



The screenshots and device-side tests are the main evidence for the project. I used the Microsoft portals to configure the policies, but I also checked what actually happened on the Windows clients and Android device.



\---



\## Project Overview



The main flow of the lab was:



```text

Windows Server 2022 / Active Directory

&#x20;               |

&#x20;               v

&#x20;       Microsoft Entra Connect

&#x20;               |

&#x20;               v

&#x20;       Microsoft Entra ID

&#x20;               |

&#x20;               v

&#x20;  Hybrid Microsoft Entra Join

&#x20;               |

&#x20;               v

&#x20;      Microsoft Intune MDM

&#x20;               |

&#x20;       +-------+--------+

&#x20;       |                |

&#x20;       v                v

&#x20;  Windows 11       Android Enterprise

&#x20;  WIN11-CLIENT01    Work Profile

&#x20;       |                |

&#x20;       v                v

&#x20;Security /          Compliance /

&#x20;BitLocker           Conditional Access

&#x20;Compliance               |

&#x20;       |                v

&#x20;       v          Managed Applications

&#x20;Conditional Access      |

&#x20;       |                v

&#x20;       v          Android App Protection

&#x20;Win32 App Deployment

&#x20;       |

&#x20;       v

&#x20;Windows BYOD / MAM

```



This is a homelab and test environment, not a production tenant. I used it to build the configuration, test the policies, deliberately create a few failure conditions and verify the results.



\---



\# Architecture Diagrams



The repository contains four architecture diagrams. Each diagram covers a different part of the lab.



\## 1. Identity \& Hybrid Management



This diagram shows the on-premises Active Directory environment, UPN alignment, Microsoft Entra Connect, Microsoft Entra ID, Hybrid Join, PRT/SSO and the managed Windows endpoint.



!\[Identity \& Hybrid Management](./Architecture%20Diagrams/Identity%20%26%20Hybrid%20Management%20Diagram%283%29.png)



\## 2. Windows Endpoint Management



This diagram covers Windows enrollment, Intune management, configuration, BitLocker, compliance, Conditional Access and the Brave Win32 application deployment.



!\[Windows Endpoint Management](./Architecture%20Diagrams/Windows%20Endpoint%20Management%20Dashboard%282%29.png)



\## 3. Android Enterprise \& Device Management



This diagram shows the Android Enterprise Work Profile flow from Managed Google Play through enrollment, configuration, compliance, Conditional Access and required applications.



!\[Android Enterprise \& Device Management](./Architecture%20Diagrams/Android%20Enterprise%20Device%20Management%20Overview.png)



\## 4. Android App Protection (MAM)



This diagram covers Android App Protection, including application access, data protection, managed application controls and the data boundary between managed and unmanaged applications.



!\[Android App Protection](./Architecture%20Diagrams/Android%20App%20Protection%20Policy%20Overview.png)



\---



\# Lab Environment



| Component | Details |

|---|---|

| Hypervisor | VMware Workstation Pro |

| Domain Controller | Windows Server 2022 — `DC01` |

| Windows managed client | Windows 11 Pro — `WIN11-CLIENT01` |

| Windows BYOD test client | `CLIENT02` |

| Android test device | OnePlus CPH2447 — Android 16 |

| Active Directory domain | `thousiflab.com` |

| Microsoft Entra tenant | `thousiflab.onmicrosoft.com` |

| Main Intune group | `GRP-Intune-Users` |

| Main Windows test account | `areddy` / Arjun Reddy |

| Android management model | Android Enterprise Work Profile |

| Windows BYOD model | Windows App Protection (MAM) |



`WIN11-CLIENT01` was the main managed Windows endpoint.



`CLIENT02` was kept outside the Thousiflab domain and outside Intune MDM for the Windows MAM test.



The main Android device used during the Android section was:



`areddy\_AndroidForWork\_8/10/2026\_2:18 PM`



The device was a personally owned OnePlus CPH2447 running Android 16.



\---



\# Technologies Used



\- Windows Server 2022

\- Active Directory Domain Services

\- DNS

\- DHCP

\- Group Policy

\- Microsoft Entra ID

\- Microsoft Entra Connect

\- Password Hash Synchronization

\- Microsoft Intune

\- Microsoft 365

\- Windows 11 Pro

\- Windows Endpoint Security

\- BitLocker

\- Microsoft Entra Conditional Access

\- Android Enterprise

\- Managed Google Play

\- Intune App Protection

\- PowerShell

\- VMware Workstation Pro

\- Win32 Content Prep Tool



\---



\# 01 - Identity \& Active Directory



I built the Active Directory environment first on Windows Server 2022.



The main domain used in the lab was:



`thousiflab.com`



The domain controller was:



`DC01`



The Active Directory environment was used as the starting point for the hybrid identity setup.



The main identity used later in the project was:



`areddy`



The user was later synchronized into Microsoft Entra ID and used for the Intune, Microsoft 365, Conditional Access and application-management testing.



The user UPN initially used the on-premises format:



`areddy@thousiflab.com`



During the hybrid identity setup, the UPN was changed to the Microsoft Entra tenant namespace:



`areddy@thousiflab.onmicrosoft.com`



This was done so that the on-premises identity and Microsoft Entra identity used the same UPN format during synchronization.



\---



\# 02 - Entra Connect \& SSO



Microsoft Entra Connect was configured to synchronize the on-premises identities to Microsoft Entra ID.



Password Hash Synchronization was used for the identity synchronization.



After the UPN changes were made in Active Directory, I manually started a delta synchronization using:



```powershell

Start-ADSyncSyncCycle -PolicyType Delta

```



The synchronization completed successfully and the updated UPN information then appeared in Microsoft Entra ID.



The Windows identity was also checked with:



```text

dsregcmd /status

```



The relevant final results showed:



```text

AzureAdJoined : YES

DomainJoined  : YES

AzureAdPrt    : YES

KeySignTest   : PASSED

```



`EnterprisePrt : NO` remained unchanged, so I documented the result as it appeared instead of treating it as a successful Enterprise PRT configuration.



!\[Hybrid Join and PRT Verification](./Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/03%20-%20SSO%20%26%20PRT%20Verification/26-DSREGCMD%20PRT%20Success%281%29.png)



The `dsregcmd` output was useful because it showed the connection between the local Windows identity, Microsoft Entra ID and the cloud authentication state.



\---



\# 03 - Intune Enrollment \& Management



`WIN11-CLIENT01` was enrolled into Microsoft Intune after the Hybrid Microsoft Entra Join and MDM configuration were in place.



The client appeared in Intune as a managed Windows device.



The primary user was:



`areddy`



The enrollment process was verified from the Intune side and from the Windows client.



!\[WIN11-CLIENT01 in Intune](./Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/03%20-%20Device%20Management/30-Intune%20Client%20Device%281%29.png)



The Windows endpoint was then used for the security, compliance, Conditional Access and application deployment testing.



The main management stages were:



```text

Hybrid Microsoft Entra Join

&#x20;       ↓

Intune Enrollment

&#x20;       ↓

Configuration

&#x20;       ↓

Security

&#x20;       ↓

Compliance

&#x20;       ↓

Conditional Access

&#x20;       ↓

Application Deployment

```



\---



\# 04 - Endpoint Security \& Firewall



Windows security policies were configured through Intune.



The Windows endpoint was used to test controls such as:



\- Microsoft Defender configuration

\- SmartScreen

\- Firewall profiles

\- Device security settings

\- Endpoint management controls



The firewall configuration was important later during the Conditional Access test because compliance depended on the firewall state.



The Windows firewall profiles were configured and checked on the client.



The device was kept compliant during the normal state.



For the Conditional Access test, the Private and Public firewall profiles were temporarily turned off while the Domain firewall remained enabled.



This was done deliberately to create a controlled noncompliant state.



\---



\# 05 - BitLocker Device Encryption



BitLocker was tested on the Windows VM rather than being treated only as a policy configuration.



During the initial test, BitLocker would not complete because Secure Boot was not enabled in the VMware configuration.



I enabled Secure Boot and continued with the BitLocker setup.



The TPM protector was then added and the BitLocker encryption process was completed.



The final encryption state was verified on the client.



!\[BitLocker Final Status](./Screenshots/05%20-%20BitLocker%20Device%20Encryption/40-BitLocker%20Final%20Status%281%29.png)



The important part of this test was seeing the difference between the management policy and the underlying VM configuration. Intune could configure the management side, but the endpoint still needed the correct hardware and firmware state for BitLocker to work.



\---



\# 06 - Compliance



The Windows compliance policy was used to check whether the managed Windows endpoint met the required security conditions.



The device was normally maintained in a compliant state.



Compliance was then used as the condition for the Conditional Access testing.



The compliance state was verified before starting the Conditional Access test.



This made it possible to test the relationship between:



```text

Device configuration

&#x20;       ↓

Device compliance

&#x20;       ↓

Conditional Access

```



\---



\# 07 - Conditional Access



I created a Conditional Access policy to require the Windows device to be compliant for the policy evaluation.



The policy used in the lab was:



`WIN11-CA-Require-Compliant-Device`



The policy was configured in \*\*Report-only\*\* mode.



The policy targeted:



\- \*\*Users, agents or workload identities:\*\* 1 group

\- \*\*Excluded identities:\*\* 0 users, 0 groups, 0 roles

\- \*\*Included resources:\*\* All resources

\- \*\*Device platform:\*\* Windows

\- \*\*Requirement for access:\*\* Require device to be marked as compliant

\- \*\*Client apps:\*\* 1 included



!\[Conditional Access Policy Configuration](./Screenshots/07%20-%20Conditional%20Access/01%20-%20Policy%20Configuration/49-Conditional%20Access%20Policy%20Configuration.png)



The policy evaluated whether the Windows device was reported as compliant during the sign-in.



\## Policy Validation



I checked the sign-in activity from Microsoft Entra ID.



The report-only evaluation showed:



\*\*Policy:\*\* `WIN11-CA-Require-Compliant-Device`



\*\*Grant control:\*\* `RequireCompliantDevice`



\*\*Result:\*\* `Report-only: Success`



!\[Conditional Access Report-Only Success](./Screenshots/07%20-%20Conditional%20Access/02%20-%20Policy%20Validation/50-Conditional%20Access%20Report-Only%20Success.png)



A normal Windows sign-in was not useful for testing this policy because the custom Conditional Access policy was \*\*Not Applicable\*\* there. I used OneDrive for the cloud-application test instead.



\## Noncompliant Test



I temporarily turned off the \*\*Private\*\* and \*\*Public\*\* firewall profiles on `WIN11-CLIENT01`.



The Domain firewall remained enabled.



The compliance report then showed:



\- \*\*Compliant:\*\* 0

\- \*\*Noncompliant:\*\* 1

\- \*\*Others:\*\* 0

\- \*\*Total:\*\* 1



The affected device was:



`WIN11-CLIENT01`



The user shown for the device was:



`Arjun Reddy`



!\[WIN11-CLIENT01 Noncompliant](./Screenshots/07%20-%20Conditional%20Access/03%20-%20Noncompliant%20Test/51-WIN11-CLIENT01%20Noncompliant.png)



The Conditional Access evaluation was then checked again.



The result changed to:



\*\*Report-only: Failure\*\*



!\[Conditional Access Noncompliant Failure](./Screenshots/07%20-%20Conditional%20Access/03%20-%20Noncompliant%20Test/52-Conditional%20Access%20Noncompliant%20Failure.png)



The failure reflected the fact that the device was no longer compliant.



\## Compliance Restored



The firewall settings were restored.



The device returned to a compliant state.



!\[WIN11-CLIENT01 Compliance Restored](./Screenshots/07%20-%20Conditional%20Access/03%20-%20Noncompliant%20Test/53-WIN11-CLIENT01%20Compliance%20Restored.png)



The Conditional Access evaluation was checked again.



The policy returned to:



\*\*Report-only: Success\*\*



!\[Conditional Access Compliance Restored](./Screenshots/07%20-%20Conditional%20Access/03%20-%20Noncompliant%20Test/54-Conditional-Access-Compliance-Restored.png)



The Windows Conditional Access policy remained in Report-only mode during the documented test.



The screenshots therefore show the policy evaluation changing with the compliance state. They do not show a live Windows access block.



The test flow was:



```text

Compliant device

&#x20;     ↓

Report-only Success

&#x20;     ↓

Private and Public firewall profiles turned off

&#x20;     ↓

Device became noncompliant

&#x20;     ↓

Report-only Failure

&#x20;     ↓

Firewall settings restored

&#x20;     ↓

Device became compliant again

&#x20;     ↓

Report-only Success

```



\---



\# 08 - Application Deployment



I deployed Brave Browser to `WIN11-CLIENT01` through Microsoft Intune as a Win32 application.



I packaged the installer, configured the detection rule, assigned the application to `GRP-Intune-Users`, and checked the installation on the Windows client and in Intune.



\## Brave Win32 Packaging



The package used was:



`BraveBrowserSetup-BRV090.intunewin`



The original installer was:



`BraveBrowserSetup-BRV090.exe`



The package wizard identified it as a Windows Win32 application.



!\[Brave Win32 App Package](./Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/55-Brave%20Win32%20App%20Package.png)



The application was configured with:



\- \*\*Name:\*\* Brave Browser

\- \*\*Publisher:\*\* Brave Software, Inc.

\- \*\*Developer:\*\* Brave Software

\- \*\*Category:\*\* Productivity

\- \*\*Platform:\*\* Windows



The installation command was:



```text

BraveBrowserSetup-BRV090.exe /silent /install

```



The application was configured to install using the \*\*System\*\* account.



Other application settings included:



\- Architecture: x64

\- Minimum supported OS: Windows 10 version 1607

\- Restart: No specific action

\- Installation time: 60 minutes

\- Dependencies: None

\- Supersedence: None

\- Delivery Optimization: Disabled



\## Detection Rule



A file-based detection rule was configured for:



`brave.exe`



The detection settings were:



\- \*\*Rule type:\*\* File

\- \*\*Detection method:\*\* File or folder exists

\- \*\*File:\*\* `brave.exe`

\- \*\*32-bit app on 64-bit clients:\*\* No



!\[Brave Detection Rule](./Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/56-Brave%20Detection%20Rule.png)



The detection rule pointed to the Brave Browser installation directory.



\## Initial Client State



Before deploying the application, I checked the Windows client to make sure Brave was not already installed.



!\[Brave Not Installed](./Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/57-Brave%20Not%20Installed.png)



\## Assignment



Brave Browser was assigned as a \*\*Required\*\* application to:



`GRP-Intune-Users`



The assignment was active with:



\- \*\*Availability:\*\* As soon as possible

\- \*\*Deadline:\*\* As soon as possible

\- \*\*Available uninstall:\*\* Disabled



!\[Brave Deployment Assignment](./Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/58-Brave%20Deployment%20Assignment.png)



\## Deployment Review



Before creating the application, I reviewed the configuration.



!\[Brave Deployment Review](./Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/59-Brave%20Deployment%20Review.png)



After the application was created and assigned, the client initially showed:



`EnforcementInProgress`



I did not treat that as proof that the application was installed.



I manually synchronized the client from:



\*\*Settings → Accounts → Access work or school → organization account → Info → Sync\*\*



After the synchronization, the deployment continued and Brave was installed automatically.



The installer was not manually run on `WIN11-CLIENT01`.



\## Client-Side Verification



After deployment, Brave appeared in the installed applications on the Windows client.



!\[Brave Successfully Installed](./Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/60-Brave%20Successfully%20Installed.png)



\## Intune-Side Verification



The Intune device install status showed:



\- \*\*Device:\*\* `WIN11-CLIENT01`

\- \*\*User:\*\* `areddy@thousiflab.onmicrosoft.com`

\- \*\*Device platform:\*\* Windows

\- \*\*Application status:\*\* Installed



!\[Brave Intune Deployment Successful](./Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/61-Brave%20Intune%20Deployment%20Successful.png)



The client-side installation and Intune status both showed Brave as installed.



\---



\# 09 - Android Device Management



I set up Android Enterprise in Microsoft Intune and used a personally owned Android 16 device with a Work Profile for `Arjun Reddy`.



This stage covered enrollment, Work Profile configuration, compliance, Conditional Access, application deployment and App Protection.



The Android device used throughout this section was:



`areddy\_AndroidForWork\_8/10/2026\_2:18 PM`



The device was a OnePlus CPH2447 running Android 16.



The main Intune group used for the Android policies and applications was:



`GRP-Intune-Users`



The overall Android flow was:



```text

Managed Google Play

&#x20;       ↓

Android Enterprise Enrollment

&#x20;       ↓

Work Profile Configuration

&#x20;       ↓

Compliance

&#x20;       ↓

Conditional Access

&#x20;       ↓

Application Management

&#x20;       ↓

App Protection

```



\## Enrollment



\### Managed Google Play



Android Enterprise enrollment was started by connecting Microsoft Intune with Managed Google Play.



The setup page showed:



\- \*\*Status:\*\* Setup

\- \*\*Organization:\*\* ThousifLab

\- \*\*Linked account:\*\* `thousif@thousiflab.onmicrosoft.com`



!\[Managed Google Play Setup](./Screenshots/09%20-%20Android%20Device%20Management/01%20-%20Enrollment/62-Managed%20Google%20Play%20Setup.png)



\### Android Enterprise Enrollment



I reviewed the enrollment settings for personally owned Android devices using a Work Profile.



!\[Android Enterprise Enrollment Options](./Screenshots/09%20-%20Android%20Device%20Management/01%20-%20Enrollment/63-Android%20Enterprise%20Enrollment%20Options.png)



\### Work Profile Setup



The Android device completed the Work Profile setup.



The final screen showed:



\- Create work profile

\- Activate work profile

\- Update device settings



The device displayed:



\*\*You're all set!\*\*



!\[ThousifLab Android Access Setup](./Screenshots/09%20-%20Android%20Device%20Management/01%20-%20Enrollment/64-Thousiflab%20Android%20Access%20Setup.png)



\### Device Enrolled in Intune



After enrollment, the Android device appeared in Intune.



The device showed:



\- Device: `areddy\_AndroidForWork\_8/10/2026\_2:18 PM`

\- Primary user: Arjun Reddy

\- Enrolled by: Arjun Reddy

\- Ownership: Personal

\- Compliance: Compliant

\- Operating system: Android

\- Manufacturer: OnePlus

\- Model: CPH2447



!\[Android Device Enrolled in Intune](./Screenshots/09%20-%20Android%20Device%20Management/01%20-%20Enrollment/65-Android%20Device%20Enrolled%20in%20Intune.png)



\---



\## Android Configuration



The Android Work Profile security configuration was:



`Android-BYOD-WorkProfile-Security`



The platform was \*\*Android Enterprise\*\* and the profile type was \*\*Device restrictions\*\*.



\### Work Profile and Device Restrictions



The configured settings included:



\- Copy and paste between work and personal profiles: Block

\- Data sharing between work and personal profiles: Device default

\- Work profile notifications while device locked: Block

\- Default app permissions: Device default

\- Add and remove accounts: Allow all account types except Google accounts

\- Contact sharing via Bluetooth: Not configured

\- Screen capture: Block

\- Display work contact caller-ID in personal profile: Block

\- Search work contacts from personal profile: Block

\- Camera: Not configured



!\[Android Work Profile General Settings](./Screenshots/09%20-%20Android%20Device%20Management/02%20-%20Configuration/66-Android%20Work%20Profile%20General%20Settings.png)



\### Work Profile Password Settings



The Work Profile password settings included:



\- Require Work Profile Password: Require

\- Maximum inactivity until Work Profile locks: 5 minutes

\- Number of sign-in failures before wiping the Work Profile: 10

\- Password expiration: Not configured

\- Prevent reuse of previous passwords: 5

\- Face unlock: Not configured

\- Fingerprint unlock: Not configured

\- Iris unlock: Not configured

\- Smart Lock and other trust agents: Not configured

\- One lock for device and Work Profile: Not configured



!\[Android Work Profile Password Settings](./Screenshots/09%20-%20Android%20Device%20Management/02%20-%20Configuration/67-Android%20Work%20Profile%20Password%20Settings.png)



\### System Security



The visible security settings included:



\- Threat scan on apps: Require

\- Prevent app installations from unknown sources in the personal profile: Block

\- Always-on VPN: Not configured

\- Lockdown mode: Not configured



!\[Android Personal Profile and System Security](./Screenshots/09%20-%20Android%20Device%20Management/02%20-%20Configuration/68-Android%20Personal%20Profile%20and%20System%20Security.png)



\### Policy Review



The completed configuration profile was named:



`Android-BYOD-WorkProfile-Security`



!\[Android Work Profile Policy Review](./Screenshots/09%20-%20Android%20Device%20Management/02%20-%20Configuration/69-Android%20Work%20Profile%20Policy%20Review.png)



\### Policy Applied



After deployment, I checked the device configuration report.



The settings showed:



\*\*Succeeded\*\*



!\[Android Work Profile Policy Applied](./Screenshots/09%20-%20Android%20Device%20Management/02%20-%20Configuration/70-Android%20Work%20Profile%20Policy%20Applied.png)



\---



\## Android Compliance



The compliance policy was:



`Android-BYOD-WorkProfile-Compliance`



The platform was \*\*Android Enterprise\*\* and the profile type was \*\*Personally-owned work profile\*\*.



The policy was assigned to:



`GRP-Intune-Users`



\### Device Health and Play Protect



The configured settings included:



\- Rooted devices: Block

\- Required device threat level: Low

\- Google Play Services is configured: Require

\- Up-to-date security provider: Require

\- Play Integrity Verdict: Not configured

\- Minimum OS version: 12



!\[Android Compliance Device Health and Play Protect](./Screenshots/09%20-%20Android%20Device%20Management/03%20-%20Compliance/71-Android%20Compliance%20Device%20Health%20and%20Play%20Protect.png)



\### Device and System Security



The policy also required:



\- Encryption of data storage on device: Require

\- Block apps from unknown sources: Block

\- Company Portal app runtime integrity: Require

\- Block USB debugging on device: Block

\- Require a password to unlock mobile devices: Require



!\[Android Compliance Device Security](./Screenshots/09%20-%20Android%20Device%20Management/03%20-%20Compliance/72-Android%20Compliance%20Device%20Security.png)



\### Password Requirements



For Android 12 and later, password complexity was set to:



\*\*High\*\*



!\[Android Compliance Password Settings](./Screenshots/09%20-%20Android%20Device%20Management/03%20-%20Compliance/73-Android%20Compliance%20Password%20Settings.png)



\### Policy Review



The final policy review showed:



`Android-BYOD-WorkProfile-Compliance`



!\[Android Compliance Policy Review](./Screenshots/09%20-%20Android%20Device%20Management/03%20-%20Compliance/74-Android%20Compliance%20Policy%20Review.png)



\### Compliance Verification



The device compliance report showed compliant results for the configured requirements.



The report included:



\- Minimum OS version

\- Password requirement

\- Password complexity

\- Rooted devices

\- USB debugging restriction

\- Company Portal runtime integrity

\- Google Play Services configuration

\- Security provider

\- Encryption



!\[Android Compliance Status](./Screenshots/09%20-%20Android%20Device%20Management/03%20-%20Compliance/75-Android%20Compliance%20Status.png)



The normal Android device state was Android 16 and \*\*Compliant\*\*.



For the later Conditional Access test, I temporarily changed the minimum OS requirement from Android 12 to Android 17. Since the device was Android 16, it became noncompliant.



After the test, I changed the requirement back to Android 12 and restored compliance.



\---



\## Android Conditional Access



The Conditional Access policy used for Android was:



`CA-Android-Require-Compliant-Device`



The policy was configured for Android and used:



\*\*Require device to be marked as compliant\*\*



The initial state was \*\*Report-only\*\*.



\### Policy Review



The policy details showed:



\- State: Report-only

\- Users, agents or workload identities: 1 group

\- Excluded identities: 0

\- Included resources: 1

\- Requirement for access: Require device to be marked as compliant

\- Device platform: Android

\- Client apps: 1 included



!\[Android Conditional Access Policy Review](./Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/76-Android%20Conditional%20Access%20Policy%20Review.png)



\### Report-only Validation



A sign-in was tested while the Android device was compliant.



The policy matched and returned:



\*\*Report-only: Success\*\*



The grant control shown was:



`RequireCompliantDevice`



!\[Conditional Access Report-Only Success](./Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/80-Conditional-Access-Report-Only-Success.png)



\### Conditional Access Enforcement



The policy was then enabled for enforcement.



A compliant Android sign-in continued to succeed.



!\[Conditional Access Enforced Success](./Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/81-Conditional-Access-Enforced-Success.png)



\### Deliberate Noncompliance



To test the policy, I temporarily changed:



`Minimum OS version = 12`



to:



`Minimum OS version = 17`



The device was running Android 16, so it became intentionally noncompliant.



The compliance report showed:



\- Compliant: 0

\- Noncompliant: 1

\- Others: 0

\- Total: 1



!\[Android Device Noncompliant](./Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/82-Android-Device-Noncompliant.png)



\### Conditional Access Block



The Conditional Access result then became:



\*\*Failure\*\*



The grant control remained:



`RequireCompliantDevice`



!\[Conditional Access Noncompliant Blocked](./Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/83-Conditional-Access-Noncompliant-Blocked.png)



The user-facing Company Portal message also showed that the device could not access company resources and needed an operating system update.



It specifically showed:



\*\*Update your operating system to 17 or later.\*\*



!\[Android Conditional Access Blocked User Message](./Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/84-Android-Conditional-Access-Blocked-User-Message.png)



\### Compliance Restored



After the test, I changed the minimum OS requirement back to Android 12.



The compliance report returned to:



\- Compliant: 1

\- Noncompliant: 0

\- Others: 0

\- Total: 1



!\[Conditional Access Access Restored](./Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/85-Conditional-Access-Access-Restored.png)



A fresh sign-in was then tested and Conditional Access returned:



\*\*Success\*\*



!\[Conditional Access Access Restored Success](./Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/86-Conditional-Access-Access-Restored-Success.png)



The Android test flow was:



```text

Compliant Android 16

&#x20;       ↓

Access allowed

&#x20;       ↓

Minimum OS changed 12 → 17

&#x20;       ↓

Device became noncompliant

&#x20;       ↓

Conditional Access blocked access

&#x20;       ↓

Minimum OS restored to 12

&#x20;       ↓

Compliance restored

&#x20;       ↓

Access allowed again

```



Unlike the Windows Conditional Access test, this Android policy was enabled for enforcement.



\---



\## Android Application Management



Android applications were managed through Intune and Managed Google Play.



\### Microsoft Outlook



Microsoft Outlook was added as a Managed Google Play application.



!\[Android Outlook Managed Google Play App Information](./Screenshots/09%20-%20Android%20Device%20Management/05%20-%20Application%20Management/77-Android%20Outlook%20Managed%20Google%20Play%20App%20Information.png)



The application was assigned as:



\*\*Required\*\*



to:



`GRP-Intune-Users`



!\[Android Outlook Required Assignment](./Screenshots/09%20-%20Android%20Device%20Management/05%20-%20Application%20Management/78-Android%20Outlook%20Required%20Assignment.png)



\### Outlook Installation



The Intune device install status showed Outlook installed on the Android Work Profile device.



The application version was:



`5.2630.0 (72630118)`



The platform was:



`Android 16.0`



The status was:



\*\*Installed\*\*



!\[Android Outlook Installation Status](./Screenshots/09%20-%20Android%20Device%20Management/05%20-%20Application%20Management/79-Android%20Outlook%20Installation%20Status.png)



\### Final Managed Apps State



The later Managed Apps view showed:



\- Microsoft Edge — `150.0.4078.96 (407809623)`

\- Intune Company Portal — `5.0.7046.0 (8261458)`

\- Microsoft Outlook — `5.2630.0 (72630118)`

\- Microsoft Authenticator — `6.2607.4697 (202646973)`



All were shown with:



\*\*Resolved intent:\*\* Required install



\*\*Installation status:\*\* Installed



!\[Android Managed Apps Outlook Edge Installed](./Screenshots/09%20-%20Android%20Device%20Management/05%20-%20Application%20Management/87-Android-Managed-Apps-Outlook-Edge-Installed.png)



!\[Android Managed Apps All Required Installed](./Screenshots/09%20-%20Android%20Device%20Management/05%20-%20Application%20Management/88-Android-Managed-Apps-All-Required-Installed.png)



\---



\## Android App Protection



The App Protection policy used was:



`APP-Android-BYOD-Enterprise-Data-Protection`



The platform was Android.



The management type was:



\*\*All app types\*\*



The policy targeted:



\- Microsoft Edge

\- Microsoft Outlook



\### Data Protection



The main controls included:



\- Backup org data to Android backup services: Block

\- Send org data to other apps: Policy managed apps

\- Save copies of org data: Block

\- Allow user to save copies to selected services: 2 selected

\- Transfer telecommunication data to: Any dialer app

\- Transfer messaging data to: Any messaging app

\- Receive data from other apps: Policy managed apps

\- Open data into Org documents: Block

\- Allow users to open data from selected services: 2 selected

\- Restrict cut, copy, and paste between other apps: Policy managed apps with paste in

\- Cut and copy character limit for any app: 0

\- Screen capture and Google Assistant: Block

\- Approved keyboards: Require

\- Encrypt org data: Require

\- Encrypt org data on enrolled devices: Require



!\[Android APP Data Protection Data Transfer](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/89-Android-APP-Data-Protection-Data-Transfer.png)



!\[Android APP Data Protection Encryption](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/90-Android-APP-Data-Protection-Encryption.png)



Additional functionality settings included:



\- Sync policy managed app data with native apps or add-ins: Block

\- Printing org data: Block

\- Restrict web content transfer with other apps: Microsoft Edge

\- Org data notifications: Allow

\- Start Microsoft Tunnel connection on app-launch: No



!\[Android APP Data Protection Functionality](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/91-Android-APP-Data-Protection-Functionality.png)



\### Access Requirements



The App Protection policy required an application PIN.



The settings included:



\- PIN for access: Require

\- PIN type: Numeric

\- Simple PIN: Block

\- Minimum PIN length: 6

\- Biometrics instead of PIN for access: Allow

\- Override biometrics with PIN after timeout: Require

\- Timeout: 30 minutes of inactivity

\- Class 3 Biometrics: Require

\- Override biometrics with PIN after biometric updates: Require

\- PIN reset after number of days: Yes

\- Number of days: 90

\- Previous PIN values maintained: 3



!\[Android APP Access Requirements PIN](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/92-Android-APP-Access-Requirements-PIN.png)



The policy also required:



\- App PIN when device PIN is set: Require

\- Work or school account credentials for access: Require

\- Recheck access requirements after: 30 minutes of inactivity



!\[Android APP Access Requirements Credentials](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/93-Android-APP-Access-Requirements-Credentials.png)



\### Conditional Launch



The conditional launch settings included:



\- Maximum PIN attempts: 5 → Reset PIN

\- Offline grace period: 30 minutes → Block access

\- Offline grace period: 7 days → Wipe data

\- Jailbroken/rooted devices: Block access

\- Samsung Knox device attestation: Block access on supported devices



!\[Android APP Conditional Launch](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/94-Android-APP-Conditional-Launch.png)



\### Policy Review



The final App Protection review showed:



`APP-Android-BYOD-Enterprise-Data-Protection`



with:



\- Platform: Android

\- Management type: All app types

\- Public apps: Microsoft Edge and Microsoft Outlook



!\[Android APP Policy Review](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/95-Android-APP-Policy-Review.png)



\### App Protection Activation



After deployment, the protected account showed:



\- Recently connected

\- Device is supported

\- Everything's up-to-date

\- Device is healthy



!\[Android APP Outlook Protection Activated](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/96-Android-APP-Outlook-Protection-Activated.png)



\### Corporate Data Test



I tested the App Protection controls using a protected Outlook session.



Corporate content was copied from the protected Microsoft application.



!\[Android APP Outlook Corporate Data Copied](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/97-Android-APP-Outlook-Corporate-Data-Copied.png)



I then tried to use the copied organizational data in another application.



The device displayed:



\*\*Your organization's data cannot be pasted here.\*\*



!\[Android APP Unmanaged App Data Transfer Blocked](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/98-Android-APP-Unmanaged-App-Data-Transfer-Blocked.png)



The protected data was blocked from being pasted into an unmanaged application.



I also tested managed-to-managed transfer.



!\[Android APP Managed App Data Transfer Allowed](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/99-Android-APP-Managed-App-Data-Transfer-Allowed.png)



The resulting behavior was:



```text

Managed app → Managed app

Allowed



Managed app → Unmanaged app

Blocked

```



\### Application PIN Test



I also tested the App Protection PIN requirement directly.



The protected account displayed:



\*\*Managed by your organization\*\*



and prompted:



\*\*Enter your PIN\*\*



!\[Android APP App PIN Access Control](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/100-Android-APP-App-PIN-Access-Control.png)



\### App Protection Check-In



The Intune App Protection overview showed:



\- Apps: 2

\- Users checked in: 1

\- Microsoft Edge: 1 check-in

\- Microsoft Outlook: 1 check-in



!\[Android APP Intune Policy User Check-In](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/101-Android-APP-Intune-Policy-User-Check-In.png)



\---



\# 10 - Windows App Protection (MAM)



I configured Windows App Protection in Microsoft Intune for a BYOD setup where a personal Windows 11 device could access company resources through Microsoft Edge without being enrolled into Intune MDM.



The policy used was:



`APP-Windows-BYOD-Enterprise-Data-Protection`



The policy was assigned to:



`GRP-Intune-Users`



!\[Windows APP Basics](./Screenshots/10%20-%20Windows%20App%20Protection/101-Windows-APP-Basics.png)



The policy was created for Microsoft Edge.



The minimum OS version was left unconfigured.



!\[Windows APP Target Apps](./Screenshots/10%20-%20Windows%20App%20Protection/102-Windows-APP-Target-Apps.png)



The main data protection settings included:



\- Send org data to other apps: Policy managed apps

\- Save copies of org data: Block

\- Allow user to save copies to selected services: 2 selected

\- Receive data from other apps: Policy managed apps

\- Open data into Org documents: Block

\- Allow users to open data from selected services: 2 selected

\- Restrict cut, copy, and paste between other apps: Policy managed apps with paste in

\- Cut/copy character limit for any app: 0

\- Screen capture and Google Assistant: Block

\- Approved keyboards: Require

\- Encrypt org data: Require

\- Encrypt org data on enrolled devices: Require

\- Sync policy managed app data with native apps or add-ins: Block

\- Printing org data: Block

\- Restrict web content transfer with other apps: Microsoft Edge

\- Org data notifications: Allow

\- Start Microsoft Tunnel connection on app-launch: No



!\[Windows APP Data Protection](./Screenshots/10%20-%20Windows%20App%20Protection/103-Windows-APP-Data-Protection.png)



Health checks included:



\- Offline grace period: 30 minutes → Block access

\- Offline grace period: 7 days → Wipe data

\- Maximum allowed device threat level: Secured → Block access

\- Minimum OS: Not configured



!\[Windows APP Health Checks](./Screenshots/10%20-%20Windows%20App%20Protection/104-Windows-APP-Health-Checks.png)



The final policy review showed the policy name, Windows platform and Microsoft Edge as the protected application.



!\[Windows APP Policy Review](./Screenshots/10%20-%20Windows%20App%20Protection/105-Windows-APP-Policy-Review.png)



\## CLIENT02 BYOD Test



I kept `CLIENT02` outside the Thousiflab domain and outside Intune MDM so I could test Windows MAM on an unmanaged device.



Microsoft Edge was signed in with the `areddy` account.



When Edge asked whether the work account should be added to other applications, I selected \*\*No\*\*.



Outlook Web was also accessed from CLIENT02.



This showed that Microsoft 365 authentication worked on the unmanaged PC without requiring domain join or Intune MDM enrollment.



\## Download Restriction Test



While Edge was signed in to the organizational account, I tried to download Brave from the protected Edge session.



The download was blocked with:



> \*\*Your organization prevents you from downloading this file.\*\*



After signing out of the organizational Edge session, the download succeeded.



The restriction applied to the protected work session, while the Windows device itself remained unmanaged.



!\[Windows APP Download Blocked](./Screenshots/10%20-%20Windows%20App%20Protection/106-Windows-APP-Download-Blocked.png)



\## Copy and Paste Test



Brave was installed outside the protected Edge work context and remained unmanaged.



I copied corporate text from the protected Edge/Outlook Web session and tried to paste it into Brave.



The paste was blocked with:



> \*\*You copied from a protected location. Pasting here isn't permitted by your organization.\*\*



!\[Windows APP Copy Paste Blocked](./Screenshots/10%20-%20Windows%20App%20Protection/107-Windows-APP-Copy-Paste-Blocked.png)



The test confirmed that protected corporate data could not be pasted from the Edge work session into unmanaged Brave.



\## Intune Check-In



After testing, Intune showed:



`APP-Windows-BYOD-Enterprise-Data-Protection`



The check-in showed:



\- Platform: Windows

\- Management type: All app types

\- Microsoft Edge: 1 check-in

\- Users checked in: 1



!\[Windows APP Intune Check-In](./Screenshots/10%20-%20Windows%20App%20Protection/108-Windows-APP-Intune-Check-In.png)



The Windows device remained unmanaged throughout the test, while the protected Edge session still enforced the configured data restrictions.



\---



\# Troubleshooting and Issues Faced During the Lab



The lab was not a straight configuration process. A few problems required additional troubleshooting.



\## 1. AD UPN did not match the Microsoft Entra identity



At the beginning, the users in Active Directory were using the:



`@thousiflab.com`



UPN, while the Microsoft Entra accounts were using:



`@thousiflab.onmicrosoft.com`



The on-premises and cloud identities were therefore not using the same UPN format for the hybrid setup.



I fixed this by adding `thousiflab.onmicrosoft.com` as an alternative UPN suffix in Active Directory and then updating the users with PowerShell.



After that, the users had the correct UPN format for the synchronization workflow.



\## 2. UPN changes were not immediately visible in Microsoft Entra



After changing the UPNs in Active Directory, the changes did not appear in Microsoft Entra immediately.



I manually started an Entra Connect delta synchronization using:



```powershell

Start-ADSyncSyncCycle -PolicyType Delta

```



The synchronization completed successfully and the updated UPNs then appeared in Microsoft Entra.



\## 3. Ahmed was not suitable for the hybrid identity testing



Ahmed was a cloud-created account, so it was not the right account for testing the on-premises Active Directory to Microsoft Entra synchronization workflow.



I switched to `areddy` as the main test account because that account was created in the on-premises Active Directory and was used for the later synchronization, Intune, Microsoft 365 and Conditional Access work.



\## 4. BitLocker would not enable because Secure Boot was not enabled



While testing BitLocker on the Windows VM, BitLocker would not enable.



After checking the VM configuration, I found that Secure Boot was not enabled.



I enabled Secure Boot in VMware and continued with the BitLocker setup.



After that, I was able to add the TPM protector and complete the encryption process.



The final result showed the drive fully encrypted with BitLocker protection enabled.



\## 5. Intune Tenant Status showed 401 / No Permission



When I opened:



\*\*Intune admin center → Tenant administration → Tenant status\*\*



the page showed:



> You don't have access



The error details showed:



> Error code: 401  

> Details: No Permission



At first, I thought this was an Intune permissions issue.



The problem was related to the licensing available in the tenant. I started the \*\*Microsoft Entra ID P1 Trial\*\*, and after the trial was added, the issue was resolved.



The licensing change and the original 401 error were both captured as evidence.



!\[Intune Tenant Status showing 401 No Permission](./Screenshots/11%20-%20Troubleshooting/44-Intune%20Tenant%20Status%20No%20Permission%281%29.png)



!\[Microsoft Entra ID P1 Trial Added](./Screenshots/11%20-%20Troubleshooting/05-%20Entra%20ID%20P1%20Trial%20Added%285%29.png)



\## 6. Outlook would not open because the account had no Exchange Online license



While testing Outlook with the `areddy` account, Outlook would not open correctly and returned a server error.



The error included:



`OwaNoMailboxAndNoLicenseAssignedException`



The same problem appeared when I checked the account on the PC, so it was not an Android-only issue.



The actual problem was that `areddy` did not have the required Exchange Online mailbox because the Microsoft 365 license was missing.



I assigned \*\*Microsoft 365 Business Basic\*\* to `areddy` and waited for the mailbox to provision.



After the license and mailbox were available, Outlook started working on the PC and on the Android Work Profile.



!\[Outlook No License Error](./Screenshots/11%20-%20Troubleshooting/109-Outlook-No-License-Error.png)



\## 7. Android apps showed "Waiting for install" even though they were already installed



This was one of the bigger troubleshooting issues in the lab.



The applications were already installed on the Android Work Profile, but Intune was showing states such as \*\*Waiting for install\*\*.



During troubleshooting, I removed Authenticator because I thought it might be related. I later added it back, but that did not solve the issue.



I then compared the applications actually present on the Android Work Profile with the applications assigned as \*\*Required\*\* in Intune.



That is where I found the mismatch.



\*\*Intune Company Portal was installed on the Android device, but it was not assigned as a Required app in Intune.\*\*



The applications on the Work Profile and the Required app assignments in Intune were not fully aligned.



I corrected the Required app assignments so that the applications on the Android Work Profile matched the applications Intune was expected to manage, including Company Portal.



After that, within roughly \*\*5–10 minutes\*\*, the application statuses in Intune changed to \*\*Installed\*\*.



The earlier Edge and Outlook reporting problems were part of the same Android application assignment and reporting issue, so I kept them together instead of listing them as separate problems.



The practical fix was to compare:



```text

Applications on the device

&#x20;       ↓

Required app assignments in Intune

&#x20;       ↓

Intune installation status

```



rather than immediately removing and reinstalling applications.



\## 8. Security Defaults had to be disabled before Conditional Access could be enforced



I created the Android Conditional Access policy in \*\*Report-only\*\* first so I could test it without immediately enforcing it.



The policy could be evaluated in Report-only, but I could not switch it to \*\*On\*\* while Security Defaults were enabled.



I disabled \*\*Security Defaults\*\* and then changed the Conditional Access policy to \*\*On\*\*.



After that, I was able to continue with the actual Conditional Access enforcement test.



\## 9. The Global Administrator lost access to Microsoft Authenticator



I lost access to Microsoft Authenticator on the main Global Administrator account and had not created a passkey for that account.



After signing out and trying to sign back in, Microsoft asked for Authenticator verification, but the Authenticator method was no longer available.



The situation was more serious because I was the only Global Administrator at that point.



The account was still signed in on `DC01`.



From there, I gave the `areddy` account the \*\*Global Administrator\*\* role.



I then signed in as `areddy`, which already had a working passkey and Authenticator.



When I checked the authentication methods for the original account, the \*\*Add authentication method\*\* option was greyed out.



Instead, I used `areddy` to manage the authentication methods and added \*\*SMS\*\* using my phone number.



I then used SMS authentication to recover access to the original administrator account.



!\[Global Administrator Add Authentication Method Greyed Out](./Screenshots/11%20-%20Troubleshooting/110-GlobalAdmin-Add-Auth-Method-Greyed-Out.png)



The main lesson was that a Global Administrator should not depend on a single authentication method. Having another Global Administrator and a recovery method can prevent a complete administrator lockout.



\## 10. I could not initially identify the correct Brave uninstall command



When configuring the Brave Win32 application in Intune, I needed the correct uninstall command for the Brave installation already on the client.



The problem was not that the uninstall command was wrong. I simply could not initially find the registered uninstall command.



I used PowerShell to check the Windows uninstall registry entries and find the installed Brave version and its registered uninstall string:



```powershell

Get-ItemProperty "HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\\*","HKLM:\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\\*","HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\\*" | Where-Object {$\_.DisplayName -like "\*Brave\*"} | Select-Object DisplayName,DisplayVersion,UninstallString

```



The result showed:



\- \*\*DisplayName:\*\* Brave

\- \*\*DisplayVersion:\*\* `151.1.93.134`

\- \*\*UninstallString:\*\* the registered Brave `setup.exe` uninstall path



I then used:



```text

"C:\\Program Files\\BraveSoftware\\Brave-Browser\\Application\\151.1.93.134\\Installer\\setup.exe" --uninstall

```



I also checked the same Brave version on another laptop and got the same uninstall command, which gave me more confidence that the command matched the installed version and the default installation path.



I used the uninstall information already registered in Windows instead of guessing the command.



\---



\# Lessons Learned



Building this lab gave me a much clearer idea of how the different parts of Microsoft endpoint management fit together.



Before starting it, I knew what Active Directory, Entra ID, Intune, Conditional Access and App Protection were used for. The part I was missing was how they depended on each other.



Working through the lab on real VMs and a real Android device made that much easier to understand.



\## 1. Identity has to be sorted out first



The biggest thing I learned is that identity sits underneath almost everything else in the lab.



The main account I used, `areddy`, started in on-premises Active Directory and then moved through Entra Connect, Hybrid Join, Intune and Microsoft 365.



!\[Hybrid Join and PRT Verification](./Screenshots/02%20-%20Entra%20Connect%20%26%20SSO/03%20-%20SSO%20%26%20PRT%20Verification/26-DSREGCMD%20PRT%20Success%281%29.png)



Seeing `AzureAdPrt : YES` and the `areddy@thousiflab.onmicrosoft.com` identity in `dsregcmd` made the connection between Windows sign-in, Entra ID and SSO much easier to understand.



\## 2. Enrollment, management and compliance are separate things



One thing that became very clear during the lab is that a device being joined to the domain does not automatically mean it is managed by Intune.



The Windows client went through several stages:



```text

Active Directory

&#x20;     ↓

Hybrid Microsoft Entra Join

&#x20;     ↓

Intune Enrollment

&#x20;     ↓

Security Configuration

&#x20;     ↓

Compliance

```



!\[WIN11-CLIENT01 in Intune](./Screenshots/03%20-%20Intune%20Enrollment%20%26%20Management/03%20-%20Device%20Management/30-Intune%20Client%20Device%281%29.png)



Keeping those stages separate helped me understand what each part was actually doing.



\## 3. I stopped treating the Intune portal as the final answer



One of the biggest changes in how I approach this kind of work came from this lab.



A policy being visible in Intune does not tell me whether the endpoint actually received it or whether the setting is doing what I expected.



I started checking three things instead:



```text

Intune assignment

&#x20;       ↓

Endpoint state

&#x20;       ↓

Actual behavior

```



That approach was useful for security policies, BitLocker, compliance and application deployment.



\## 4. Configuration, compliance and Conditional Access have different jobs



The lab made the difference between these much clearer for me.



Configuration and Endpoint Security policies are used to set things on the device.



Compliance policies check whether the device meets the required conditions.



Conditional Access then uses that result when deciding whether access should be allowed.



!\[Conditional Access Noncompliant Block](./Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/83-Conditional-Access-Noncompliant-Blocked.png)



The Android test made this especially easy to see because I deliberately made the device noncompliant and watched Conditional Access block access.



\## 5. Windows and Android Conditional Access were tested differently



I did not test both platforms in the same way.



For \*\*Windows\*\*, I kept `WIN11-CA-Require-Compliant-Device` in \*\*Report-only\*\* mode. I used a controlled compliance failure to see the result change from Success to Failure and then back to Success after compliance was restored. I did not enforce the Windows policy.



For \*\*Android\*\*, I started in Report-only but then enabled `CA-Android-Require-Compliant-Device`. I tested a compliant device, deliberately changed the minimum OS requirement from 12 to 17 so the Android 16 device became noncompliant, confirmed that access was blocked, and then restored the requirement to 12 and tested access again.



That difference was useful because it showed me both the evaluation side of Conditional Access and what actual enforcement looks like.



\## 6. Security controls make more sense when you test the failure case



A successful configuration screen is useful, but it does not tell me as much as watching the control fail for the exact reason it was designed to detect.



The Android Conditional Access test was a good example.



The device was running Android 16.



I temporarily changed the minimum OS requirement to 17, which made the device noncompliant.



Conditional Access then blocked access.



After changing the requirement back to 12, the device became compliant again and access worked.



That was much more useful than just seeing a policy configured in the portal.



\## 7. The endpoint itself matters just as much as the policy



The BitLocker work taught me this very quickly.



The Intune policy was not the only thing involved.



The VM also needed the right underlying configuration, including Secure Boot.



!\[BitLocker Final Status](./Screenshots/05%20-%20BitLocker%20Device%20Encryption/40-BitLocker%20Final%20Status%281%29.png)



I also learned to separate what Intune configured from what I performed directly on Windows.



The BitLocker policy was part of the management layer, while the TPM protector and protection commands were carried out on the client.



\## 8. Portal status and actual device state can be different



The Android application work was a good lesson here.



There were times when an application was already on the Android Work Profile while Intune was still showing an older installation state.



Instead of immediately removing and reinstalling things, I started comparing:



```text

What is on the device

&#x20;       ↓

What Intune assigned

&#x20;       ↓

What Intune is reporting

```



That way of looking at the problem was much more useful than changing settings at random.



\## 9. Licensing can look like an application problem



The Outlook issue taught me to check the account and service behind an application before assuming the application itself was broken.



The `areddy` account did not have the required Exchange Online license and mailbox, which caused Outlook to fail.



After I assigned Microsoft 365 Business Basic and the mailbox provisioned, Outlook worked on both the PC and the Android Work Profile.



That was a good reminder that application troubleshooting sometimes starts with the user's license and backend service.



\## 10. BYOD does not always require full device management



The Android Work Profile and Windows MAM parts of the lab gave me a better understanding of BYOD.



On Android, the Work Profile kept the work and personal sides separate while the device remained personally owned.



On Windows, `CLIENT02` stayed outside the domain and Intune MDM, but the protected Edge session still controlled company data.



!\[Windows MAM Copy/Paste Block](./Screenshots/10%20-%20Windows%20App%20Protection/107-Windows-APP-Copy-Paste-Blocked.png)



Brave remained unmanaged, but corporate data copied from the protected Edge session could not be pasted into it.



That made the difference between \*\*device management\*\* and \*\*application/data protection\*\* much clearer to me.



\## 11. Real data-transfer tests are stronger than configuration screenshots



The App Protection work was one of the most useful parts of the project because I could test the controls with actual data.



On Android, protected data could move between managed applications but was blocked when I tried to move it into an unmanaged application.



!\[Android MAM Data Transfer Block](./Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/98-Android-APP-Unmanaged-App-Data-Transfer-Blocked.png)



On Windows, the protected Edge session prevented corporate data from being pasted into unmanaged Brave.



Those tests told me much more than simply looking at the policy settings.



\## 12. Administrator recovery needs to be planned before there is a problem



The Global Administrator incident taught me something outside the normal Intune configuration work.



I lost Authenticator access on the main Global Administrator account and had not created a passkey for it.



The recovery worked because I still had access to the environment and could make `areddy` a second Global Administrator.



From there I was able to add SMS and recover the original account.



That made the importance of a second admin and more than one recovery method very real.



\## 13. The order of the project matters



The lab also showed me why the implementation order matters.



The overall path became:



```text

Active Directory

&#x20;       ↓

Microsoft Entra ID

&#x20;       ↓

Entra Connect

&#x20;       ↓

Hybrid Join

&#x20;       ↓

Intune Enrollment

&#x20;       ↓

Security

&#x20;       ↓

Compliance

&#x20;       ↓

Conditional Access

&#x20;       ↓

Application Deployment

&#x20;       ↓

App Protection

```



Once I worked through it in that order, the later stages made much more sense because they were building on the earlier ones.



\## 14. The biggest learning came from seeing everything work together



The part that finally made the whole setup click for me was seeing one user and the managed Windows device move through all of these services.



The identity started in Active Directory.



It was synchronized to Entra ID.



The Windows client became Hybrid joined and enrolled into Intune.



Security settings were applied.



Compliance checked the result.



Conditional Access used that compliance state.



Applications were deployed.



App Protection then added another layer around the data.



That is much easier to understand after actually building and testing it than it is from reading about each product separately.



\---



\# Final Takeaway



The biggest thing I took from this lab is that endpoint management is not just about creating policies.



I had to connect identity, device management, security, compliance, access and applications, and then check what actually happened on the endpoint.



The troubleshooting was useful, but the bigger lesson was learning to build the environment in stages, verify each stage and use the actual device behavior as evidence instead of relying only on what the management portal says.



This lab gave me a much clearer picture of how a hybrid endpoint-management environment works in practice.



\---



\# Repository Structure



```text

Microsoft Intune \& Entra ID Hybrid Endpoint Management Lab/

│

├── README.md

│

├── Documentation/

│   ├── 01 - Identity \& Active Directory.md

│   ├── 02 - Entra Connect \& SSO.md

│   ├── 03 - Intune Enrollment \& Management.md

│   ├── 04 - Endpoint Security \& Firewall.md

│   ├── 05 - BitLocker Device Encryption.md

│   ├── 06 - Compliance.md

│   ├── 07 - Conditional Access.md

│   ├── 08 - Application Deployment.md

│   ├── 09 - Android Device Management.md

│   ├── 10 - Windows App Protection (MAM).md

│   ├── 11 - Troubleshooting.md

│   └── 12 - Lessons Learned.md

│

├── Screenshots/

│   ├── 01 - Identity \& Active Directory/

│   ├── 02 - Entra Connect \& SSO/

│   ├── 03 - Intune Enrollment \& Management/

│   ├── 04 - Endpoint Security \& Firewall/

│   ├── 05 - BitLocker Device Encryption/

│   ├── 06 - Compliance/

│   ├── 07 - Conditional Access/

│   ├── 08 - Application Deployment/

│   ├── 09 - Android Device Management/

│   └── 10 - Windows App Protection/

│

├── PowerShell/

│

└── Architecture Diagrams/

```



The README is intended as the quick overview. The individual MD files contain the detailed implementation steps, configuration details and screenshot evidence.

