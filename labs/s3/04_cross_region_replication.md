### S3 Cross-Region Replication (CRR)

[← Labs index](../README.md) · **Service:** S3 · **Level:** Beginner

**Ref:** [Udemy DVA-C01](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/23743666#lecture-article)

---

### 🎯 Quick Goals

- [ ]  **Provision:** 2 Buckets in different regions.
- [ ]  **State:** Enable Versioning (Required).
- [ ]  **Automate:** Sync objects from Source to Destination.

---

### 1. Setup Buckets

| Bucket | Region | Versioning |
| --- | --- | --- |
| **Source** | `us-east-1` | **Enabled** |
| **Destination** | `us-west-2` | **Enabled** |

`[Screenshot: source & destination buckets with versioning enabled]`

---

### 2. Replication Rule

1. **Source Bucket** > **Management** > **Create replication rule**.
2. **Scope:** Apply to all objects.
3. **Destination:** Choose your `us-west-2` bucket.
4. **IAM Role:** Select **Create new role** (S3 handles permissions automatically).

`[Screenshot: creating the S3 replication rule]`

`[Screenshot: replication rule summary]`

---

### 3. Verification & Logic

- **Upload:** Adding `index.html` to Source ⮕ Automatically appears in Destination.
- **Delete:**
    - Simple delete in Source ⮕ Creates a **Delete Marker**.
    - **Important:** By default, S3 **does not** replicate delete markers. The file will remain visible in the Destination bucket.

`[Screenshot: object auto-replicated to destination]`

`[Screenshot: delete marker not replicated to destination]`

---

### 🧹 Cleanup

- [x]  Delete all versions in both buckets.
- [x]  Delete buckets.
- [x]  Delete the auto-generated IAM Role
