# 04 - Endpoint Security & Firewall

I created the Windows endpoint security policy in Microsoft Intune and assigned it to `GRP-Intune-Users`. I then checked the Windows client to make sure the policy was applied and that the firewall was working as expected.

The policy used in the lab was:

`WIN11-Endpoint-Security`

The policy was created for Windows devices and assigned to `GRP-Intune-Users`.

---

## 01 - Endpoint Security Policy

The endpoint security profile was created in Microsoft Intune with the name:

`WIN11-Endpoint-Security`

The description shown in the policy was:

`Endpoint security policy for Microsoft Defender Antivirus and Windows Firewall.`

The platform was:

`Windows`

The assignment showed `GRP-Intune-Users` as the included group.

The assignment was active and no filter was applied.

![WIN11 Endpoint Security Policy](./01%20-%20Endpoint%20Security%20Policy/31-Intune%20Endpoint%20Security%20Policy%281%29.png)

*Figure 1 — WIN11-Endpoint-Security policy with GRP-Intune-Users included in the assignment.*

The policy included settings for BitLocker, Defender, Firewall and Microsoft Edge.

The BitLocker section showed:

**Require Device Encryption:** Enabled

The Defender section showed:

**Block untrusted and unsigned processes that run from USB:** Block

The Firewall settings were part of the same endpoint security profile.

The Microsoft Edge SmartScreen settings shown in the policy were:

- **Configure Microsoft Defender SmartScreen:** Enabled
- **Prevent bypassing of Microsoft Defender SmartScreen warnings about downloads:** Enabled

![Endpoint Security Policy Configuration](./01%20-%20Endpoint%20Security%20Policy/32-Intune%20Firewall%20Policy%20Configuration%20Settings%281%29.png)

*Figure 2 — Configuration settings included in the endpoint security policy.*

---

## 02 - Firewall Configuration

After creating the policy, I checked the Windows client to make sure the firewall was enabled.

The Windows Security **Firewall & network protection** page showed:

- **Domain network:** Firewall is on
- **Private network:** Firewall is on
- **Public network:** Firewall is on

The Domain network was the active network profile.

![Windows Firewall Policy Applied](./02%20-%20Firewall%20Configuration/34-Windows%20Firewall%20Policy%20Applied%281%29.png)

*Figure 3 — Windows Firewall showing the Domain, Private and Public network firewalls enabled.*

---

## 03 - Policy Assignment

I checked the assignment status for:

`WIN11-Endpoint-Security`

The report showed:

- **Pending:** 0
- **Not applicable:** 0
- **Success:** 1
- **Error:** 0
- **Conflict:** 0
- **Total:** 1

The device listed in the report was:

`WIN11-CLIENT01`

The last active user was:

`areddy@thousiflab.onmicrosoft.com`

The assignment status was:

**Success**

![Intune Endpoint Security Assignment Success](./03%20-%20Policy%20Assignment/35-Intune%20Endpoint%20Security%20Assignment%20Success%281%29.png)

*Figure 4 — WIN11-Endpoint-Security applied to WIN11-CLIENT01.*

---

## 04 - Firewall Verification

I did the final firewall check directly on the Windows client using an elevated Command Prompt.

The command I used was:

```cmd
netsh advfirewall show domainprofile
```

The Domain Profile showed:

```text
State                     ON
```

The firewall policy was:

```text
BlockInbound,AllowOutbound
```

The output also showed:

```text
InboundUserNotification    Enable
RemoteManagement           Disable
UnicastResponseToMulticast Enable
```

The local firewall rules and local security rules were shown as:

```text
N/A (GPO-store only)
```

The command completed and returned:

```text
Ok.
```

![Domain Firewall Policy Applied](./04%20-%20Firewall%20Verification/36-Domain%20Firewall%20Policy%20Applied%281%29.png)

*Figure 5 — Domain Firewall profile verified from Command Prompt with netsh.*

I checked the firewall locally as well so the final verification was not based only on the Intune portal.

---

## Result

The endpoint security policy was assigned to `WIN11-CLIENT01` and the Intune report showed **Success**.

On the Windows client, the Domain, Private and Public firewall profiles were enabled.

The final `netsh` check showed:

- Domain Profile: **ON**
- Inbound: **Block**
- Outbound: **Allow**

This completed the endpoint security and firewall setup for the Windows client.