# S3 Lab: Bucket Policies

[← Labs index](../README.md) · **Service:** S3 · **Level:** Beginner · **Est. time:** 15 min · **Est. cost:** Free tier

**Reference:** [Udemy DVA-C01 - S3 Bucket Policies](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/19729152#lecture-article)

## Contents

- [Objectives](#objectives)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [References](#references)

## Objectives

- Make a bucket publicly readable with a bucket policy.
- Explain why **Block Public Access** overrides any public bucket policy.
- Explain why `s3:GetObject` needs the `bucket/*` resource, not the bucket ARN.

## Prerequisites

- An AWS account with S3 permissions.
- An S3 bucket you own. Create one in the **S3 Console** > **Create bucket** with default
    settings (bucket names are globally unique).
- AWS CLI configured (`aws configure`) for the verification commands.

## Steps

### 1. Disable Block Public Access

Before a public policy can take effect, the "safety switch" must be turned off.

1. Open your bucket > **Permissions** tab.
2. Under **Block public access (bucket settings)**, click **Edit**.
3. **Uncheck** "Block all public access".
4. Click **Save changes** and type `confirm`.

### 2. Attach a Public Read Policy

1. Scroll down to **Bucket policy** and click **Edit**.
2. Paste the following policy, replacing `YOUR-BUCKET-NAME` with your bucket name. It lets
    anyone on the internet read (`s3:GetObject`) every object in the bucket:

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

3. Click **Save changes**. A red **Publicly accessible** label now appears on the bucket.

> 💡 The `/*` at the end of the ARN matters: `s3:GetObject` applies to **objects**, so the
> resource must be `bucket/*`, not just the bucket ARN.

### 3. Upload a Test Object

1. Upload a file (for example `test.jpg`) to the bucket.
2. Open the object and copy its **Object URL**.

## Verification

- Open the **Object URL** in a private/incognito window. The file loads without an AWS login.
- From a terminal (no credentials needed, it is an anonymous request):

    ```bash
    curl -sI https://YOUR-BUCKET-NAME.s3.amazonaws.com/test.jpg | head -n 1
    # Expected: HTTP/1.1 200 OK
    ```

- Confirm S3 itself considers the bucket public:

    ```bash
    aws s3api get-bucket-policy-status --bucket YOUR-BUCKET-NAME
    # Expected: "IsPublic": true
    ```

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `403 Forbidden` on the Object URL | Block Public Access is still on | Repeat step 1, then save the policy again |
| "Policy has invalid resource" when saving | Resource is the bucket ARN without `/*` | Use `arn:aws:s3:::YOUR-BUCKET-NAME/*` |
| "Access denied" when saving the policy | Account-level Block Public Access is enabled | Check **S3** > **Block Public Access settings for this account** |

## Cleanup

> 💸 Delete billable resources to avoid surprise charges.

- [ ] Delete the bucket policy.
- [ ] Re-enable **Block all public access**.
- [ ] Delete the test objects (and the bucket, if you created it only for this lab).

## References

- [Bucket policy examples (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html)
- [Blocking public access to your Amazon S3 storage (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)
