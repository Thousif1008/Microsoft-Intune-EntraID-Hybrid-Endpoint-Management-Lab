# Lessons Learned



Building this lab gave me a much clearer idea of how the different parts of Microsoft endpoint management fit together.



Before starting it, I knew what Active Directory, Entra ID, Intune, Conditional Access and App Protection were used for. What I did not really understand was how they depended on each other. Working through the lab on real VMs and a real Android device made that much easier to understand.



## 1. Identity has to be sorted out first



The biggest thing I learned is that identity sits underneath almost everything else in the lab.



The main account I used, `areddy`, started in on-premises Active Directory and then moved through Entra Connect, Hybrid Join, Intune and Microsoft 365.



![Hybrid Join and PRT Verification](./03%20-%20SSO%20%26%20PRT%20Verification/26-DSREGCMD%20PRT%20Success%281%29.png)



Seeing `AzureAdPrt : YES` and the `areddy@thousiflab.onmicrosoft.com` identity in `dsregcmd` made the connection between Windows sign-in, Entra ID and SSO much easier to understand.



## 2. Enrollment, management and compliance are separate things



One thing that became very clear during the lab is that a device being joined to the domain does not automatically mean it is managed by Intune.



The Windows client went through several stages:



`Active Directory`



→ `Hybrid Microsoft Entra Join`



→ `Intune Enrollment`



→ `Security Configuration`



→ `Compliance`



![WIN11-CLIENT01 in Intune](./03%20-%20Device%20Management/30-Intune%20Client%20Device%281%29.png)



Keeping those stages separate helped me understand what each part was actually doing.



## 3. I stopped treating the Intune portal as the final answer



This lab changed how I approach this kind of work.



A policy being visible in Intune does not tell me whether the endpoint actually received it or whether the setting is doing what I expected.



I started checking three things instead:



`Intune assignment`



→ `Endpoint state`



→ `Actual behavior`



That approach was useful for security policies, BitLocker, compliance and application deployment.



## 4. Configuration, compliance and Conditional Access have different jobs



The lab made the difference between these much clearer for me.



Configuration and Endpoint Security policies are used to set things on the device.



Compliance policies check whether the device meets the required conditions.



Conditional Access then uses that result when evaluating access.



![Conditional Access Noncompliant Block](./04%20-%20Conditional%20Access/83-Conditional-Access-Noncompliant-Blocked.png)



The Android test made this especially easy to see because I deliberately made the device noncompliant and watched Conditional Access block access.



## 5. Windows and Android Conditional Access were tested differently



I did not test both platforms in the same way.



For **Windows**, I kept `WIN11-CA-Require-Compliant-Device` in **Report-only** mode. I used a controlled compliance failure to see the result change from Success to Failure and then back to Success after compliance was restored. I did not enforce the Windows policy.



For **Android**, I started in Report-only but then enabled `CA-Android-Require-Compliant-Device`. I tested a compliant device, deliberately changed the minimum OS requirement from 12 to 17 so the Android 16 device became noncompliant, confirmed that access was blocked, and then restored the requirement to 12 and tested access again.



Seeing the two tests made the difference between evaluation and actual enforcement much clearer to me.



## 6. Security controls make more sense when you test the failure case



A successful configuration screen is useful, but I learned much more by testing what happened when the control actually failed.



The Android Conditional Access test was a good example.



The device was running Android 16. I temporarily changed the minimum OS requirement to 17, which made the device noncompliant. Conditional Access then blocked access.



After changing the requirement back to 12, the device became compliant again and access worked.



That told me much more than the policy configuration alone.



## 7. The endpoint itself matters just as much as the policy



The BitLocker work taught me this very quickly.



The Intune policy was not the only thing involved. The VM also needed the right underlying configuration, including Secure Boot.



![BitLocker Final Status](./04%20-%20Encryption%20%26%20Protection/40-BitLocker%20Final%20Status%281%29.png)



I also learned to separate what Intune configured from what I performed directly on Windows. The BitLocker policy was part of the management layer, while the TPM protector and protection commands were carried out on the client.



## 8. Portal status and actual device state can be different



The Android application work was a good lesson here.



There were times when an application was already on the Android Work Profile while Intune was still showing an older installation state.



Instead of immediately removing and reinstalling things, I started comparing:



`What is on the device`



against



`What Intune assigned`



and then



`What Intune is reporting`



Comparing those three states was much more useful than changing settings without knowing what was actually wrong.



## 9. Licensing can look like an application problem



The Outlook issue taught me to check the account and service behind an application before assuming the application itself is broken.



The `areddy` account did not have the required Exchange Online license and mailbox, which caused Outlook to fail.



After I assigned Microsoft 365 Business Basic and the mailbox provisioned, Outlook worked on both the PC and the Android Work Profile.



It showed me that an application problem can sometimes start with the user's license or the service behind it.



## 10. BYOD does not always require full device management



The Android Work Profile and Windows MAM parts of the lab gave me a better understanding of BYOD.



On Android, the Work Profile kept the work and personal sides separate while the device remained personally owned.



On Windows, `CLIENT02` stayed outside the domain and Intune MDM, but the protected Edge session still controlled company data.



![Windows MAM Copy/Paste Block](./10%20-%20Windows%20App%20Protection/107-Windows-APP-Copy-Paste-Blocked.png)



Brave remained unmanaged, but corporate data copied from the protected Edge session could not be pasted into it.



That made the difference between **device management** and **application/data protection** much clearer to me.



## 11. Real data-transfer tests are stronger than configuration screenshots



The App Protection work was one of the most useful parts of the project because I could test the controls with actual data.



On Android, protected data could move between managed applications but was blocked when I tried to move it into an unmanaged application.



![Android MAM Data Transfer Block](./06%20-%20App Protection/98-Android-APP-Unmanaged-App-Data-Transfer-Blocked.png)



On Windows, the protected Edge session prevented corporate data from being pasted into unmanaged Brave.



Those tests told me much more than simply looking at the policy settings.



## 12. Administrator recovery needs to be planned before there is a problem



The Global Administrator issue was different from the normal Intune work I was doing.



I lost Authenticator access on the main Global Administrator account and had not created a passkey for it.



The recovery worked because I still had access to the environment and could make `areddy` a second Global Administrator. From there I was able to add SMS and recover the original account.



After that, having a second admin and another recovery method stopped feeling like a theoretical recommendation.



## 13. The order of the project matters



I also noticed that the order of the implementation mattered more than I expected.



The overall path became:



`Active Directory`



→ `Microsoft Entra ID`



→ `Entra Connect`



→ `Hybrid Join`



→ `Intune Enrollment`



→ `Security`



→ `Compliance`



→ `Conditional Access`



→ `Application Deployment`



→ `App Protection`



Once I worked through it in that order, the later stages made much more sense because they were building on the earlier ones.



## 14. The biggest learning came from seeing everything work together



What made the whole setup finally click for me was seeing one user and one Windows device move through all of these services.


The identity started in Active Directory.



It was synchronized to Entra ID.



The Windows client became Hybrid joined and enrolled into Intune.



Security settings were applied.



Compliance checked the result.



Conditional Access used that compliance state.



Applications were deployed.



App Protection then added another layer around the data.



That is much easier to understand after actually building and testing it than it is from reading about each product separately.



## Final Takeaway



The main thing I took from this lab is that endpoint management is not just about creating policies.



I had to connect identity, device management, security, compliance, access and applications, and then check what actually happened on the endpoint.



The troubleshooting was useful, but the bigger lesson was learning to build the environment in stages, verify each stage, and use the actual device behavior as evidence instead of relying only on what the management portal says.



This lab gave me a much clearer picture of how a hybrid endpoint-management environment works in practice.

