# S3 Lab: Storage Classes & Lifecycle Rules

[← Labs index](../README.md) · **Service:** S3 · **Level:** Beginner · **Est. time:** 15 min · **Est. cost:** Low — infrequent-access classes bill a minimum of 30 days per object

**Reference:** [Udemy DVA-C01 - S3 Storage Classes & Lifecycle](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/23743672#lecture-article)

## Contents

- [Objectives](#objectives)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [References](#references)

## Objectives

- Upload into a non-default storage class and change the class of an existing object.
- Automate transitions with a **Lifecycle rule**.
- Explain the minimums that apply to Standard-IA and One Zone-IA (30 days of storage, 128 KB per object), and why transitions need objects at least 30 days old.

## Prerequisites

- An AWS account with S3 permissions.
- An S3 bucket you own (**S3 Console** > **Create bucket**, default settings).
- AWS CLI configured (`aws configure`) for the verification commands.

## Steps

### 1. Upload into a Specific Storage Class

1. Open your bucket and click **Upload**, then add any file.
2. Expand **Properties** > **Storage class** and select **Standard-IA**.
3. Click **Upload**. The object is stored in Standard-IA from the start instead of Standard.

> 💸 Standard-IA and One Zone-IA bill at least **30 days** of storage and at least **128 KB**
> per object, even if you delete it sooner. That is fine for a lab with small files, but it
> is why these classes are a poor fit for short-lived data.

### 2. Change an Object's Storage Class

1. Select the object and choose **Actions** > **Edit storage class**.
2. Choose **One Zone-IA** and click **Save changes**.

S3 applies the change by **copying the whole object** with the new storage class, so the
object gets a new *Last modified* date (and a new version, if versioning is on).

### 3. Automate with a Lifecycle Rule

1. Go to the **Management** tab > **Lifecycle rules** > **Create lifecycle rule**.
2. **Rule name:** `ArchiveOldLogs`.
3. **Rule scope:** Limit to a prefix, `logs/` (or apply to all objects and acknowledge
    the warning).
4. **Lifecycle rule actions:** check **Transition current versions of objects between
    storage classes**.
5. Add two transitions:
    - **Standard-IA** after **30** days.
    - **Glacier Flexible Retrieval** after **90** days.
6. Click **Create rule**.

> 💡 Transitions run asynchronously once a day, so nothing visible happens during the lab:
> this step is about configuring the rule correctly. S3 also requires objects to be at least
> 30 days old before moving to Standard-IA, which is why 30 is the smallest value accepted.

## Verification

- Check an object's storage class (Standard objects omit the field):

    ```bash
    aws s3api head-object --bucket YOUR-BUCKET-NAME --key YOUR-FILE --query StorageClass
    # Expected after step 1: "STANDARD_IA"
    # Expected after step 2: "ONEZONE_IA"
    ```

- Confirm the lifecycle rule:

    ```bash
    aws s3api get-bucket-lifecycle-configuration --bucket YOUR-BUCKET-NAME \
      --query 'Rules[].{ID:ID,Status:Status,Transitions:Transitions}'
    # Expected: ArchiveOldLogs, Enabled, transitions at 30 days (STANDARD_IA) and 90 days (GLACIER)
    ```

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `head-object` returns `null` for `StorageClass` | The object is in Standard (the field is omitted) | Re-check the class chosen during upload |
| Rule rejects a Standard-IA transition under 30 days | Minimum age for Standard-IA/One Zone-IA transitions is 30 days | Use 30 days or more |
| Objects have not moved after creating the rule | Lifecycle actions run asynchronously and only for objects older than the threshold | Expected — verify the rule configuration instead |

## Cleanup

> 💸 Delete billable resources to avoid surprise charges.

- [ ] Delete the lifecycle rule.
- [ ] Delete the test objects (the 30-day minimum charge for IA classes still applies).
- [ ] Delete the bucket if you created it only for this lab.

## References

- [Understanding and managing Amazon S3 storage classes (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html)
- [Transitioning objects using Amazon S3 Lifecycle (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-transition-general-considerations.html)
