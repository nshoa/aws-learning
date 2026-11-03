# 🧠 AWS Learning Mind Maps

[← Repo home](../README.md)

One mind map per AWS topic, written as **Markdown outlines** in [`markdown/`](markdown/README.md).
The Markdown files are the source of truth: they are updated as I study each course
(SAA-C03, DVA-C02, and future AWS courses) and embed self-drawn diagrams from [`images/`](images/).

> ⚠️ **The XMind maps are no longer used.** They are kept as an archive (see
> [XMind archive](#xmind-archive-no-longer-updated)) but are **not updated**: they only
> cover the SAA course. Always read and edit the Markdown files instead.

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
| 17 | CI/CD: CodeCommit, CodeBuild, CodeDeploy, CodePipeline | [CICD.md](markdown/CICD.md) |

## Adding content

- Add new theory to the matching topic file (organized by service, not by course); start a
    new file only for a new topic, then add it to the table above, to
    [`markdown/README.md`](markdown/README.md) and to the `mkdocs.yml` nav.
- Outline format: `#` = root, `##` = main branch, `###` = sub-branch, bullets = leaves.
- Diagrams go in [`images/`](images/) as `<TopicName>.png` and are embedded as a bullet:
    `- ![what it shows](../images/<TopicName>.png)`.
- Link to other pages with absolute site URLs (`https://hoans-swe.github.io/aws-learning/…`),
    so the links also work in the interactive Markmap pages.

## XMind archive (no longer updated)

> ⚠️ **Archived, not maintained.** These are the original XMind maps from the SAA-C03
> course and their PNG exports. They are kept for reference only and are **out of date**:
> newer content (e.g. the DVA-C02 Lambda, DynamoDB and API Gateway theory) exists only in
> the Markdown mind maps above. Do not edit them; add new content to the Markdown files.

| Topic | XMind source | PNG export |
|-------|--------------|------------|
| AWS Overview | [AWSOverview.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/AWSOverview.xmind) | [AmazonWebServices.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/AmazonWebServices.png) |
| EC2 | [EC2.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/EC2.xmind) | [EC2.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/EC2.png) |
| Databases | [Databases.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/Databases.xmind) | [DATABASES.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/DATABASES.png) |
| Route 53 | [ROUTE53.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/ROUTE53.xmind) | [ROUTE53.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/ROUTE53.png) |
| Amazon S3 | [S3.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/S3.xmind) | [S3.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/S3.png) |
| CloudFront & Global Accelerator | [Cloudfront&GlobalAccelerator.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/Cloudfront%26GlobalAccelerator.xmind) | [CloudFront&GlobalAccelerator.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/CloudFront%26GlobalAccelerator.png) |
| Storage Extra | [StorageExtra.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/StorageExtra.xmind) | [StorageExtra.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/StorageExtra.png) |
| Decoupling Applications | [DecouplingApplications.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/DecouplingApplications.xmind) | [DecouplingApplications.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/DecouplingApplications.png) |
| Containers | [Containers.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/Containers.xmind) | [Containers.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/Containers.png) |
| Serverless Architecture | [ServerlessArchitecture.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/ServerlessArchitecture.xmind) | [ServerlessArchitecture.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/ServerlessArchitecture.png) |
| Data & Analytics | [DataAnalytic.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/DataAnalytic.xmind) | [DataAnalytics.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/DataAnalytics.png) |
| Machine Learning | [MachineLearning.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/MachineLearning.xmind) | [MachineLearning.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/MachineLearning.png) |
| Monitoring & Audit | [MonitoringAudit.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/MonitoringAudit.xmind) | [MonitoringAudit.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/MonitoringAudit.png) |
| IAM | [IAM.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/IAM.xmind) | [IAM.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/IAM.png) |
| Security & Encryption | [SecurityEncryption.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/SecurityEncryption.xmind) | [SecurityEncryption.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/SecurityEncryption.png) |
| Networking - VPC | [Networking.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/Networking.xmind) | [Networking.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/Networking.png) |
| Disaster Recovery & Migration | [Disaste RecoveryandMigration.xmind](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/xminds/Disaste%20RecoveryandMigration.xmind) | [DisasterRecoveryAndMigration.png](https://github.com/hoans-swe/aws-learning/blob/main/mind_maps/images/DisasterRecoveryAndMigration.png) |
