### S3 Bucket Policies

[← Labs index](../README.md) · **Service:** S3 · **Level:** Beginner

**Ref:** [Udemy DVA-C01](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/19729152#lecture-article)

---

### Lab Objectives

- [ ]  Understand the difference between Block Public Access and Bucket Policies.
- [ ]  Create a JSON policy to grant public read access.
- [ ]  Attach the policy to an S3 bucket.

---

### 1. Disable Block Public Access

Before a public policy can take effect, the "safety switch" must be turned off.

1. Go to your **S3 Bucket** > **Permissions** tab.
2. Under **Block public access (bucket settings)**, click **Edit**.
3. **Uncheck** "Block all public access".
4. Click **Save changes** and type `confirm`.

---

### 2. Attach Public Read Policy

1. Scroll down to the **Bucket policy** section and click **Edit**.
2. Paste the following JSON (This policy allows anyone on the internet to view objects):

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

1. **Important:** Replace `YOUR-BUCKET-NAME` with your actual bucket name.
2. Click **Save changes**.
    - *Observation:* A red "Public" label should now appear next to your bucket name.

---

### 3. Verify Access

1. Upload a file (e.g., `test.jpg`) to the bucket.
2. Click on the file to view its **Object URL**.
3. Open the URL in an Incognito/Private browser window.
    - *Result:* The file should load successfully without requiring AWS login.

---

### 🧹 Cleanup

- [ ]  Delete the Bucket Policy.
- [ ]  Re-enable **Block all public access** (check the box).
- [ ]  Delete any uploaded test objects.
