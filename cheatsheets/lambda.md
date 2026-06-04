# ☁️ Lambda - Serverless Functions

[← Cheatsheets index](README.md)

## 📝 Summary (one sentence)

Run code without managing servers (serverless/FaaS); pay only for execution time.

---

### 🎯 Use Cases

- Event-driven processing: trigger on an S3 upload or a DynamoDB write.
- Backend for a REST API (paired with API Gateway).
- Scheduled tasks (cron jobs) via EventBridge.

---

### 🔑 Core Concepts

- **Function:** A self-contained unit of code.
- **Trigger / Event Source:** The service that invokes the function (S3, SQS, API Gateway, ...).
- **Execution Role:** The IAM role granting the function permission to access other resources.
- **Concurrency:** Number of simultaneous executions (reserved/provisioned can be configured).
- **Cold Start & Layers:** First-invocation startup latency; shared libraries.

---

### 🆚 Comparisons & Keywords

- **Comparisons:**
    - **Lambda vs. EC2:** FaaS (no server management) vs IaaS (you manage the OS).
    - **Lambda vs. Fargate:** Both are serverless; Lambda is per-request/event, Fargate runs long-lived containers.
- **Keywords:** "serverless", "event-driven", "pay per use", "FaaS".

---

### ⚠️ Exam Tips / Gotchas

- Maximum execution time is **15 minutes** (not for long-running tasks).
- RAM from **128MB → 10GB**; CPU scales **proportionally** with RAM.
- Functions are **stateless** — persist state externally (S3, DynamoDB).
- Grant permissions via an **Execution Role**, not hardcoded credentials.
