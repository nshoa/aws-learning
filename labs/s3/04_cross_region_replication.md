### S3 Cross-Region Replication (CRR)

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

![image.png](attachment:9d96b2e1-aeed-49ec-92bb-52c00f75deea:image.png)

---

### 2. Replication Rule

1. **Source Bucket** > **Management** > **Create replication rule**.
2. **Scope:** Apply to all objects.
3. **Destination:** Choose your `us-west-2` bucket.
4. **IAM Role:** Select **Create new role** (S3 handles permissions automatically).

![image.png](attachment:cebce2a7-c5d6-4f50-9ca0-3fc47b7af0bd:image.png)

![image.png](attachment:7e3e1754-382b-4746-b5f4-b2ff6dc1af19:image.png)

---

### 3. Verification & Logic

- **Upload:** Adding `index.html` to Source ⮕ Automatically appears in Destination.
- **Delete:**
    - Simple delete in Source ⮕ Creates a **Delete Marker**.
    - **Important:** By default, S3 **does not** replicate delete markers. The file will remain visible in the Destination bucket.

![image.png](attachment:7bc3cfd9-ded9-4ac1-bfc0-baa700e9b50b:image.png)

![image.png](attachment:a9ec8788-8ae0-4a93-b294-37e77d651599:image.png)

---

### 🧹 Cleanup

- [x]  Delete all versions in both buckets.
- [x]  Delete buckets.
- [x]  Delete the auto-generated IAM Role