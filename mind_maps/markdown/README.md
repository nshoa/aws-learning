# Mind Maps as Markdown

Text versions of the mind map images in [`../images`](../images), one file per topic.
Each file is a plain Markdown outline (`#` = root, `##` = main branch, `###` = sub-branch, bullets = leaves),
so it reads fine on GitHub and also renders as an interactive mind map with [Markmap](https://markmap.js.org).

| # | Topic | File |
|---|-------|------|
| 1 | EC2 | [EC2.md](EC2.md) |
| 2 | Databases | [Databases.md](Databases.md) |
| 3 | Route 53 | [Route53.md](Route53.md) |
| 4 | Amazon S3 | [S3.md](S3.md) |
| 5 | CloudFront & Global Accelerator | [CloudFrontGlobalAccelerator.md](CloudFrontGlobalAccelerator.md) |
| 6 | Storage Extra | [StorageExtra.md](StorageExtra.md) |
| 7 | Decoupling: SQS, SNS, Kinesis, Active MQ | [DecouplingApplications.md](DecouplingApplications.md) |
| 8 | Containers: ECS, Fargate, ECR & EKS | [Containers.md](Containers.md) |
| 9 | Serverless Architecture | [ServerlessArchitecture.md](ServerlessArchitecture.md) |
| 10 | Data & Analytics | [DataAnalytics.md](DataAnalytics.md) |
| 11 | Machine Learning | [MachineLearning.md](MachineLearning.md) |
| 12 | Monitoring & Audit | [MonitoringAudit.md](MonitoringAudit.md) |
| 13 | IAM | [IAM.md](IAM.md) |
| 14 | Security & Encryption | [SecurityEncryption.md](SecurityEncryption.md) |
| 15 | Networking - VPC | [Networking.md](Networking.md) |
| 16 | Disaster Recovery & Migration | [DisasterRecoveryAndMigration.md](DisasterRecoveryAndMigration.md) |

## View as an interactive mind map

- **Website:** <https://nshoa.github.io/aws-learning/> has every map as an interactive page (click to expand, scroll to zoom).
  It is rebuilt and deployed by [`.github/workflows/pages.yml`](../../.github/workflows/pages.yml) whenever these files change on `main`.
- **Build locally:** `make site`, then open `_site/index.html`.
- **VS Code:** install the *Markmap* extension and open any file.

Architecture diagrams from the images are summarised as text lines starting with "Diagram:" or "Flow:".
