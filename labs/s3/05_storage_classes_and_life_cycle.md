### S3 Storage Classes & Lifecycle

**Ref:** [Udemy DVA-C01](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/23743672#lecture-article)

---

### 🎯 Lab Objectives

- [ ]  Upload an object directly to a non-default storage class.
- [ ]  Manually transition an existing object's storage tier.
- [ ]  Automate transitions using **Lifecycle Rules**.

---

### 1. Upload with Specific Class

1. Go to your **S3 Bucket** > click **Upload**.
2. Add any file.
3. Scroll down to **Properties** > **Storage class**.
4. Select `Standard-IA` (Infrequent Access) or `Intelligent-Tiering`.
5. Click **Upload**.
    - *Result:* The object is initialized in the selected class, bypassing the default "Standard" tier.

---

### 2. Manual Storage Class Change

1. Select your uploaded object in the bucket list.
2. Click **Actions** > **Edit storage class**.
3. Choose a new tier (e.g., change from `Standard-IA` to `One Zone-IA`).
4. Click **Save changes**.
    - *Note:* S3 creates a "copy" of the object metadata to apply the new storage tier.

---

### 3. Automation: Lifecycle Rules

1. Go to **Management** tab > **Lifecycle rules** > **Create lifecycle rule**.
2. **Rule Name:** `ArchiveOldLogs`.
3. **Scope:** Apply to all objects (or use a prefix like `logs/`).
4. **Lifecycle Rule Actions:** - Move current versions of objects between storage classes.
5. **Transitions:**
    - Move to `Standard-IA` after **30 days**.
    - Move to `Glacier Flexible Retrieval` after **90 days**.
6. Click **Create rule**.

---

### 🧹 Cleanup

- [ ]  Delete lifecycle rules.
- [ ]  Delete test objects to stop storage charges.