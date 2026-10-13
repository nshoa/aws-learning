# IAM Lab: Users, Groups & Least-Privilege Policies

[← Labs index](../README.md) · **Service:** IAM · **Level:** Beginner · **Est. time:** 20 min · **Est. cost:** Free

**Reference:** [Udemy SAA-C03 - IAM](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c03/)

## Contents

- [Objectives](#objectives)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [References](#references)

## Objectives

- [ ] Create a **group** and attach a managed policy to it.
- [ ] Create a **user** that gets its permissions from the group, not directly.
- [ ] Prove **least privilege** by testing an allowed and a denied action.
- [ ] Understand why an **explicit Deny** always wins.

## Prerequisites

- An AWS account and an IAM identity that can manage IAM users and groups.
- AWS CLI configured (`aws configure`) for the optional CLI verification.

## Steps

### 1. Create a Group with Permissions

1. Open the **IAM Console** > **User groups** > **Create group**.
2. **Group name:** `ReadOnly-Developers`.
3. Under **Attach permissions policies**, select **`AmazonS3ReadOnlyAccess`**.
4. Click **Create group**.

> 🔑 Attach policies to **groups**, not individual users. Users inherit the permissions of
> every group they belong to.

### 2. Create a User

1. Go to **Users** > **Create user**. **User name:** `dev-alice`.
2. Check **Provide user access to the AWS Management Console** and set a password.
3. On **Set permissions**, choose **Add user to group** and select `ReadOnly-Developers`.
4. Click **Create user** and copy the **console sign-in URL**.

### 3. (Optional) Create an Access Key for CLI Testing

1. Open `dev-alice` > **Security credentials** > **Create access key** > **Command Line
   Interface (CLI)**, and copy the key pair.
2. Configure a profile:

   ```bash
   aws configure --profile dev-alice
   ```

### 4. Concept: Explicit Deny Wins

If a user has `AmazonS3ReadOnlyAccess` (Allow) **and** a policy that denies `s3:*`, every S3
request is denied: an explicit `Deny` overrides any `Allow`.

> **Default deny → an Allow grants access → an explicit Deny overrides everything.**

## Verification

- Sign in as `dev-alice` with the sign-in URL in a private browser window, then try:

  | Action | Expected result | Why |
  |--------|-----------------|-----|
  | Open **S3** and list buckets | ✅ Allowed | `AmazonS3ReadOnlyAccess` grants read actions |
  | **Create** an S3 bucket | ❌ Access denied | The read-only policy has no `s3:CreateBucket` |
  | Open **EC2** > **Instances** | ❌ Not authorized | No EC2 permissions were granted |

- The same checks from the CLI (if you did step 3):

  ```bash
  aws sts get-caller-identity --profile dev-alice
  # Expected: "Arn": "arn:aws:iam::<account-id>:user/dev-alice"

  aws s3 ls --profile dev-alice
  # Expected: your bucket list

  aws s3 mb s3://dev-alice-test-$RANDOM --profile dev-alice
  # Expected: make_bucket failed ... An error occurred (AccessDenied)

  aws ec2 describe-instances --profile dev-alice
  # Expected: An error occurred (UnauthorizedOperation)
  ```

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `dev-alice` can create buckets | The user has another policy attached (directly or via another group) | Check **Permissions** on the user and remove extra policies |
| Console sign-in fails | Using the root sign-in page instead of the account sign-in URL | Use the URL from step 2, or choose **IAM user** and enter the account ID |
| CLI says `InvalidClientTokenId` | Profile not configured, or the key was deleted | Re-run `aws configure --profile dev-alice` with an active key |

## Cleanup

- [ ] Delete `dev-alice`'s access key (if created) and the `dev-alice` profile from
  `~/.aws/credentials`.
- [ ] Delete the user `dev-alice`.
- [ ] Delete the group `ReadOnly-Developers`.

## References

- [IAM user groups (AWS docs)](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html)
- [Policy evaluation logic (AWS docs)](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html)
- [Security best practices in IAM (AWS docs)](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
