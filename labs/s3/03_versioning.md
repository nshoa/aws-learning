### S3 Versioning

**Ref:** [Udemy DVA-C01](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/23743652#lecture-article)

---

### Lab Objectives

- [ ]  Enable Versioning on an S3 bucket.
- [ ]  Observe behavior when overwriting existing files.
- [ ]  Understand the Delete Marker mechanism.

---

### 1. Enable Versioning

1. Select your S3 Bucket.
2. Go to the **Properties** tab.
3. Under **Bucket Versioning**, click **Edit** and select **Enable**.
4. Click **Save changes**.

---

### 2. Overwriting Objects (Upload Test)

1. Upload a file named `index.html`.
2. Edit the local `index.html` file and upload it again to the same bucket.
3. **Observation:**
    - S3 creates a new object version with a unique `version_id`.
    - The new file becomes the "Current version."
    - Accessing the object URL always returns the most recent version.

---

### 3. Deleting Objects (Delete Marker Test)

1. Select an image or file in your bucket.
2. Click **Delete** and confirm.
3. **Observation:**
    - S3 does not erase the file; it creates a **Delete Marker** as the new "Current version."
    - Accessing the file now results in a **404 Not Found** error.
    - To "Undelete," toggle **Show versions**, delete the Delete Marker, and the previous version becomes active again.

---

### 🧹 Cleanup

- [ ]  Toggle **Show versions** in the bucket.
- [ ]  Select all versions and delete markers.
- [ ]  Delete all objects permanently to avoid storage costs.