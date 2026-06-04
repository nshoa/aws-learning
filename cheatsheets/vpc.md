# ☁️ VPC - Virtual Private Cloud

[← Cheatsheets index](README.md)

## 📝 Summary (one sentence)

A logically isolated virtual network in AWS where you have full control over the network topology.

---

### 🎯 Use Cases

- Isolating resources in a private network.
- Multi-tier architectures (public subnet for web, private subnet for DB).
- Hybrid connectivity to an on-premises data center.

---

### 🔑 Core Concepts

- **Subnet:** A sub-range within a single **AZ** (public or private).
- **Route Table:** Determines where traffic is directed.
- **Internet Gateway (IGW):** Internet egress for public subnets.
- **NAT Gateway:** Lets private subnets reach the internet outbound, but not inbound.
- **Security Group vs. NACL:** Firewall at the instance level vs the subnet level.
- **VPC Peering / Endpoint:** Connect VPCs; reach AWS services without the public internet.

---

### 🆚 Comparisons & Keywords

- **Comparisons:**
    - **Security Group vs. NACL:** SG is **stateful** (instance level, allow rules only). NACL is **stateless** (subnet level, both allow & deny).
    - **IGW vs. NAT Gateway:** IGW is bidirectional (public); NAT is outbound-only for private subnets.
- **Keywords:** "private subnet", "stateful/stateless", "isolated network".

---

### ⚠️ Exam Tips / Gotchas

- **SG is stateful**, **NACL is stateless** (you must open both inbound and outbound ephemeral ports).
- A **NAT Gateway** must sit in a **public subnet**.
- Each **subnet belongs to exactly one AZ**.
- **VPC Endpoint:** **Gateway** type (S3, DynamoDB) vs **Interface** type (everything else).
- The CIDRs of two peered VPCs **must not overlap**.
