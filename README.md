# ☁️ AWS Learning

[![CI](https://github.com/hoans-swe/aws-learning/actions/workflows/ci.yml/badge.svg)](https://github.com/hoans-swe/aws-learning/actions/workflows/ci.yml)

My study repository for everything AWS — visual mind maps, quick-recall
cheatsheets, and hands-on labs. It started with the Solutions Architect Associate
(SAA-C03) course, is now growing with the Developer Associate (DVA-C02) course, and
will keep collecting notes from every new AWS course I take.

Content is organized **by AWS service, not by course**: when a new course covers a
service again, its notes extend the same mind map, cheatsheet, or lab series.

📖 **Read it as a website:** <https://hoans-swe.github.io/aws-learning/> (searchable, with
[interactive mind maps](https://hoans-swe.github.io/aws-learning/mind-maps/)).

## 📚 What's inside

| Section | What it is | Start here |
|---------|-----------|-----------|
| 🧠 [Mind Maps](mind_maps/) | Markdown mind maps for **17 topic areas** (EC2, S3, VPC, IAM, …), interactive on the website — the big picture | [mind_maps/README.md](mind_maps/README.md) |
| 📒 [Cheatsheets](cheatsheets/) | One-page service summaries for fast exam recall | [cheatsheets/README.md](cheatsheets/README.md) |
| 🧪 [Labs](labs/) | Step-by-step console & CLI labs (EC2, IAM, S3, CloudFront, SQS, SNS, Kinesis, Data Firehose, CloudWatch, X-Ray, Lambda, DynamoDB, API Gateway, CloudFormation) | [labs/README.md](labs/README.md) |
| 🧩 [Templates](templates/) | Reusable doc templates + house style (for humans & LLMs) | [templates/README.md](templates/README.md) |

## 🗂️ Repository structure

```text
aws-learning/
├── cheatsheets/       # Quick service summaries (exam recall)
├── config/            # Lint configs (cfn-lint, yamllint, markdownlint)
├── labs/              # Hands-on labs (Objectives → Steps → Verify → Cleanup)
│   ├── ec2/
│   ├── iam/
│   ├── s3/
│   ├── cloudfront/
│   ├── cloud_formation/   # Infrastructure-as-Code templates + lab
│   └── shared_assets/      # Screenshots referenced by the labs
├── mind_maps/         # Markdown mind maps (markdown/) + diagrams (images/); xminds/ = archived XMind, not used
└── templates/         # Reusable doc templates (lab, cheatsheet, note, …)
```

## 🚀 Getting started

**Just browsing?** Start with the [mind maps](mind_maps/README.md) for the big
picture, skim the relevant [cheatsheet](cheatsheets/README.md), then do the
matching [lab](labs/README.md).

**Running the CloudFormation labs?** You'll need the [AWS CLI](https://aws.amazon.com/cli/)
configured (`aws configure`). Then:

```bash
make deploy TEMPLATE=ec2-only STACK=ec2-only-lab   # create
make delete STACK=ec2-only-lab                      # tear down
```

> 💸 Labs create real, billable resources. Every lab ends with a **🧹 Cleanup**
> section — always run it.

## 🛠️ Local development

This repo is linted in CI (CloudFormation, YAML, Markdown, links). To run the
same checks locally:

```bash
make install   # installs cfn-lint, yamllint, pre-commit + git hooks
make lint      # cfn-lint + yamllint + markdownlint
```

| Command | Does |
|---------|------|
| `make validate` | Lint CloudFormation templates (`cfn-lint`) |
| `make yaml` | Lint all YAML (`yamllint`) |
| `make markdown` | Lint all Markdown (`markdownlint`) |
| `make lint` | All of the above |
| `make site` | Build the website into `_site/` (needs `pip install -r requirements-docs.txt` and Node) |
| `make serve` | Preview the website locally with live reload |

## ✍️ Adding content

New lab, cheatsheet, or note? Copy the matching file from [`templates/`](templates/)
(see the [authoring guide](templates/README.md)) so it follows the house style — TOC,
breadcrumb, metadata, cleanup — then run `make lint`.

## 🎯 Courses & coverage

| Course | Status | What it added |
|--------|--------|---------------|
| **SAA-C03** — Solutions Architect Associate | ✅ Studied | Mind maps (all 16 topics), cheatsheets, EC2 / IAM / S3 / CloudFront labs |
| **DVA-C02** — Developer Associate | 🚧 In progress | Deeper Lambda, DynamoDB and API Gateway theory and a new CI/CD mind map; SQS, SNS, Kinesis, Data Firehose, CloudWatch, X-Ray, Lambda, DynamoDB, API Gateway and CloudFormation labs |
| *Next AWS courses* | 🔜 Planned | Added here as I study them |

---

*Personal study notes — not affiliated with or endorsed by Amazon Web Services.*
