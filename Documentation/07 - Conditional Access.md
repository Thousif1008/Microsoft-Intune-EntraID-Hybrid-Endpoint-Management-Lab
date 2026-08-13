# 07 - Conditional Access

I created a Conditional Access policy to require the Windows device to be compliant for the policy evaluation. I first kept the policy in Report-only mode, then tested it by making the device noncompliant and checking the result. After restoring compliance, I checked the policy again.

The policy used in the lab was:

`WIN11-CA-Require-Compliant-Device`

---

## 01 - Policy Configuration

A Conditional Access policy was created in Microsoft Entra ID with the name:

`WIN11-CA-Require-Compliant-Device`

The policy was configured in **Report-only** mode.

The policy targeted:

- **Users, agents or workload identities:** 1 group
- **Excluded identities:** 0 users, 0 groups, 0 roles
- **Included resources:** All resources
- **Device platform:** Windows
- **Requirement for access:** Require device to be marked as compliant
- **Client apps:** 1 included

![Conditional Access Policy Configuration](./01%20-%20Policy%20Configuration/49-Conditional%20Access%20Policy%20Configuration.png)

*Figure 1 — WIN11-CA-Require-Compliant-Device configured in Report-only mode with the RequireCompliantDevice grant control.*

The policy checked the device's compliance state during the sign-in.

---

## 02 - Policy Validation

I checked the sign-in activity from Microsoft Entra ID.

The report-only evaluation showed:

**Policy:** `WIN11-CA-Require-Compliant-Device`

**Grant control:** `RequireCompliantDevice`

**Result:** `Report-only: Success`

![Conditional Access Report-Only Success](./02%20-%20Policy%20Validation/50-Conditional%20Access%20Report-Only%20Success.png)

*Figure 2 — Conditional Access evaluated successfully in Report-only mode.*

A normal Windows sign-in was not useful for testing this policy because the custom Conditional Access policy was **Not Applicable** there. I used **OneDrive** for the cloud-application test instead.

---

## 03 - Noncompliant Test

I then tested the policy with the Windows client in a noncompliant state by temporarily turning off the **Private** and **Public** firewall profiles. The **Domain** firewall remained on.

The `WIN11-Compliance-Policy` report showed:

- **Compliant:** 0
- **Noncompliant:** 1
- **Others:** 0
- **Total:** 1

The affected device was:

`WIN11-CLIENT01`

The user shown for the device was:

`Arjun Reddy`

![WIN11-CLIENT01 Noncompliant](./03%20-%20Noncompliant%20Test/51-WIN11-CLIENT01%20Noncompliant.png)

*Figure 3 — WIN11-CLIENT01 reported as noncompliant.*

With the device now noncompliant, I checked the Conditional Access evaluation again.

The policy was:

`WIN11-CA-Require-Compliant-Device`

with the grant control:

`RequireCompliantDevice`

The result changed to:

**Report-only: Failure**

![Conditional Access Noncompliant Failure](./03%20-%20Noncompliant%20Test/52-Conditional%20Access%20Noncompliant%20Failure.png)

*Figure 4 — Conditional Access evaluation failed when the device was noncompliant.*

The CA result changed to **Failure** because the device was no longer compliant.

### Compliance Restored

The device was then brought back into a compliant state.

The compliance report showed the device as compliant again.

![WIN11-CLIENT01 Compliance Restored](./03%20-%20Noncompliant%20Test/53-WIN11-CLIENT01%20Compliance%20Restored.png)

*Figure 5 — WIN11-CLIENT01 returned to a compliant state.*

I checked the Conditional Access evaluation again.

The policy returned to:

**Report-only: Success**

![Conditional Access Compliance Restored](./03%20-%20Noncompliant%20Test/54-Conditional%20Access%20Compliance%20Restored.png)

*Figure 6 — Conditional Access returned to a successful result after device compliance was restored.*

---

## Result

The test flow was:

`WIN11-CA-Require-Compliant-Device` created in Report-only mode

→ compliant device evaluated successfully

→ Private and Public firewall profiles temporarily turned off

→ device became noncompliant

→ compliance report showed **1 noncompliant device**

→ Conditional Access evaluation changed to **Report-only: Failure**

→ firewall settings were restored

→ device compliance was restored

→ Conditional Access evaluation returned to **Report-only: Success**

The policy remained in **Report-only** mode during the documented test. The screenshots therefore show the Conditional Access evaluation changing with the device's compliance state, not a live access block.