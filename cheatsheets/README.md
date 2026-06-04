# 📒 AWS Service Cheatsheets

[← Repo home](../README.md) · ✍️ Adding one? Start from [`templates/cheatsheet.md`](../templates/cheatsheet.md).

Quick per-service summaries in a fixed template, handy for certification revision
(SAA-C03 / DVA-C01). Each file follows: one-sentence summary → Use Cases → Core
Concepts → Comparisons & Keywords → Exam Tips.

| Service | Cheatsheet | Summary |
|---------|-----------|---------|
| EC2 | [ec2.md](ec2.md) | Virtual servers (IaaS), AMIs, instance types, pricing models |
| S3 | [s3.md](s3.md) | Object storage, storage classes, versioning, encryption |
| IAM | [iam.md](iam.md) | Users/Groups/Roles, policies, least privilege |
| VPC | [vpc.md](vpc.md) | Subnets, route tables, SG vs NACL, NAT/IGW, endpoints |
| RDS | [rds.md](rds.md) | Managed SQL DB, Multi-AZ vs Read Replica, Aurora |
| Lambda | [lambda.md](lambda.md) | Serverless/FaaS, triggers, execution role, limits |

> 🧩 Visual mind maps for 16 topics live in [`../mind_maps`](../mind_maps).
> After studying a service, practice it in [`../labs`](../labs).

## ✍️ Template for a new cheatsheet

```markdown
# ☁️ <SERVICE> - <Full name>

## 📝 Summary (one sentence)

...

### 🎯 Use Cases

### 🔑 Core Concepts

### 🆚 Comparisons & Keywords

### ⚠️ Exam Tips / Gotchas
```
