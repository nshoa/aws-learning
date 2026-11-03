# 🧠 AWS Learning Mind Maps

[← Repo home](../README.md)

One mind map per AWS topic, written as **Markdown outlines** in [`markdown/`](markdown/README.md).
The Markdown files are the source of truth: they are updated as I study each course
(SAA-C03, DVA-C02, and future AWS courses) and embed self-drawn diagrams from [`images/`](images/).

> The original XMind maps (and their PNG exports) were retired: they only covered the
> SAA course and are no longer updated. They remain in the git history.

## How to read them

- **Interactive:** <https://hoans-swe.github.io/aws-learning/mind-maps/> renders every map
    with [Markmap](https://markmap.js.org) (click a node to expand or collapse it, scroll to zoom).
- **As a page:** open a topic below, on GitHub or on the website.
- **In VS Code:** install the *Markmap* extension and open any file in `markdown/`.

## Topics

| # | Topic | Mind map |
|---|-------|----------|
| 1 | EC2 | [EC2.md](markdown/EC2.md) |
| 2 | Databases | [Databases.md](markdown/Databases.md) |
| 3 | Route 53 | [Route53.md](markdown/Route53.md) |
| 4 | Amazon S3 | [S3.md](markdown/S3.md) |
| 5 | CloudFront & Global Accelerator | [CloudFrontGlobalAccelerator.md](markdown/CloudFrontGlobalAccelerator.md) |
| 6 | Storage Extra | [StorageExtra.md](markdown/StorageExtra.md) |
| 7 | Decoupling: SQS, SNS, Kinesis, Active MQ | [DecouplingApplications.md](markdown/DecouplingApplications.md) |
| 8 | Containers: ECS, Fargate, ECR & EKS | [Containers.md](markdown/Containers.md) |
| 9 | Serverless: Lambda, DynamoDB, API Gateway, … | [ServerlessArchitecture.md](markdown/ServerlessArchitecture.md) |
| 10 | Data & Analytics | [DataAnalytics.md](markdown/DataAnalytics.md) |
| 11 | Machine Learning | [MachineLearning.md](markdown/MachineLearning.md) |
| 12 | Monitoring & Audit: CloudWatch, X-Ray, CloudTrail, Config | [MonitoringAudit.md](markdown/MonitoringAudit.md) |
| 13 | IAM | [IAM.md](markdown/IAM.md) |
| 14 | Security & Encryption | [SecurityEncryption.md](markdown/SecurityEncryption.md) |
| 15 | Networking - VPC | [Networking.md](markdown/Networking.md) |
| 16 | Disaster Recovery & Migration | [DisasterRecoveryAndMigration.md](markdown/DisasterRecoveryAndMigration.md) |

## Adding content

- Add new theory to the matching topic file (organized by service, not by course); start a
    new file only for a new topic, then add it to the table above, to
    [`markdown/README.md`](markdown/README.md) and to the `mkdocs.yml` nav.
- Outline format: `#` = root, `##` = main branch, `###` = sub-branch, bullets = leaves.
- Diagrams go in [`images/`](images/) as `<TopicName>.png` and are embedded as a bullet:
    `- ![what it shows](../images/<TopicName>.png)`.
- Link to other pages with absolute site URLs (`https://hoans-swe.github.io/aws-learning/…`),
    so the links also work in the interactive Markmap pages.
