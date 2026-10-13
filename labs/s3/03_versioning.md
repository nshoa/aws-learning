# S3 Lab: Versioning

[← Labs index](../README.md) · **Service:** S3 · **Level:** Beginner · **Est. time:** 15 min · **Est. cost:** Free tier

**Reference:** [Udemy DVA-C01 - S3 Versioning](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/23743652#lecture-article)

## Contents

- [Objectives](#objectives)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [References](#references)

## Objectives

- [ ] Enable **Versioning** on an S3 bucket.
- [ ] Observe what happens when you overwrite an existing object.
- [ ] Understand the **Delete Marker** and use it to "undelete" an object.

## Prerequisites

- An AWS account with S3 permissions.
- An S3 bucket you own (**S3 Console** > **Create bucket**, default settings).
- A local `index.html` file.
- AWS CLI configured (`aws configure`) for the verification commands.

## Steps

### 1. Enable Versioning

1. Open your bucket > **Properties** tab.
2. Under **Bucket Versioning**, click **Edit** and select **Enable**.
3. Click **Save changes**.

> 💡 Once enabled, versioning can only be **suspended**, never fully turned off. Objects
> uploaded before enabling it keep the version ID `null`.

### 2. Overwrite an Object

1. Upload `index.html`.
2. Edit the local file (change some text) and upload it again with the same name.
3. Turn on **Show versions** in the object list. There are now two versions of
   `index.html`, each with its own **Version ID**; the newest is the current version.

### 3. Delete and Restore an Object

1. With **Show versions** turned **off**, select `index.html` and click **Delete**.
2. Turn **Show versions** on. S3 did not erase anything: it added a **Delete marker** as the
   new current version, and the older versions are still there.
3. To "undelete", select the **Delete marker** row and delete it (permanently). The previous
   version becomes current again.

## Verification

- List every version and delete marker of the object:

  ```bash
  aws s3api list-object-versions --bucket YOUR-BUCKET-NAME --prefix index.html \
    --query '{Versions: Versions[].[VersionId,IsLatest], DeleteMarkers: DeleteMarkers[].[VersionId,IsLatest]}'
  # After step 3.2: two Versions, one DeleteMarker with IsLatest = true
  # After step 3.3: two Versions, no DeleteMarkers, newest Version IsLatest = true
  ```

- Confirm versioning is on:

  ```bash
  aws s3api get-bucket-versioning --bucket YOUR-BUCKET-NAME
  # Expected: "Status": "Enabled"
  ```

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Only one version after re-uploading | Versioning was not enabled before the second upload | Enable it (step 1) and upload again |
| Deleting removed a version permanently instead of adding a marker | **Show versions** was on, so a specific version was deleted | Turn **Show versions** off before a normal delete |
| Object still shows `404` after "undelete" | A different delete marker is still current | Run the verification command and remove the marker with `IsLatest = true` |

## Cleanup

> 💸 Every version is stored and billed separately.

- [ ] Turn on **Show versions**, select all versions and delete markers, and delete them
  permanently (or use **Empty bucket**).
- [ ] Delete the bucket if you created it only for this lab.

## References

- [Retaining multiple versions of objects with S3 Versioning (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html)
- [Working with delete markers (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/DeleteMarker.html)
