# 06 - Compliance

I created a Windows compliance policy in Microsoft Intune and used it to check the security state of `WIN11-CLIENT01`.

The compliance policy used in the lab was:

`WIN11-Compliance-Policy`

It was created for Windows 10 and later devices.

---

## 01 - Compliance Policy

The Windows compliance policy was created in Microsoft Intune.

Under **Device Health**, the Microsoft Attestation Service settings showed:

- **BitLocker:** Require
- **Secure Boot:** Require
- **Code integrity:** Not configured

![Device Health Compliance Requirements](../Screenshots/06%20-%20Compliance/01%20-%20Compliance%20Policy/45-Device%20Health%20Compliance%20Requirements.png)

*Figure 1 — Device Health requirements configured for BitLocker and Secure Boot.*

The policy also included device security requirements:

- **Encryption:** Not configured
- **Firewall:** Require
- **Trusted Platform Module (TPM):** Not configured
- **Antivirus:** Not configured
- **Antispyware:** Not configured
- **Microsoft Defender Antimalware:** Not configured

![Defender Firewall Compliance Requirement](../Screenshots/06%20-%20Compliance/01%20-%20Compliance%20Policy/46-Defender%20Firewall%20Compliance%20Requirement.png)

*Figure 2 — Firewall required as part of the compliance policy.*

The policy appeared in the Intune compliance policy list as:

`WIN11-Compliance-Policy`

The platform was **Windows 10 and later**, and the policy type was **Windows 10/11 compliance policy**.

![Compliance Policy Created](../Screenshots/06%20-%20Compliance/01%20-%20Compliance%20Policy/48-Compliance%20Policy%20Created.png)

*Figure 3 — WIN11-Compliance-Policy created in Intune.*

---

## 02 - Assignment

The compliance policy was assigned to:

`GRP-Intune-Users`

The group was shown as active and contained:

- **0 devices**
- **2 users**

No filter was applied to the assignment.

![Compliance Policy Assignment](../Screenshots/06%20-%20Compliance/02%20-%20Assignment/47-Compliance%20Policy%20Assignment.png)

*Figure 4 — WIN11-Compliance-Policy assigned to GRP-Intune-Users.*

---

## 03 - Compliance Verification

After assigning the policy, I checked the device compliance report in Intune.

The report showed:

- **Compliant:** 1
- **Noncompliant:** 0
- **Others:** 0
- **Total:** 1

The device listed was:

`WIN11-CLIENT01`

The user shown was:

`Arjun Reddy`

The policy compliance result for the device was:

**Compliant**

The operating system was shown as Windows.

![WIN11-CLIENT01 Compliance Status](../Screenshots/06%20-%20Compliance/03%20-%20Compliance%20Verification/48-WIN11-CLIENT01%20Compliance%20Status.png)

*Figure 5 — WIN11-CLIENT01 reported as compliant with the WIN11-Compliance-Policy.*

---

## Result

The final compliance state was:

`WIN11-Compliance-Policy`

→ BitLocker required

→ Secure Boot required

→ Firewall required

→ policy assigned to `GRP-Intune-Users`

→ `WIN11-CLIENT01` evaluated against the policy

→ **1 compliant device**

→ **0 noncompliant devices**

`WIN11-CLIENT01` met the compliance requirements configured in Intune.