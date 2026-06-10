### AWS Lab: IAM Users, Groups & Least-Privilege Policies

[← Labs index](../README.md) · **Service:** IAM · **Level:** Beginner

**Ref:** [Udemy SAA-C03 - IAM](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c03/)

---

### Lab Objectives

- [ ]  Create a **Group** and attach a managed policy to it.
- [ ]  Create a **User** and add them to the group (permissions via group, not user).
- [ ]  Verify **least privilege** by testing an allowed *and* a denied action.
- [ ]  Understand why **explicit Deny** always wins.

---

### 1. Create a Group with Permissions

1. Go to the **IAM Console** > **User groups** > **Create group**.
2. **Group name:** `ReadOnly-Developers`.
3. Under **Attach permissions policies**, search for and select
   **`AmazonS3ReadOnlyAccess`**.
4. Click **Create group**.

> 🔑 Best practice: attach policies to **groups**, not individual users. Users
> inherit permissions from their group(s).

---

### 2. Create a User

1. Go to **Users** > **Create user**.
2. **User name:** `dev-alice`.
3. Select **Provide user access to the AWS Management Console** (optional) and
   set a password — or skip console access for a CLI-only user.
4. On the permissions step, choose **Add user to group** and tick
   `ReadOnly-Developers`.
5. Finish and **download the credentials** (or copy the sign-in URL).

---

### 3. Test Least Privilege

Sign in as `dev-alice` (use the account sign-in URL in a private browser window),
then:

| Action | Expected result | Why |
|--------|-----------------|-----|
| Open **S3** and list buckets | ✅ Allowed | `AmazonS3ReadOnlyAccess` grants read |
| Try to **create** an S3 bucket | ❌ Access Denied | Read-only policy has no `s3:CreateBucket` |
| Open **EC2** and view instances | ❌ Access Denied | No EC2 permissions were granted |

This is **least privilege** in action: the user can do *only* what the policy
allows, nothing more.

---

### 4. (Concept) Explicit Deny Wins

If you attach **both** `AmazonS3ReadOnlyAccess` (Allow) and a policy that
**Denies** `s3:*`, the user is **denied** — an explicit `Deny` overrides any
`Allow`. This is the core of IAM policy evaluation:

> **Default Deny → an Allow grants access → an explicit Deny overrides everything.**

---

### 🧹 Cleanup

- [ ]  Delete the user `dev-alice`.
- [ ]  Delete the group `ReadOnly-Developers`.
- [ ]  (If created) delete any access keys you generated.
