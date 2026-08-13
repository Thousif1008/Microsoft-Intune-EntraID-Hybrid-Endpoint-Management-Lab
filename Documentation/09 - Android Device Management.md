# 09 - Android Device Management

I set up Android Enterprise in Microsoft Intune and used a personally owned Android 16 device with a Work Profile for `Arjun Reddy`. This stage covered enrollment, Work Profile configuration, compliance, Conditional Access, application deployment, and App Protection.

The main Android device used throughout the lab was:

`areddy_AndroidForWork_8/10/2026_2:18 PM`

The device was running Android 16 on a OnePlus CPH2447.

The main Intune group used for the Android policies and applications was:

`GRP-Intune-Users`

The Android management flow was:

`Managed Google Play` → `Android Enterprise Enrollment` → `Work Profile Configuration` → `Compliance` → `Conditional Access` → `Application Management` → `App Protection`

The Android Work Profile kept the work and personal sides separate while allowing the work side of the device to be managed. The final testing covered compliance, required application installation, Conditional Access blocking during deliberate noncompliance, and App Protection controls on the device.

## 01 - Enrollment

### Managed Google Play Setup

Android Enterprise enrollment was started by connecting Microsoft Intune with Managed Google Play.

The Managed Google Play setup page showed:

- **Status:** Setup
- **Organization:** ThousifLab
- **Linked account:** `thousif@thousiflab.onmicrosoft.com`

The page showed the Managed Google Play setup required for Android Enterprise enrollment.

![Managed Google Play Setup](/Screenshots/09%20-%20Android%20Device%20Management/01%20-%20Enrollment/62-Managed%20Google%20Play%20Setup.png)

*Figure 1 — Managed Google Play setup for Android Enterprise enrollment.*

### Android Enterprise Enrollment Options

I reviewed the enrollment settings for personally owned Android devices with a Work Profile.

I used the Android Enterprise Work Profile model so the work and personal sides of the device stayed separate.

![Android Enterprise Enrollment Options](/Screenshots/09%20-%20Android%20Device%20Management/01%20-%20Enrollment/63-Android%20Enterprise%20Enrollment%20Options.png)

*Figure 2 — Android Enterprise personally owned Work Profile enrollment settings.*

### Work Profile Setup on the Device

The Android device completed the Work Profile setup.

The final screen showed all three steps completed:

- Create work profile
- Activate work profile
- Update device settings

The device displayed:

**You're all set!**

![ThousifLab Android Access Setup](/Screenshots/09%20-%20Android%20Device%20Management/01%20-%20Enrollment/64-ThousifLab%20Android%20Access%20Setup.png)

*Figure 3 — Android Work Profile successfully created and activated.*

### Device Enrolled in Intune

After enrollment, the Android device appeared in Microsoft Intune.

The device was shown with:

- Device: `areddy_AndroidForWork_8/10/2026_2:18 PM`
- Primary user: Arjun Reddy
- Enrolled by: Arjun Reddy
- Ownership: Personal
- Compliance: Compliant
- Operating system: Android
- Manufacturer: OnePlus
- Model: CPH2447

![Android Device Enrolled in Intune](/Screenshots/09%20-%20Android%20Device%20Management/01%20-%20Enrollment/65-Android%20Device%20Enrolled%20in%20Intune.png)

*Figure 4 — Personally owned Android Work Profile device enrolled and visible in Intune.*

## 02 - Configuration

The Android Work Profile security configuration was created as:

`Android-BYOD-WorkProfile-Security`

The platform was **Android Enterprise** and the profile type was **Device restrictions**.

### Work Profile and Device Restrictions

The configuration was used to separate work and personal data and restrict actions that could expose company information.

The configured settings included:

- Copy and paste between work and personal profiles: Block
- Data sharing between work and personal profiles: Device default
- Work profile notifications while device locked: Block
- Default app permissions: Device default
- Add and remove accounts: Allow all account types except Google accounts
- Contact sharing via Bluetooth: Not configured
- Screen capture: Block
- Display work contact caller-ID in personal profile: Block
- Search work contacts from personal profile: Block
- Camera: Not configured

![Android Work Profile General Settings](/Screenshots/09%20-%20Android%20Device%20Management/02%20-%20Configuration/66-Android%20Work%20Profile%20General%20Settings.png)

*Figure 5 — General Work Profile restrictions and separation settings.*

### Work Profile Password Settings

The Work Profile also had its own password and lock settings.

The configured settings included:

- Require Work Profile Password: Require
- Maximum inactivity until Work Profile locks: 5 minutes
- Number of sign-in failures before wiping the Work Profile: 10
- Password expiration: Not configured
- Prevent reuse of previous passwords: 5
- Face unlock: Not configured
- Fingerprint unlock: Not configured
- Iris unlock: Not configured
- Smart Lock and other trust agents: Not configured
- One lock for device and Work Profile: Not configured

![Android Work Profile Password Settings](/Screenshots/09%20-%20Android%20Device%20Management/02%20-%20Configuration/67-Android%20Work%20Profile%20Password%20Settings.png)

*Figure 6 — Work Profile password and lock settings.*

### System Security

The configuration also included application and system security controls.

The visible settings included:

- Threat scan on apps: Require
- Prevent app installations from unknown sources in the personal profile: Block
- Always-on VPN: Not configured
- Lockdown mode: Not configured

![Android Personal Profile and System Security](/Screenshots/09%20-%20Android%20Device%20Management/02%20-%20Configuration/68-Android%20Personal%20Profile%20and%20System%20Security.png)

*Figure 7 — Application and system security restrictions.*

### Policy Review

The completed profile was named:

`Android-BYOD-WorkProfile-Security`

The platform was Android Enterprise and the profile type was Device restrictions.

![Android Work Profile Policy Review](/Screenshots/09%20-%20Android%20Device%20Management/02%20-%20Configuration/69-Android%20Work%20Profile%20Policy%20Review.png)

*Figure 8 — Final review of the Android Work Profile security policy.*

### Policy Applied to the Device

After deployment, I checked the device configuration report to verify that the Work Profile settings had reached the device.

The settings shown in the report had a status of:

**Succeeded**

![Android Work Profile Policy Applied](/Screenshots/09%20-%20Android%20Device%20Management/02%20-%20Configuration/70-Android%20Work%20Profile%20Policy%20Applied.png)

*Figure 9 — Work Profile policy settings applied to the Android device.*

## 03 - Compliance

The Android compliance policy was created as:

`Android-BYOD-WorkProfile-Compliance`

The platform was **Android Enterprise** and the profile type was **Personally-owned work profile**.

The policy was assigned to:

`GRP-Intune-Users`

### Device Health and Play Protect

The compliance policy checked several security conditions.

The configured settings included:

- Rooted devices: Block
- Required device threat level: Low
- Google Play Services is configured: Require
- Up-to-date security provider: Require
- Play Integrity Verdict: Not configured
- Minimum OS version: 12

![Android Compliance Device Health and Play Protect](/Screenshots/09%20-%20Android%20Device%20Management/03%20-%20Compliance/71-Android%20Compliance%20Device%20Health%20and%20Play%20Protect.png)

*Figure 10 — Android device health and Google Play Protect requirements.*

### Device and System Security

The policy also required:

- Encryption of data storage on device: Require
- Block apps from unknown sources: Block
- Company Portal app runtime integrity: Require
- Block USB debugging on device: Block
- Require a password to unlock mobile devices: Require

![Android Compliance Device Security](/Screenshots/09%20-%20Android%20Device%20Management/03%20-%20Compliance/72-Android%20Compliance%20Device%20Security.png)

*Figure 11 — Android system security and encryption requirements.*

### Password Requirements

For Android 12 and later, the policy required:

- Password complexity: High

The Work Profile also required a password to unlock it.

![Android Compliance Password Settings](/Screenshots/09%20-%20Android%20Device%20Management/03%20-%20Compliance/73-Android%20Compliance%20Password%20Settings.png)

*Figure 12 — Android compliance password requirements.*

### Policy Review

The compliance policy review showed:

`Android-BYOD-WorkProfile-Compliance`

with the personally owned Work Profile configuration and the selected security requirements.

![Android Compliance Policy Review](/Screenshots/09%20-%20Android%20Device%20Management/03%20-%20Compliance/74-Android%20Compliance%20Policy%20Review.png)

*Figure 13 — Final review of the Android compliance policy.*

### Compliance Verification

The device compliance report showed the configured requirements as compliant.

The report showed compliant results for:

- Minimum OS version
- Password requirement
- Password complexity
- Rooted devices
- USB debugging restriction
- Company Portal runtime integrity
- Google Play Services configuration
- Security provider
- Encryption

![Android Compliance Status](/Screenshots/09%20-%20Android%20Device%20Management/03%20-%20Compliance/75-Android%20Compliance%20Status.png)

*Figure 14 — Android Work Profile device reporting compliant for the configured requirements.*

The normal device state was Android 16 and **Compliant**.

For the Conditional Access test later in the project, I temporarily changed the minimum OS requirement from Android 12 to Android 17. Because the device was running Android 16, it became noncompliant. After the test, I changed the requirement back to Android 12 and restored compliance.

## 04 - Conditional Access

A separate Conditional Access policy was created for the Android device:

`CA-Android-Require-Compliant-Device`

The policy was configured for Android and used the requirement:

**Require device to be marked as compliant**

The initial state was **Report-only** so I could test the policy before enforcing it.

### Conditional Access Policy Review

The policy details showed:

- State: Report-only
- Users, agents or workload identities: 1 group
- Excluded identities: 0
- Included resources: 1
- Requirement for access: Require device to be marked as compliant
- Device platform: Android
- Client apps: 1 included

![Android Conditional Access Policy Review](/Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/76-Android%20Conditional%20Access%20Policy%20Review.png)

*Figure 15 — CA-Android-Require-Compliant-Device configured for Android device compliance.*

### Report-only Validation

I tested a sign-in while the Android device was compliant.

The Conditional Access policy matched the Android device and returned:

**Report-only: Success**

The grant control shown was:

`RequireCompliantDevice`

![Conditional Access Report-Only Success](/Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/80-Conditional-Access-Report-Only-Success.png)

*Figure 16 — Android Conditional Access policy evaluated successfully in Report-only mode.*

### Conditional Access Enforcement

After the Report-only test, I enabled the policy for enforcement.

A compliant Android sign-in continued to succeed.

![Conditional Access Enforced Success](/Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/81-Conditional-Access-Enforced-Success.png)

*Figure 17 — Enforced Conditional Access allowed access while the device was compliant.*

### Deliberate Noncompliance Test

To test the policy properly, I temporarily changed the Android compliance requirement from:

`Minimum OS version = 12`

to:

`Minimum OS version = 17`

The device was running Android 16, so it became intentionally noncompliant.

The compliance report then showed:

- Compliant: 0
- Noncompliant: 1
- Others: 0
- Total: 1

![Android Device Noncompliant](/Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/82-Android-Device-Noncompliant.png)

*Figure 18 — Android device deliberately placed into a noncompliant state for testing.*

### Conditional Access Block

I then checked the same Conditional Access policy again.

The result was:

**Failure**

The grant control remained:

`RequireCompliantDevice`

![Conditional Access Noncompliant Blocked](/Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/83-Conditional-Access-Noncompliant-Blocked.png)

*Figure 19 — Conditional Access returned a failure because the Android device was noncompliant.*

The user-facing Company Portal message also showed that the device could not access company resources and needed to be updated.

The message specifically required:

**Update your operating system to 17 or later.**

![Android Conditional Access Blocked User Message](/Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/84-Android-Conditional-Access-Blocked-User-Message.png)

*Figure 20 — Android user-facing access block caused by the noncompliant device state.*

### Compliance Restored

After the test, I changed the compliance requirement back to Android 12.

The device returned to a compliant state.

The compliance report showed:

- Compliant: 1
- Noncompliant: 0
- Others: 0
- Total: 1

![Conditional Access Access Restored](/Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/85-Conditional-Access-Access-Restored.png)

*Figure 21 — Android compliance restored after the temporary test change was rolled back.*

I then tested a fresh sign-in and Conditional Access returned:

**Success**

![Conditional Access Access Restored Success](/Screenshots/09%20-%20Android%20Device%20Management/04%20-%20Conditional%20Access/86-Conditional-Access-Access-Restored-Success.png)

*Figure 22 — Conditional Access allowed access again after compliance was restored.*

The test ended with the device going from compliant and allowed, to noncompliant and blocked, and then back to compliant and allowed after the temporary OS requirement was restored.

## 05 - Application Management

Android applications were managed through Intune and Managed Google Play.

### Microsoft Outlook

Microsoft Outlook was added as a Managed Google Play application.

The application was configured for Android as a client app.

![Android Outlook Managed Google Play App Information](/Screenshots/09%20-%20Android%20Device%20Management/05%20-%20Application%20Management/77-Android%20Outlook%20Managed%20Google%20Play%20App%20Information.png)

*Figure 23 — Microsoft Outlook configured as a Managed Google Play Android application.*

The application was assigned as:

**Required**

to:

`GRP-Intune-Users`

![Android Outlook Required Assignment](/Screenshots/09%20-%20Android%20Device%20Management/05%20-%20Application%20Management/78-Android%20Outlook%20Required%20Assignment.png)

*Figure 24 — Outlook assigned as a Required application to GRP-Intune-Users.*

### Outlook Installation

The Intune device install status showed Outlook installed on the Android Work Profile device.

The application version was:

`5.2630.0 (72630118)`

The device platform was Android 16.0.

The status was:

**Installed**

![Android Outlook Installation Status](/Screenshots/09%20-%20Android%20Device%20Management/05%20-%20Application%20Management/79-Android%20Outlook%20Installation%20Status.png)

*Figure 25 — Intune reporting Microsoft Outlook as installed on the Android device.*

The later Managed Apps view confirmed the final installed state of the required applications.

The installed applications shown included:

- Microsoft Edge — `150.0.4078.96 (407809623)`
- Intune Company Portal — `5.0.7046.0 (8261458)`
- Microsoft Outlook — `5.2630.0 (72630118)`
- Microsoft Authenticator — `6.2607.4697 (202646973)`

All were shown with:

**Resolved intent:** Required install

**Installation status:** Installed

![Android Managed Apps Outlook Edge Installed](/Screenshots/09%20-%20Android%20Device%20Management/05%20-%20Application%20Management/87-Android-Managed-Apps-Outlook-Edge-Installed.png)

*Figure 26 — Outlook and Edge shown as installed managed applications.*

![Android Managed Apps All Required Installed](/Screenshots/09%20-%20Android%20Device%20Management/05%20-%20Application%20Management/88-Android-Managed-Apps-All-Required-Installed.png)

*Figure 27 — All required managed Android applications shown as installed.*

The later Managed Apps evidence confirms the final installed state of Edge, Company Portal, Outlook and Authenticator.

## 06 - App Protection

The App Protection policy used in the Android part of the lab was:

`APP-Android-BYOD-Enterprise-Data-Protection`

The platform was **Android** and the management type was **All app types**.

The policy targeted:

- Microsoft Edge
- Microsoft Outlook

The policy was used to protect company data in Outlook and Edge through access, data transfer, copy/paste, encryption and conditional launch controls.

The policy was also tested directly on the Android device.

### Data Protection

The main data-protection controls included:

- Backup org data to Android backup services: Block
- Send org data to other apps: Policy managed apps
- Save copies of org data: Block
- Allow user to save copies to selected services: 2 selected
- Transfer telecommunication data to: Any dialer app
- Transfer messaging data to: Any messaging app
- Receive data from other apps: Policy managed apps
- Open data into Org documents: Block
- Allow users to open data from selected services: 2 selected
- Restrict cut, copy, and paste between other apps: Policy managed apps with paste in
- Cut and copy character limit for any app: 0
- Screen capture and Google Assistant: Block
- Approved keyboards: Require
- Encrypt org data: Require
- Encrypt org data on enrolled devices: Require

![Android APP Data Protection Data Transfer](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/89-Android-APP-Data-Protection-Data-Transfer.png)

*Figure 28 — Android App Protection data-transfer and organizational-data controls.*

![Android APP Data Protection Encryption](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/90-Android-APP-Data-Protection-Encryption.png)

*Figure 29 — Organizational data encryption requirements.*

The policy also blocked synchronization of protected app data with native apps or add-ins and blocked printing of organizational data.

The functionality settings included:

- Sync policy managed app data with native apps or add-ins: Block
- Printing org data: Block
- Restrict web content transfer with other apps: Microsoft Edge
- Org data notifications: Allow
- Start Microsoft Tunnel connection on app-launch: No

![Android APP Data Protection Functionality](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/91-Android-APP-Data-Protection-Functionality.png)

*Figure 30 — Additional App Protection functionality and data-leakage controls.*

### Access Requirements

The policy required an application PIN before protected apps could be accessed.

The settings included:

- PIN for access: Require
- PIN type: Numeric
- Simple PIN: Block
- Minimum PIN length: 6
- Biometrics instead of PIN for access: Allow
- Override biometrics with PIN after timeout: Require
- Timeout: 30 minutes of inactivity
- Class 3 Biometrics: Require
- Override Biometrics with PIN after biometric updates: Require
- PIN reset after number of days: Yes
- Number of days: 90
- Previous PIN values maintained: 3

![Android APP Access Requirements PIN](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/92-Android-APP-Access-Requirements-PIN.png)

*Figure 31 — App PIN and biometric access requirements.*

The policy also required:

- App PIN when device PIN is set: Require
- Work or school account credentials for access: Require
- Recheck access requirements after: 30 minutes of inactivity

![Android APP Access Requirements Credentials](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/93-Android-APP-Access-Requirements-Credentials.png)

*Figure 32 — Additional application access and credential requirements.*

### Conditional Launch

The conditional launch settings were:

- Maximum PIN attempts: 5 → Reset PIN
- Offline grace period: 30 minutes → Block access
- Offline grace period: 7 days → Wipe data
- Jailbroken/rooted devices: Block access
- Samsung Knox device attestation: Block access on supported devices

![Android APP Conditional Launch](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/94-Android-APP-Conditional-Launch.png)

*Figure 33 — Conditional launch actions for protected Android apps.*

### Policy Review

The final App Protection review showed:

`APP-Android-BYOD-Enterprise-Data-Protection`

with:

- Platform: Android
- Management type: All app types
- Public apps: Microsoft Edge and Microsoft Outlook

![Android APP Policy Review](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/95-Android-APP-Policy-Review.png)

*Figure 34 — Final review of the Android App Protection policy.*

### App Protection Activation

After deployment, the protected account showed the App Protection checks passing.

The Android screen showed:

- Recently connected
- Device is supported
- Everything's up-to-date
- Device is healthy

![Android APP Outlook Protection Activated](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/96-Android-APP-Outlook-Protection-Activated.png)

*Figure 35 — Outlook showing that the protected work account and device passed the App Protection checks.*

### Corporate Data Test

I tested the App Protection settings using a protected Outlook session.

Corporate content was copied from the protected Microsoft application.

![Android APP Outlook Corporate Data Copied](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/97-Android-APP-Outlook-Corporate-Data-Copied.png)

*Figure 36 — Corporate content copied from the protected Outlook environment.*

I then tried using the copied organizational data in another application.

The Android device displayed:

**Your organization's data cannot be pasted here.**

![Android APP Unmanaged App Data Transfer Blocked](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/98-Android-APP-Unmanaged-App-Data-Transfer-Blocked.png)

*Figure 37 — App Protection blocking protected organizational data from being pasted into an unmanaged app.*

I also tested the same type of corporate data between managed applications.

The managed-app transfer succeeded.

![Android APP Managed App Data Transfer Allowed](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/99-Android-APP-Managed-App-Data-Transfer-Allowed.png)

*Figure 38 — Protected data transfer working between managed applications.*

The resulting behavior was:

**Managed app → Managed app:** Allowed within the configured policy boundary.

**Managed app → Unmanaged app:** Blocked.

### Application PIN Test

I also tested the App Protection PIN requirement directly.

The protected account displayed:

**Managed by your organization**

and prompted:

**Enter your PIN**

![Android APP App PIN Access Control](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/100-Android-APP-App-PIN-Access-Control.png)

*Figure 39 — App Protection requiring the configured application PIN.*

### App Protection Check-in

The Intune App Protection overview showed the policy receiving check-ins.

The policy had:

- Apps: 2
- Users checked in: 1
- Microsoft Edge: 1 check-in
- Microsoft Outlook: 1 check-in

![Android APP Intune Policy User Check-In](/Screenshots/09%20-%20Android%20Device%20Management/06%20-%20App%20Protection/101-Android-APP-Intune-Policy-User-Check-In.png)

*Figure 40 — Intune App Protection policy showing check-ins from Edge and Outlook.*

Intune was receiving check-ins from the protected user and both apps.

## Final Result

The Android device was enrolled as a personal Android Enterprise Work Profile device and received the configured Work Profile security settings.

The compliance policy evaluated the device against OS, password, encryption, Play Protect, Company Portal integrity, USB debugging and other security requirements.

Conditional Access was tested in both directions. A compliant device was allowed to access resources, the device was deliberately made noncompliant by changing the minimum OS requirement to Android 17, access was blocked, the requirement was changed back to Android 12, and access was restored.

Required Android applications were deployed through Managed Google Play and Intune. The final Managed Apps state showed Microsoft Edge, Intune Company Portal, Microsoft Outlook and Microsoft Authenticator installed.

The App Protection policy was tested directly on the Android device. Protected data was copied from Outlook, transfer to an unmanaged application was blocked, managed-to-managed transfer was allowed, the App Protection PIN was required, and Intune recorded check-ins from both Outlook and Edge.

The final Android security flow was:

`Android Enterprise Enrollment`

→ `Work Profile Security`

→ `Compliance`

→ `Conditional Access`

→ `Managed Applications`

→ `App Protection`

→ `Real Device-Side Testing`

By the end of the testing, the Android Work Profile, compliance, Conditional Access, managed applications and App Protection were all working together on the device.