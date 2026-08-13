# 10 - Windows App Protection (MAM)

I configured Windows App Protection in Microsoft Intune for a BYOD setup where a personal Windows 11 device could access company resources through Microsoft Edge without being enrolled into Intune MDM.

The policy used was:

`APP-Windows-BYOD-Enterprise-Data-Protection`

The policy was assigned to:

`GRP-Intune-Users`

![Windows APP Basics](../Screenshots/10%20-%20Windows%20App%20Protection/101-Windows-APP-Basics.png)

The policy was created for Microsoft Edge. The minimum OS version was left unconfigured.

![Windows APP Target Apps](../Screenshots/10%20-%20Windows%20App%20Protection/102-Windows-APP-Target-Apps.png)

The main data protection settings included:

- **Send org data to other apps:** Policy managed apps
- **Save copies of org data:** Block
- **Allow user to save copies to selected services:** 2 selected
- **Receive data from other apps:** Policy managed apps
- **Open data into Org documents:** Block
- **Allow users to open data from selected services:** 2 selected
- **Restrict cut, copy, and paste between other apps:** Policy managed apps with paste in
- **Cut/copy character limit for any app:** 0
- **Screen capture and Google Assistant:** Block
- **Approved keyboards:** Require
- **Encrypt org data:** Require
- **Encrypt org data on enrolled devices:** Require
- **Sync policy managed app data with native apps or add-ins:** Block
- **Printing org data:** Block
- **Restrict web content transfer with other apps:** Microsoft Edge
- **Org data notifications:** Allow
- **Start Microsoft Tunnel connection on app-launch:** No

![Windows APP Data Protection](../Screenshots/10%20-%20Windows%20App%20Protection/103-Windows-APP-Data-Protection.png)

Health checks were also configured:

- **Offline grace period:** 30 minutes → Block access
- **Offline grace period:** 7 days → Wipe data
- **Maximum allowed device threat level:** Secured → Block access
- **Minimum OS:** Not configured

![Windows APP Health Checks](../Screenshots/10%20-%20Windows%20App%20Protection/104-Windows-APP-Health-Checks.png)

The final policy review showed the policy name, Windows platform, and Microsoft Edge as the protected application.

![Windows APP Policy Review](../Screenshots/10%20-%20Windows%20App%20Protection/105-Windows-APP-Policy-Review.png)

## CLIENT02 BYOD Test

I kept `CLIENT02` outside the Thousiflab domain and Intune MDM so I could test Windows MAM on an unmanaged device.

Microsoft Edge was signed in with the `areddy` account. When Edge asked whether the work account should be added to other applications, I selected `No`.

Outlook Web was also accessed from CLIENT02.

This showed that Microsoft 365 authentication worked on the unmanaged PC without requiring domain join or Intune MDM enrollment.

## Download Restriction Test

While Edge was signed in to the organizational account, I tried to download Brave from the protected Edge session.

The download was blocked with:

> **"Your organization prevents you from downloading this file."**

After signing out of the organizational Edge session, the download succeeded.

The restriction applied to the protected work session, while the Windows device itself remained unmanaged.

![Windows APP Download Blocked](../Screenshots/10%20-%20Windows%20App%20Protection/106-Windows-APP-Download-Blocked.png)

## Copy and Paste Test

Brave was installed outside the protected Edge work context and remained unmanaged.

I copied corporate text from the protected Edge/Outlook Web session and tried to paste it into Brave.

The paste was blocked with:

> **"You copied from a protected location. Pasting here isn't permitted by your organization."**

![Windows APP Copy Paste Blocked](../Screenshots/10%20-%20Windows%20App%20Protection/107-Windows-APP-Copy-Paste-Blocked.png)

The test confirmed that protected corporate data could not be pasted from the Edge work session into unmanaged Brave.

## Intune Check-In

After the testing, Intune showed `APP-Windows-BYOD-Enterprise-Data-Protection` as active on Windows.

The check-in showed:

- **Platform:** Windows
- **Management type:** All app types
- **Microsoft Edge:** 1 check-in
- **Users checked in:** 1

![Windows APP Intune Check-In](../Screenshots/10%20-%20Windows%20App%20Protection/108-Windows-APP-Intune-Check-In.png)

## Result

The Windows App Protection policy was tested on an unmanaged Windows 11 device.

The protected Edge session blocked the Brave download, prevented corporate data from being pasted into unmanaged Brave, and reported a check-in back to Intune.

The Windows device remained unmanaged throughout the test, while the protected Edge session still enforced the configured data restrictions.

**Windows MAM: COMPLETE**