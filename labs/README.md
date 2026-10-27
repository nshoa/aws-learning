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
| **SQS** | [01 - Dead-Letter Queue & Redrive](sqs/01_dead_letter_queue.md) | DLQ with max receives, DLQ redrive | Beginner | 15 min |
| **SNS** | [01 - Topic with an Email Subscription](sns/01_email_subscription.md) | Standard topic, confirm email, publish | Beginner | 15 min |
| **Kinesis** | [01 - Data Streams with the CLI](kinesis/01_data_streams_cli.md) | Provisioned stream, put-record, shard iterator, get-records | Beginner | 20 min |
| **Data Firehose** | [01 - Kinesis Data Stream to S3](firehose/01_kinesis_data_streams_to_s3.md) | Firehose stream, IAM role, buffer interval, S3 delivery | Beginner | 25 min |
| **CloudWatch** | [01 - Logs Metric Filter](cloudwatch/01_logs_metric_filter.md) | Lambda logs, metric filter, custom metric | Beginner | 20 min |
| **CloudWatch** | [02 - Logs Live Tail](cloudwatch/02_logs_live_tail.md) | Watch log events in real time (needs CloudWatch 01) | Beginner | 10 min |
| **CloudWatch** | [03 - Alarm that Terminates an EC2 Instance](cloudwatch/03_alarm_terminate_ec2.md) | CPU alarm, EC2 action, set-alarm-state from CloudShell | Beginner | 20 min |
| **X-Ray** | [01 - Trace the Scorekeep App on ECS](xray/01_scorekeep_tracing.md) | CloudFormation stack, X-Ray daemon, trace map, traces | Intermediate | 30 min |
| **Lambda** | [01 - Function Behind an Application Load Balancer](lambda/01_lambda_with_alb.md) | Lambda target group, ALB listener, HTTP event and response | Beginner | 25 min |
| **Lambda** | [02 - Run a Function Every Minute with EventBridge Scheduler](lambda/02_lambda_with_eventbridge_schedule.md) | Rate-based schedule, scheduler execution role, scheduled event in logs | Beginner | 15 min |
| **Lambda** | [03 - Trigger a Function from an S3 Event Notification](lambda/03_lambda_with_s3_event_notification.md) | S3 event notification, object-created event, resource-based policy | Beginner | 15 min |
| **Lambda** | [04 - Event Source Mapping with an SQS Queue](lambda/04_lambda_event_source_mapping_sqs.md) | SQS trigger, execution role permissions, SQS event, message deletion | Beginner | 20 min |
| **Lambda** | [05 - Destinations for Asynchronous Invocations](lambda/05_lambda_destinations.md) | On-success and on-failure SQS destinations, async retries, destination records | Beginner | 25 min |
| **Lambda** | [06 - Timeout and Initialization Outside the Handler](lambda/06_lambda_performance.md) | Default 3 s timeout, init code outside the handler, cold vs warm starts | Beginner | 15 min |
| **Lambda** | [07 - Add a Library with a Layer](lambda/07_lambda_layers.md) | `ImportModuleError` without pandas, AWS SDK for pandas managed layer | Beginner | 15 min |
| **CloudFormation** | [Infrastructure as Code](cloud_formation/README.md) | Provision EC2 declaratively | Intermediate | — |

## Conventions

- Screenshots live in [`shared_assets/<service>/`](https://github.com/nshoa/aws-learning/tree/main/labs/shared_assets) and are
    referenced with **relative paths** so they render on GitHub.
- 🔒 Redact account IDs, distribution IDs, and personal bucket names before
    committing screenshots or policy JSON.
- 💸 Always finish the **Cleanup** section — most labs use billable resources.
