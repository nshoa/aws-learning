# ☁️ RDS - Relational Database Service

[← Cheatsheets index](README.md)

## 📝 Summary (one sentence)

A fully managed relational database service that handles patching, backups, and high availability for you.

---

### 🎯 Use Cases

- OLTP applications and web apps that need a SQL database.
- Offloading operational burden (patching, backups) from DBAs.
- Needing high availability (HA) and read scalability.

---

### 🔑 Core Concepts

- **Engines:** MySQL, PostgreSQL, MariaDB, Oracle, SQL Server, **Aurora**.
- **Multi-AZ:** A synchronous **standby** replica in another AZ — for **HA/failover**.
- **Read Replicas:** **Asynchronous** replicas — for **read scaling**.
- **Automated Backups & Snapshots:** Point-in-time recovery (PITR).
- **Storage:** gp2/gp3 (SSD), io1 (high IOPS).

---

### 🆚 Comparisons & Keywords

- **Comparisons:**
    - **Multi-AZ vs. Read Replica:** HA (sync, no read scaling) vs read scaling (async).
    - **RDS vs. Aurora:** Aurora is a cloud-native engine (faster, 6 copies across 3 AZs).
    - **RDS vs. DynamoDB:** Relational (SQL) vs NoSQL.
- **Keywords:** "managed relational", "Multi-AZ failover", "read replica".

---

### ⚠️ Exam Tips / Gotchas

- **Multi-AZ = HA/disaster recovery** (NOT used for read scaling).
- **Read Replica = read scaling** (can be **cross-region**).
- Failover is automatic via the **DNS endpoint** (the connection string does not change).
- You **cannot SSH** into an RDS host (it is a managed service).
