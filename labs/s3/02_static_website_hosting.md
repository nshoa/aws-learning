### S3 Static Website Hosting

**Ref:** [Udemy DVA-C01](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/34353456#lecture-article)

---

### Lab Objectives

- [ ]  Enable the Static Website Hosting feature.
- [ ]  Configure public access permissions.
- [ ]  Upload web assets and verify the live URL.

---

### 1. Enable Website Hosting

1. Go to the **Properties** tab of your bucket.
2. Scroll to the bottom to **Static website hosting** and click **Edit**.
3. Select **Enable**.
4. **Index document:** Type `index.html`.
5. Click **Save changes**.
    - *Note:* Copy the **Bucket website endpoint** URL that appears at the bottom of the properties page.

---

### 2. Configure Public Access

By default, S3 blocks all public access. You must disable this to host a website.

1. Go to the **Permissions** tab.
2. Under **Block public access (bucket settings)**, click **Edit**.
3. **Uncheck** "Block all public access".
4. Click **Save changes** and type `confirm`.

---

### 3. Add Bucket Policy

Now you must explicitly allow "Read" access to your objects using a JSON policy.

1. Still in the **Permissions** tab, scroll down to **Bucket policy** and click **Edit**.
2. Paste the following policy (Replace `YOUR-BUCKET-NAME` with your actual bucket name):
3. Click **Save changes**.


```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
        }
    ]
}
```

---

### 4. Upload Assets & Verify

1. Go to the **Objects** tab.
2. Click **Upload** and add your `index.html` and your **images folder**.
3. Once uploaded, open the **Bucket website endpoint** URL you copied in Step 1.
    - *Result:* Your website should now be live and images should load correctly.

---

### 🧹 Cleanup

- [ ]  Delete the uploaded objects.
- [ ]  Disable **Static website hosting** in Properties.
- [ ]  Turn **Block all public access** back ON.