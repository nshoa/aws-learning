# ☁️ EC2 - Elastic Compute Cloud

[← Cheatsheets index](README.md)

## 📝 Summary (one sentence)

A service that provides resizable virtual servers whose configuration and capacity you can tailor on demand.

---

### 🎯 Use Cases

- Running web applications and game servers.
- High-performance computing (HPC) workloads.
- Hosting the backend for mobile apps.

---

### 🔑 Core Concepts

- **AMI (Amazon Machine Image):** Template used to launch an instance (contains the OS and software).
- **Instance Types:** Hardware profiles (CPU, RAM, network). E.g. t2.micro, m5.large.
- **Security Groups:** A virtual firewall at the instance level, controlling inbound/outbound traffic.
- **EBS (Elastic Block Store):** Network-attached disk for EC2.
- **Pricing Models:** On-Demand, Reserved, Spot, Savings Plans.

---

### 🆚 Comparisons & Keywords

- **Comparisons:**
    - **EC2 vs. Lambda:** EC2 is a virtual server (IaaS) where you manage the OS. Lambda is serverless (FaaS) where you just ship code.
    - **EC2 vs. Beanstalk:** Beanstalk is a PaaS that automates the deployment and management of EC2.
- **Keywords:** "virtual server", "IaaS", "full control of the OS", "root access".

---

### ⚠️ Exam Tips / Gotchas

- **Security Groups** are stateful; **NACLs** are stateless.
- You cannot shrink an EBS volume after it has been created.
- Instance metadata is available at `169.254.169.254`.
