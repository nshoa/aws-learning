# ☁️ AWS Learning

[![CI](https://github.com/nshoa/aws-learning/actions/workflows/ci.yml/badge.svg)](https://github.com/nshoa/aws-learning/actions/workflows/ci.yml)

My study repository for AWS certifications — visual mind maps, quick-recall
cheatsheets, hands-on labs, and exam practice. Built mostly while following
Stephane Maarek's courses (SAA-C03 / DVA-C01).

## 📚 What's inside

| Section | What it is | Start here |
|---------|-----------|-----------|
| 🧠 [Mind Maps](mind_maps/) | XMind visual maps for **16 topic areas** (EC2, S3, VPC, IAM, …) — the big picture | [mind_maps/README.md](mind_maps/README.md) |
| 📒 [Cheatsheets](cheatsheets/) | One-page service summaries for fast exam recall | [cheatsheets/README.md](cheatsheets/README.md) |
| 🧪 [Labs](labs/) | Step-by-step console & CLI labs (EC2, IAM, S3, CloudFront, CloudFormation) | [labs/README.md](labs/README.md) |
| 📝 [Exam Practice](exam_practices/) | Practice questions & reasoning, by certification | [exam_practices/README.md](exam_practices/README.md) |
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
├── mind_maps/         # XMind source (.xmind) + exported images
├── exam_practices/    # Practice questions per exam (CLF-C02, …)
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

## ✍️ Adding content

New lab, cheatsheet, or note? Copy the matching file from [`templates/`](templates/)
(see the [authoring guide](templates/README.md)) so it follows the house style — TOC,
breadcrumb, metadata, cleanup — then run `make lint`.

## 🎯 Certification scope

| Exam | Coverage in this repo |
|------|----------------------|
| **SAA-C03** — Solutions Architect Associate | Mind maps (all 16 topics), labs, cheatsheets |
| **DVA-C01** — Developer Associate | S3 & CloudFront labs |
| **CLF-C02** — Cloud Practitioner | Exam practice (in progress) |

---

*Personal study notes — not affiliated with or endorsed by Amazon Web Services.*
