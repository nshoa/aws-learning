# S3 Lab: Static Website Hosting

[← Labs index](../README.md) · **Service:** S3 · **Level:** Beginner · **Est. time:** 20 min · **Est. cost:** Free tier

**Reference:** [Udemy DVA-C01 - S3 Static Website Hosting](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/34353456#lecture-article)

## Contents

- [Objectives](#objectives)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [References](#references)

## Objectives

- [ ] Enable the **Static website hosting** feature on a bucket.
- [ ] Allow public reads with Block Public Access + a bucket policy.
- [ ] Upload web assets and open the live website endpoint.

## Prerequisites

- An AWS account with S3 permissions.
- An S3 bucket you own (**S3 Console** > **Create bucket**, default settings).
- A local `index.html` and an `images/` folder referenced by it with relative paths.
- AWS CLI configured (`aws configure`) for the verification commands.

## Steps

### 1. Enable Website Hosting

1. Open your bucket > **Properties** tab.
2. Scroll to **Static website hosting** and click **Edit**.
3. Select **Enable** and set **Index document** to `index.html`.
4. Click **Save changes**.
5. Copy the **Bucket website endpoint** shown at the bottom of the Properties tab, for
   example `http://YOUR-BUCKET-NAME.s3-website-us-east-1.amazonaws.com`.

### 2. Allow Public Access

By default S3 blocks all public access, which also blocks a public website.

1. Go to the **Permissions** tab.
2. Under **Block public access (bucket settings)**, click **Edit**.
3. **Uncheck** "Block all public access".
4. Click **Save changes** and type `confirm`.

### 3. Add a Public Read Bucket Policy

1. Still in **Permissions**, scroll to **Bucket policy** and click **Edit**.
2. Paste the following policy, replacing `YOUR-BUCKET-NAME` with your bucket name:

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

3. Click **Save changes**.

### 4. Upload the Site

1. Go to the **Objects** tab and click **Upload**.
2. Add `index.html` and the `images/` folder, then click **Upload**.

> 💡 Website endpoints are **HTTP only**. For HTTPS and a CDN in front of the bucket, see the
> [CloudFront lab](../cloudfront/01_cloudfront_distribution_with_s3_origin.md).

## Verification

- Open the **Bucket website endpoint** in a browser. The page renders and the images load.
- From a terminal:

  ```bash
  curl -sI http://YOUR-BUCKET-NAME.s3-website-us-east-1.amazonaws.com | head -n 1
  # Expected: HTTP/1.1 200 OK
  ```

- Confirm the website configuration:

  ```bash
  aws s3api get-bucket-website --bucket YOUR-BUCKET-NAME
  # Expected: "IndexDocument": { "Suffix": "index.html" }
  ```

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `403 Forbidden` | Block Public Access still on, or no bucket policy | Redo steps 2 and 3 |
| `404 Not Found` | `index.html` missing, or uploaded under a different name/case | Check the object key is exactly `index.html` at the bucket root |
| Page loads but images are broken | Image paths are absolute or the folder was not uploaded | Use relative paths (`images/logo.png`) and upload the folder |
| Endpoint URL does not resolve | Using the Object URL instead of the website endpoint | Copy the endpoint from **Properties** > **Static website hosting** |

## Cleanup

> 💸 Delete billable resources to avoid surprise charges.

- [ ] Delete the uploaded objects.
- [ ] Disable **Static website hosting** and delete the bucket policy.
- [ ] Turn **Block all public access** back on (or delete the bucket).

## References

- [Hosting a static website using Amazon S3 (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [Website endpoints (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteEndpoints.html)
