# S3 Lab: Cross-Region Replication (CRR)

[← Labs index](../README.md) · **Service:** S3 · **Level:** Intermediate · **Est. time:** 20 min · **Est. cost:** Low — storage in two regions plus inter-region transfer for a few small files

**Reference:** [Udemy DVA-C01 - S3 Replication](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/23743666#lecture-article)

## Contents

- [Objectives](#objectives)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [References](#references)

## Objectives

- [ ] Create two buckets in different regions, both with **Versioning** enabled (required).
- [ ] Configure a **replication rule** from source to destination.
- [ ] Observe that new objects replicate, and that delete markers do **not** by default.

## Prerequisites

- An AWS account with S3 and IAM permissions (the console creates an IAM role for you).
- AWS CLI configured (`aws configure`) for the verification commands.

## Steps

### 1. Create the Buckets

| Bucket | Region | Versioning |
| --- | --- | --- |
| **Source** | `us-east-1` | **Enabled** |
| **Destination** | `us-west-2` | **Enabled** |

Create both in the **S3 Console** and enable **Bucket Versioning** on each. Replication
cannot be configured unless both buckets are versioned.

### 2. Create the Replication Rule

1. Open the **source** bucket > **Management** tab > **Replication rules** >
   **Create replication rule**.
2. **Rule name:** `crr-to-us-west-2`, **Status:** Enabled.
3. **Rule scope:** Apply to all objects in the bucket.
4. **Destination:** Choose a bucket in this account > select your `us-west-2` bucket.
5. **IAM role:** Create new role (S3 adds the permissions it needs).
6. Leave **Delete marker replication** unchecked for now, and click **Save**.
7. When asked whether to replicate existing objects, choose **No**. Replication rules
   only apply to objects uploaded **after** the rule exists; existing objects need
   **S3 Batch Replication**.

### 3. Test Uploads and Deletes

1. Upload `index.html` to the **source** bucket. Within a minute it appears in the
   destination bucket.
2. Delete `index.html` in the source bucket (with **Show versions** off). The source gets a
   **delete marker**, but the object is still visible in the destination, because delete
   markers are not replicated unless you enable **Delete marker replication**.

## Verification

- After step 3.1 (before deleting), check the replication status on both sides:

  ```bash
  aws s3api head-object --bucket SOURCE-BUCKET --key index.html --query ReplicationStatus
  # Expected: "COMPLETED" (may show "PENDING" for a few seconds)

  aws s3api head-object --bucket DESTINATION-BUCKET --key index.html --query ReplicationStatus --region us-west-2
  # Expected: "REPLICA"
  ```

- After step 3.2, the destination still has the object and no delete marker:

  ```bash
  aws s3api list-object-versions --bucket DESTINATION-BUCKET --prefix index.html \
    --region us-west-2 --query 'length(DeleteMarkers || `[]`)'
  # Expected: 0
  ```

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| "Bucket versioning is required" when creating the rule | Versioning off on one of the buckets | Enable versioning on **both** buckets |
| Object never appears in the destination | It was uploaded before the rule existed | Upload it again, or use S3 Batch Replication |
| `ReplicationStatus` is `FAILED` | The replication role lacks permissions (often after editing it, or with SSE-KMS objects) | Recreate the rule with **Create new role**; for SSE-KMS objects, allow the destination KMS key |

## Cleanup

> 💸 Storage in both regions is billed until the buckets are emptied.

- [ ] Delete the replication rule on the source bucket.
- [ ] **Empty** both buckets (this removes all versions and delete markers), then delete them.
- [ ] Delete the IAM role the console created (named like `s3crr_role_for_SOURCE-BUCKET`).

## References

- [Replicating objects within and across Regions (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html)
- [Replicating delete markers between buckets (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-marker-replication.html)
- [Replicating existing objects with Batch Replication (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/s3-batch-replication-batch.html)
