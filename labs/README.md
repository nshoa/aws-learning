# 🧪 Hands-on Labs

[← Repo home](../README.md) · ✍️ Adding a lab? Start from [`templates/lab.md`](../templates/lab.md).

Step-by-step labs to practice AWS services in the console and CLI. Every lab
follows the same shape: **Objectives → Prerequisites → Steps → Verification →
Troubleshooting → Cleanup → References**. Verification includes CLI commands with the
expected output, and Cleanup makes sure you tear down what you create.

## Index

| Service | Lab | Focus | Level | Time |
|---------|-----|-------|-------|------|
| **EC2** | [01 - Launch an EC2 instance](ec2/01_launch_ec2_instance.md) | Launch, connect, user-data web server | Beginner | 20 min |
| **IAM** | [01 - Users, Groups & Policies](iam/01_users_groups_policies.md) | Least privilege, group-based permissions | Beginner | 20 min |
| **S3** | [01 - Bucket Policies](s3/01_bucket_policies.md) | Block Public Access vs bucket policy | Beginner | 15 min |
| **S3** | [02 - Static Website Hosting](s3/02_static_website_hosting.md) | Host a static site | Beginner | 20 min |
| **S3** | [03 - Versioning](s3/03_versioning.md) | Object versions and delete markers | Beginner | 15 min |
| **S3** | [04 - Cross-Region Replication](s3/04_cross_region_replication.md) | CRR between buckets | Intermediate | 20 min |
| **S3** | [05 - Storage Classes & Lifecycle](s3/05_storage_classes_and_life_cycle.md) | Tiering and lifecycle rules | Beginner | 15 min |
| **S3** | [06 - Event Notifications to SQS](s3/06_event_notification.md) | S3 → SQS event messages | Intermediate | 20 min |
| **S3** | [07 - Encryption](s3/07_encryption.md) | SSE-S3 / SSE-KMS | Beginner | 15 min |
| **S3** | [08 - CORS](s3/08_cors.md) | Cross-origin requests | Intermediate | 30 min |
| **S3** | [09 - MFA Delete](s3/09_mfa_delete.md) | Protect versions from permanent deletion | Intermediate | 20 min |
| **CloudFront** | [01 - Distribution with S3 Origin (OAC)](cloudfront/01_cloudfront_distribution_with_s3_origin.md) | CDN over a private bucket | Beginner | 30 min |
| **CloudFront** | [02 - Cache Invalidation](cloudfront/02_cache_invalidation.md) | Invalidate cached objects (needs CloudFront 01) | Beginner | 20 min |
| **CloudFormation** | [Infrastructure as Code](cloud_formation/README.md) | Provision EC2 declaratively | Intermediate | — |

## Conventions

- Screenshots live in [`shared_assets/<service>/`](shared_assets) and are
  referenced with **relative paths** so they render on GitHub.
- 🔒 Redact account IDs, distribution IDs, and personal bucket names before
  committing screenshots or policy JSON.
- 💸 Always finish the **Cleanup** section — most labs use billable resources.
