# 08 - Application Deployment

I deployed Brave Browser to `WIN11-CLIENT01` through Microsoft Intune as a Win32 application.

I packaged the installer, configured the detection rule, assigned the app to `GRP-Intune-Users`, and then checked the installation on the Windows client and in Intune.

---

## 01 - Brave

### Packaging the application

Brave Browser was prepared as a Win32 application for deployment through Microsoft Intune.

The application package used was:

`BraveBrowserSetup-BRV090.intunewin`

The original installer was:

`BraveBrowserSetup-BRV090.exe`

The package wizard identified the application as a Windows Win32 app.

![Brave Win32 App Package](../Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/55-Brave%20Win32%20App%20Package.png)

*Figure 1 — Brave Browser packaged as a Win32 application for Intune.*

The application was configured with the following basic information:

- **Name:** Brave Browser
- **Publisher:** Brave Software, Inc.
- **Developer:** Brave Software
- **Category:** Productivity
- **Platform:** Windows

I used this package for the Brave Browser deployment through Intune.

The installation command was:

```text
BraveBrowserSetup-BRV090.exe /silent /install
```

The installation was configured to run as the **System** account.

The application was also configured with:

- **Architecture:** x64
- **Minimum supported OS:** Windows 10 version 1607
- **Restart:** No specific action
- **Installation time:** 60 minutes
- **Dependencies:** None
- **Supersedence:** None
- **Delivery Optimization:** Disabled

---

### Detection rule

A file-based detection rule was configured so Intune could check whether Brave was installed on the endpoint.

The rule used:

- **Rule type:** File
- **Detection method:** File or folder exists
- **File:** `brave.exe`
- **32-bit app on 64-bit clients:** No

The detection rule pointed to the Brave Browser installation directory.

![Brave Detection Rule](../Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/56-Brave%20Detection%20Rule.png)

*Figure 2 — File detection rule configured for `brave.exe` in the Brave installation path.*

---

### Initial client state

Before the deployment, I checked the Windows client to make sure Brave was not already installed.

The browser was not present in the installed applications on the machine.

![Brave Not Installed](../Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/57-Brave%20Not%20Installed.png)

*Figure 3 — Brave was not installed on the Windows client before the Intune deployment.*

---

### Assignment

Brave Browser was assigned as a **Required** application to:

`GRP-Intune-Users`

The assignment was active and configured for:

- **Availability:** As soon as possible
- **Deadline:** As soon as possible
- **Available uninstall:** Disabled

![Brave Deployment Assignment](../Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/58-Brave%20Deployment%20Assignment.png)

*Figure 4 — Brave Browser assigned as a required application to GRP-Intune-Users.*

---

### Deployment review

Before creating the application, I reviewed the configuration.

The review page showed the package, application information, installation command and deployment settings.

The deployment was configured as a required Win32 application for the target group.

![Brave Deployment Review](../Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/59-Brave%20Deployment%20Review.png)

*Figure 5 — Final review of the Brave Browser Win32 application before creation.*

Once the application was created and assigned, the client initially showed:

`EnforcementInProgress`

I did not treat this as proof that Brave was installed. I manually synchronized the client from:

**Settings → Accounts → Access work or school → organization account → Info → Sync**

After the sync, the Intune deployment continued and Brave was installed automatically.

The installer was **not manually run on `WIN11-CLIENT01`**.

---

### Client-side verification

After the deployment completed, Brave appeared in the installed applications on the Windows client.

The installed application was shown as:

**Brave**

with the installed Brave browser version visible on the client.

![Brave Successfully Installed](../Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/60-Brave%20Successfully%20Installed.png)

*Figure 6 — Brave Browser installed on the Windows client.*

---

### Intune-side verification

I then checked the Brave installation status from Intune.

The device shown was:

`WIN11-CLIENT01`

The user was:

`areddy@thousiflab.onmicrosoft.com`

The device was running:

`10.0.26200.8875`

The application status was:

**Installed**

![Brave Intune Deployment Successful](../Screenshots/08%20-%20Application%20Deployment/01%20-%20Brave/61-Brave%20Intune%20Deployment%20Successful.png)

*Figure 7 — Intune reporting Brave Browser as installed on WIN11-CLIENT01.*

Brave was installed on the client, and Intune also reported the device as Installed.

---

## Result

The Brave deployment flow was:

`BraveBrowserSetup-BRV090.exe`

→ packaged as `BraveBrowserSetup-BRV090.intunewin`

→ configured as a Windows Win32 application

→ file detection rule created for `brave.exe`

→ application assigned as **Required** to `GRP-Intune-Users`

→ `WIN11-CLIENT01` confirmed that Brave was not installed

→ deployment initially showed `EnforcementInProgress`

→ client synchronization triggered the deployment

→ Brave installed automatically

→ Brave appeared in Windows installed applications

→ Intune reported the application status as **Installed**

At this point, Brave was deployed through Intune and verified on both the Windows client and in the Intune console.