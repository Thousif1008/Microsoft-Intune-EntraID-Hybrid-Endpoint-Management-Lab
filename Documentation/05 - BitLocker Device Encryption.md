# 05 - BitLocker Device Encryption

I configured BitLocker on `WIN11-CLIENT01`, starting with the initial drive check and then moving through the Intune policy, TPM protection, encryption, recovery key backup, and final verification.

The BitLocker policy used in Intune was:

`WIN11-BitLocker-Policy`

The policy was assigned to:

`GRP-Intune-Users`

One issue came up during setup: BitLocker would not enable on the VM at first because Secure Boot was not enabled. After I enabled Secure Boot in the VM settings, the BitLocker setup continued normally.

---

## 01 - Before Encryption

Before making any changes, I checked the BitLocker status of the Windows operating system drive from Control Panel.

The C: drive was shown as:

**BitLocker off**

There was also a **Turn on BitLocker** option available.

![BitLocker Before Encryption](../Screenshots/05%20-%20BitLocker%20Device%20Encryption/01%20-%20Before%20Encryption/37-bitlocker-before-encryption.png)

*Figure 1 — BitLocker was still disabled on the C: drive before the encryption setup.*

At this point, the operating system drive was not encrypted. This was also when I noticed the BitLocker activation problem.

BitLocker would not enable because **Secure Boot was not enabled** on the virtual machine. After correcting the VM configuration, I continued with the BitLocker setup.

---

## 02 - BitLocker Policy

I created a BitLocker disk encryption policy in Microsoft Intune.

The policy name was:

`WIN11-BitLocker-Policy`

The description was:

`BitLocker encryption policy for Windows 11 corporate devices.`

The policy contained **21 settings** and was assigned to:

`GRP-Intune-Users`

The assignment was active and the target type was **Include**.

![BitLocker Policy Review](../Screenshots/05%20-%20BitLocker%20Device%20Encryption/02%20-%20BitLocker%20Policy/38-BitLocker%20Policy%20Review.png)

*Figure 2 — WIN11-BitLocker-Policy configured in Intune and assigned to GRP-Intune-Users.*

After creating the policy, I checked the device assignment report.

The report showed:

- **Pending:** 0
- **Not applicable:** 0
- **Success:** 1
- **Error:** 0
- **Conflict:** 0
- **Total:** 1

The device shown in the report was:

`WIN11-CLIENT01`

The last active user was:

`areddy@thousiflab.onmicrosoft.com`

The assignment status was:

**Success**

![BitLocker Policy Success](../Screenshots/05%20-%20BitLocker%20Device%20Encryption/02%20-%20BitLocker%20Policy/42-Intune%20BitLocker%20Policy%20Success.png)

*Figure 3 — Intune confirmed that the BitLocker policy was applied to WIN11-CLIENT01.*

---

## 03 - TPM Protector

After the BitLocker policy was in place, I added the TPM protector directly on the Windows client.

The command used was:

```cmd
manage-bde -protectors -add C: -tpm
```

The command returned a TPM protector with a protector ID and PCR validation profile.

The output also showed that the TPM protector used Secure Boot for integrity validation.

![BitLocker TPM Protector Added](../Screenshots/05%20-%20BitLocker%20Device%20Encryption/03%20-%20TPM%20Protector/39-BitLocker%20TPM%20Protector%20Added.png)

*Figure 4 — TPM protector added to the C: drive.*

The TPM was now being used as the hardware-backed protector for the operating system drive.

---

## 04 - Encryption & Protection

Once the TPM protector was in place, I enabled BitLocker protection for the C: drive.

The command used was:

```cmd
manage-bde -protectors -enable C:
```

The command confirmed:

```text
Key protectors are enabled for volume C:.
```

I then checked the BitLocker status with:

```cmd
manage-bde -status C:
```

The resulting status showed:

- **Size:** 62.96 GB
- **BitLocker Version:** 2.0
- **Conversion Status:** Used Space Only Encrypted
- **Percentage Encrypted:** 100.0%
- **Encryption Method:** XTS-AES 128
- **Protection Status:** On
- **Lock Status:** Unlocked
- **Key Protectors:** TPM, Numerical Password

![BitLocker Final Status](../Screenshots/05%20-%20BitLocker%20Device%20Encryption/04%20-%20Encryption%20%26%20Protection/40-BitLocker%20Final%20Status.png)

*Figure 5 — C: drive fully encrypted with BitLocker and protection enabled.*

At this point, the drive was fully encrypted and BitLocker protection was active.

The status also showed **Used Space Only** encryption with **XTS-AES 128**.

---

## 05 - Recovery Key

I then checked the BitLocker recovery key from the Microsoft Intune device record.

The device was:

`WIN11-CLIENT01`

The recovery key entry showed:

- **Device name:** `WIN11-CLIENT01`
- **Drive type:** Operating system drive
- **BitLocker Key ID:** `4057658a-4997-40c2-8e5e-43c260734b36`
- **Recovery key:** Stored in Intune
- **Backed up:** `8/9/2026, 2:58:20 AM`

The actual recovery key value is masked in the screenshot.

![BitLocker Recovery Key](../Screenshots/05%20-%20BitLocker%20Device%20Encryption/05%20-%20Recovery%20Key/41-BitLocker%20Recovery%20Key%20Intune.png)

*Figure 6 — BitLocker recovery key information stored in Intune for WIN11-CLIENT01.*

The recovery information was available from the Intune device record rather than only on the local machine.

---

## 06 - Final Verification

I performed the final check from the Windows BitLocker Control Panel.

The operating system drive now showed:

**C: BitLocker on**

The page also displayed options to:

- Suspend protection
- Back up your recovery key
- Turn off BitLocker

A message at the top stated:

**For your security, some settings are managed by your system administrator.**

![BitLocker Control Panel On](../Screenshots/05%20-%20BitLocker%20Device%20Encryption/06%20-%20Final%20Verification/43-BitLocker%20Control%20Panel%20On.png)

*Figure 7 — Final BitLocker state showing the C: drive encrypted and protected.*

This gave me a final check from Windows itself that BitLocker was active.

---

## Troubleshooting Note

BitLocker did not enable on the VM during the first attempt.

The issue was **Secure Boot being disabled on the virtual machine**. After I enabled Secure Boot, the BitLocker setup continued:

`Secure Boot fixed`

→ `TPM protector added`

→ `BitLocker protection enabled`

→ `100% encrypted`

→ `Recovery key backed up to Intune`

→ `Final BitLocker state confirmed`

The problem was with the VM configuration, not the BitLocker policy itself.

---

## Result

The final BitLocker state on `WIN11-CLIENT01` was:

- BitLocker policy created in Intune
- Policy assigned to `GRP-Intune-Users`
- Policy assignment: **Success**
- Secure Boot issue identified and corrected
- TPM protector added
- BitLocker protection enabled
- C: drive **100% encrypted**
- Encryption method: **XTS-AES 128**
- Protection status: **On**
- Key protectors: **TPM** and **Numerical Password**
- Recovery key backed up to Intune
- Windows showed **C: BitLocker on**

The Windows client was fully encrypted and the recovery information was available through Intune.