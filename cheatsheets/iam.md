# ☁️ IAM - Identity and Access Management

[← Cheatsheets index](README.md)

## 📝 Summary (one sentence)

A **global** service that manages identities (who) and permissions (what they can do) for AWS resources.

---

### 🎯 Use Cases

- Creating users/groups and granting them permissions.
- Granting permissions to services (EC2, Lambda) via **Roles**.
- Cross-account access.

---

### 🔑 Core Concepts

- **User / Group:** Identity for humans; groups bundle permissions.
- **Role:** A "temporary" identity that is **assumed**, granting short-lived credentials via STS.
- **Policy:** A JSON document defining permissions (identity-based vs resource-based).
- **Least Privilege:** Grant only the minimum permissions required.
- **MFA & Access Keys:** Two-factor authentication; access keys for the CLI/SDK.

---

### 🆚 Comparisons & Keywords

- **Comparisons:**
    - **Role vs. User:** A role provides **temporary** credentials (no long-term keys) — preferred for applications/services.
    - **Identity-based vs. Resource-based policy:** Attached to an identity vs attached to a resource (e.g. an S3 bucket policy).
- **Keywords:** "least privilege", "AssumeRole", "temporary credentials", "STS".

---

### ⚠️ Exam Tips / Gotchas

- IAM is **global** (not Region-scoped).
- For apps on EC2, use an **IAM Role** — **never** hardcode access keys.
- An **explicit Deny** always overrides any Allow.
- Evaluation order: default Deny → an Allow grants access → unless an explicit Deny applies.
