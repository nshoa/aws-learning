---
title: Disaster Recovery and Migration
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# Disaster Recovery and Migration

## Disaster Recovery (DR) Fundamentals on AWS

### Overview

- Definition: Any event negatively impacting a company's business continuity or finances.
- Purpose: Preparing for and recovering from a disaster.
- Timeline: RPO (data loss) ← Disaster → RTO (downtime)

### Types of Disaster Recovery Scenarios

- On-premise to On-premise: Traditional DR, often expensive.
- On-premise to AWS Cloud: Hybrid recovery.
- AWS Cloud Region A to AWS Cloud Region B.

### Key Metrics for DR

- **Recovery Point Objective (RPO)**: The maximum acceptable amount of data loss measured in time.
- **Recovery Time Objective (RTO)**: The maximum acceptable downtime for a system after a disaster.

## Disaster Recovery Strategies on AWS

### Spectrum of DR Strategies

- Backup & Restore → Pilot Light → Warm Standby → Multi-Site, in order of increasing RTO/RPO performance (faster RTO) and complexity/cost.

### Backup & Restore

- Characteristics: Typically associated with higher RPO and RTO.
- Process: Data is backed up from a corporate data center to AWS (e.g., S3, Glacier via Storage Gateway or Snowball) or within AWS (e.g., EBS snapshots, RDS snapshots to S3). Resources like EC2 instances (from AMIs) and RDS are restored from these backups in the DR region.

### Pilot Light

- Concept: A small version of the application's critical core is always running in the cloud.
- Functionality: Faster RTO than Backup & Restore as critical systems (e.g., database like RDS) are already running. EC2 instances might be set up but not running until a disaster. Data replication is key.
- Suited for: Critical core components of an application.
- Scenario question: Recommended when only critical infrastructure is needed up and running in AWS, and a longer RTO is acceptable.
- Diagram: Corporate data center → Route 53 → AWS Cloud (EC2 not running, RDS running ← data replication)

### Warm Standby

- Concept: A scaled-down version of the full system is running in the DR region.
- Functionality: Upon disaster, the system is scaled up to production load. Involves services like Route 53 for DNS failover, ELB, EC2 Auto Scaling (at minimum capacity), and data replication (e.g., Master DB to RDS Slave).
- Scenario question: Chosen when a scaled-down system is running and needs to scale up quickly during a disaster.

### Multi-Site / Hot Site Approach

- Concept: A full production scale of the application is running in both the primary and DR locations (on-premise and AWS, or AWS to AWS).
- Characteristics: Offers very low RTO (minutes or seconds) but is the most expensive.
- Architecture (On-premise to AWS): Active-active setup using Route 53, ELB, EC2 Auto Scaling (production scale), and data replication to an RDS slave.
- Architecture (All AWS Multi-Region): Active-active setup across regions using Route 53, ELB, EC2 Auto Scaling (production scale), and data replication (e.g., Aurora Global master to slave).
- Scenario question: Chosen for the lowest RTO and RPO, regardless of cost.

### Disaster Recovery Tips

- **Backup**: Utilize EBS Snapshots, RDS automated backups/Snapshots. Regularly push data to S3/S3 IA/Glacier with Lifecycle Policies and Cross Region Replication. Use Snowball or Storage Gateway for on-premise data.
- **High Availability (HA)**: Use Route 53 for DNS migration between regions. Employ RDS Multi-AZ, ElastiCache Multi-AZ, EFS, S3 for service resilience. Site-to-Site VPN can serve as a recovery option for Direct Connect.
- **Replication**: Use RDS Cross-Region Replication, AWS Aurora Global Databases. Replicate databases from on-premise to RDS. Storage Gateway can also facilitate replication.
- **Automation**: Use CloudFormation or Elastic Beanstalk to recreate environments. Recover/reboot EC2 instances with CloudWatch alarms. Use AWS Lambda for custom automation.
- **Chaos Engineering**: Test resilience by randomly terminating resources (e.g., Netflix's "simian-army" terminating EC2 instances).

## AWS Database Migration Service (DMS)

### Overview

- Purpose: Enables quick and secure migration of databases to AWS.
- Characteristics: Resilient and self-healing. The source database remains available during migration.
- Architecture: An EC2 instance runs the DMS replication tasks, connecting a source DB to a target DB.
    - Source DB → EC2 Instance running DMS → Target DB

### Supported Migrations

- Homogeneous migrations: e.g., Oracle to Oracle.
- Heterogeneous migrations: e.g., Microsoft SQL Server to Aurora.

### DMS Sources

- On-Premises and EC2 instances databases: Oracle, MS SQL Server, MySQL, MariaDB, PostgreSQL, MongoDB, SAP, DB2.
- Azure: Azure SQL Database.
- Amazon RDS: All types, including Aurora.
- Amazon S3.
- DocumentDB.

### DMS Targets

- On-Premises and EC2 instances databases: Oracle, MS SQL Server, MySQL, MariaDB, PostgreSQL, SAP.
- Amazon RDS.
- Redshift, DynamoDB, S3.
- OpenSearch Service.
- Kinesis Data Streams.
- Apache Kafka.
- DocumentDB & Amazon Neptune.
- Redis & Babelfish.

### AWS Schema Conversion Tool (SCT)

- Source DB (Oracle) → DMS + SCT → Target DB (MySQL, different engine)
- Purpose: Converts database schema from one engine to another. Used in conjunction with DMS for heterogeneous migrations.
- Usage: Not needed for migrating the same DB engine (e.g., On-Premise PostgreSQL to RDS PostgreSQL).
- Scenario question: For Oracle on-premises to Aurora migration, use SCT for schema conversion and DMS for data migration.
- Examples
    - OLTP: SQL Server or Oracle to MySQL, PostgreSQL, Aurora.
    - OLAP: Teradata or Oracle to Redshift.

### Continuous Data Replication (CDC)

- Functionality: DMS supports continuous data replication using CDC.
- Diagram: Shows data migration (full load + CDC) via AWS DMS Replication Instance and schema conversion via a server with AWS SCT installed, from an on-premise Oracle DB to Amazon RDS for MySQL.

### Multi-AZ Deployment for DMS

- Concept: When Multi-AZ is enabled, DMS provisions and maintains a synchronous standby replica in a different Availability Zone.
- Benefits: Provides data redundancy, eliminates I/O freezes, and minimizes latency spikes.

## RDS & Aurora Migrations

### RDS MySQL to Aurora MySQL

- **Option 1 (Snapshot)**: Restore DB snapshots from RDS MySQL as an MySQL Aurora DB cluster. This is often considered the best and most cost-effective way.
- **Option 2 (Read Replica)**: Create an Aurora Read Replica from your RDS MySQL. When replication lag is zero, promote it to its own DB cluster (can take time and cost).
- **Scenario question**: Migrating from RDS for MySQL to Aurora for MySQL for better performance and manageability.

### External MySQL to Aurora MySQL

- **Option 1 (Backup to S3)**: Use Percona XtraBackup to create a file backup in Amazon S3, then create an Aurora MySQL DB from this S3 backup.
- **Option 2 (mysqldump)**: Create an Aurora MySQL DB and use the `mysqldump` utility to migrate MySQL into Aurora (slower than the S3 method).
- **Option 3 (DMS)**: Use DMS if both databases are up and running.

### RDS PostgreSQL to Aurora PostgreSQL

- **Option 1 (Snapshot)**: Restore DB snapshots from RDS PostgreSQL as a PostgreSQL Aurora DB cluster.
- **Option 2 (Read Replica)**: Create an Aurora Read Replica from your RDS PostgreSQL. When replication lag is zero, promote it to its own DB cluster (can take time and cost).

### External PostgreSQL to Aurora PostgreSQL

- **Option 1 (Backup to S3)**: Create a backup and put it in Amazon S3. Import it using the `aws_s3` Aurora extension.
- **Option 2 (DMS)**: Use DMS if both databases are up and running.

## AWS Backup

### Overview

- Definition: A fully managed service to centrally manage and automate backups across AWS services.
- Purpose: Eliminates the need for custom scripts and manual backup processes. Helps support regulatory compliance or business policies for data protection.
- Diagram: AWS Backup creates a Backup Plan (frequency, retention policy) which then assigns AWS resources (EC2, EBS, S3, RDS, DynamoDB, DocumentDB, EFS, Aurora, Neptune, FSx, Storage Gateway) to be automatically backed up to Amazon S3.
- Scenario question: Used for an easy way to manage backups across multiple AWS services from a single place.

### Supported Services

- Amazon EC2 / Amazon EBS
- Amazon S3
- Amazon RDS (all DB engines) / Amazon Aurora / Amazon DynamoDB
- Amazon DocumentDB / Amazon Neptune
- Amazon EFS / Amazon FSx (Lustre & Windows File Server)
- AWS Storage Gateway (Volume Gateway)

### Key Features

- Cross-region backups.
- Cross-account backups.
- Point-in-Time Recovery (PITR) for supported services.
- On-Demand and Scheduled backups.
- Tag-based backup policies.

### Backup Plans (Backup Policies)

- Backup frequency (every 12 hours, daily, weekly, monthly, cron expression).
- Backup window.
- Transition to Cold Storage (Never, Days, Weeks, Months, Years).
- Retention Period (Always, Days, Weeks, Months, Years).

### AWS Backup Vault Lock

- Purpose: Enforces a WORM (Write Once Read Many) state for all backups in the AWS Backup Vault.
- Protection: Adds an additional layer of defense against inadvertent or malicious deletions, and updates that shorten or alter retention periods.
- Security: Even the root user cannot delete backups when enabled.
- Diagram: A backup is stored in a Backup Vault with a Lock Policy ensuring backups can't be deleted.

## Application Migration Service (MGN)

### Overview

- Purpose: A lift-and-shift (rehost) solution to simplify migrating applications to AWS.
- Evolution: Replaces AWS Server Migration Service (SMS); "AWS evolution" of CloudEndure Migration.
- Functionality: Converts physical, virtual, and cloud-based servers to run natively on AWS.
- Benefits: Supports a wide range of platforms, Operating Systems, and databases; minimal downtime; reduced costs.
- Scenario question: Used for lift-and-shift migration of websites, applications, servers, VMs, and data to AWS with minimum downtime and reduced costs.

### Migration Process with MGN

- Diagram: AWS Replication Agent is installed on source servers (OS, Apps, DB, Disks) in a Corporate Data Center/Any cloud. Continuous replication occurs to a staging area in AWS (low-cost EC2 instances & EBS volumes). A cutover then transitions to production (Target EC2 instances & EBS volumes) within the Application Migration Service.

### AWS Application Discovery Service (ADS)

- Purpose: Plans migration projects by gathering information about on-premises data centers. Gathers server utilization and dependency mappings.
- **Agentless Discovery (AWS Agentless Discovery Connector)**
    - Gathers: VM inventory, configuration, and performance history (CPU, memory, disk usage).
- **Agent-based Discovery (AWS Application Discovery Agent)**
    - Gathers: System configuration, system performance, running processes, and details of network connections between systems.
    - Data Management: Resulting data can be viewed within AWS Migration Hub.

## Other Migration & DR Considerations

### On-Premises Strategies with AWS

- Amazon Linux 2 AMI: Can be downloaded as a VM (.iso format) for VMWare, KVM, VirtualBox, Microsoft Hyper-V.
- VM Import/Export: Migrate existing applications into EC2. Create a DR repository for on-premises VMs. VMs can be exported back from EC2 to on-premises.
- AWS Server Migration Service (SMS) (being replaced by MGN): Incremental replication of on-premises live servers to AWS.

### Transferring Large Datasets into AWS

- Scenario: Transferring 200 TB with a 100 Mbps internet connection.
- **Over Internet / Site-to-Site VPN**
    - Setup: Immediate.
    - Time: ~185 days for 200TB at 100 Mbps.
- **Over Direct Connect (1 Gbps)**
    - Setup: Long (over a month).
    - Time: ~18.5 days for 200TB at 1 Gbps.
- **Ongoing Replication/Transfers**
    - Site-to-Site VPN or Direct Connect with DMS or DataSync.
- **Over Snowball**
    - Process: Uses 2-3 Snowballs in parallel.
    - Time: ~1 week for end-to-end transfer.
    - Combination: Can be combined with DMS.

### VMware Cloud on AWS

- Concept: Allows customers using VMware to manage their on-premises Data Center to extend their capacity to AWS while continuing to use VMware Cloud software.
- Architecture: Customer Data Center (with On-Premises vCenter, vSphere, NSX, VSAN) connects to VMware Cloud on AWS (running on Amazon EC2 bare metal), which can then integrate with other AWS services (S3, Direct Connect, FSx, RDS, Redshift).
- Scenario question: Used when a company wants to extend their VMware-based on-premises data center to AWS while keeping their VMware technology stack.
- Use Cases
    - Migrate VMware vSphere-based workloads to AWS.
    - Run production workloads.
    - Implement a disaster recovery strategy.
