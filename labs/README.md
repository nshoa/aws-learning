# 🧪 Hands-on Labs

[← Repo home](../README.md) · ✍️ Adding a lab? Start from [`templates/lab.md`](../templates/lab.md).

Step-by-step labs to practice AWS services in the console and CLI. Every lab
follows the same shape: **Objectives → Steps → Verification → 🧹 Cleanup** — so
you always tear down what you create and avoid surprise bills.

## Index

| Service | Lab | Focus |
|---------|-----|-------|
| **EC2** | [01 - Launch an EC2 instance](ec2/01_launch_ec2_instance.md) | Launch, connect, user-data web server |
| **IAM** | [01 - Users, Groups & Policies](iam/01_users_groups_policies.md) | Least-privilege, group-based permissions |
| **S3** | [01 - Bucket Policies](s3/01_bucket_policies.md) | Public access vs bucket policy |
| **S3** | [02 - Static Website Hosting](s3/02_static_website_hosting.md) | Host a static site |
| **S3** | [03 - Versioning](s3/03_versioning.md) | Object versions |
| **S3** | [04 - Cross-Region Replication](s3/04_cross_region_replication.md) | CRR between buckets |
| **S3** | [05 - Storage Classes & Lifecycle](s3/05_storage_classes_and_life_cycle.md) | Tiering & lifecycle rules |
| **S3** | [06 - Event Notifications](s3/06_event_notification.md) | S3 → SNS/SQS/Lambda events |
| **S3** | [07 - Encryption](s3/07_encryption.md) | SSE-S3 / SSE-KMS |
| **S3** | [08 - CORS](s3/08_cors.md) | Cross-origin requests |
| **S3** | [09 - MFA Delete](s3/09_mfa_delete.md) | Protect against deletion |
| **CloudFront** | [01 - Distribution with S3 Origin (OAC)](cloudfront/01_cloudfront_distribution_with_s3_origin.md) | CDN over a private bucket |
| **CloudFront** | [02 - Cache Invalidation](cloudfront/02_cache_invalidation.md) | Invalidate cached objects |
| **CloudFormation** | [Infrastructure as Code](cloud_formation/README.md) | Provision EC2 declaratively |

## Conventions

- Screenshots live in [`shared_assets/<service>/`](shared_assets) and are
  referenced with **relative paths** so they render on GitHub.
- 🔒 Redact account IDs, distribution IDs, and personal bucket names before
  committing screenshots or policy JSON.
- 💸 Always finish the **🧹 Cleanup** section — most labs use billable resources.
