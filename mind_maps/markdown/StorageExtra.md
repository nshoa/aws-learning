---
title: Storage Extra
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# Storage Extra

## AWS Snowball

### Overview
- Highly-secure, portable devices to collect and process data at the edge, and migrate data into and out of AWS.
- Part of the AWS Snow Family for offline data transfers.
- Effective solution for
  - limited connectivity.
  - bandwidth challenges.
  - high network cost.
  - shared bandwidth.
  - connection stability.

### Usage Process
1. Request Snowball devices via AWS Console.
2. Install Snowball Client / AWS OpsHub on your servers.
3. Connect Snowball device to servers and copy files using the client.
4. Ship back the device to AWS facilities after use.
5. Data is loaded into an Amazon S3 bucket.
6. Snowball is completely wiped after the process.
- Flow: Client → AWS Snowball → *ship* → AWS Snowball → import/export → S3 Bucket

### Edge Computing
- Process data as it's created at edge locations (e.g., trucks, ships, mining stations).
- Ideal for locations with limited or no internet access.
- Supports running EC2 instances or AWS Lambda functions at the edge.
- **Devices**
  - **Snowcone**: 2 CPUs, 4GB memory, wired or wireless access.
  - **Snowball Edge**
    - Compute Optimized.
    - Storage Optimized.
- **Use cases**
  - preprocess data.
  - machine learning.
  - media transcoding.

### Integration with Glacier
- Snowball cannot directly import to Amazon Glacier.
- Requires importing into Amazon S3 first, then leveraging a lifecycle policy to transition data to Glacier.
- Flow: Snowball → *import* → Amazon S3 → *S3 lifecycle policy* → Amazon Glacier

## Amazon FSx

### Overview
- Fully managed service to launch third-party high-performance file systems on AWS.
- Types
  - FSx for Lustre.
  - FSx for NetApp ONTAP.
  - FSx for Windows File Server.
  - FSx for OpenZFS.

### FSx for Windows File Server
- Fully-managed Windows file system with Server Message Block (SMB) protocol and NTFS support.
- Integration with Microsoft Active Directory, ACLs, and user quotas.
- Supports Distributed File System (DFS) Namespaces.
- Can be mounted on Linux EC2 instances.
- Backup to S3, Multi-AZ capabilities, and on-premises accessibility.
- Storage options
  - SSD: Low latency for workloads like databases, analytics, and media processing.
  - HDD: Ideal for broad workloads like CMS and home directories.

### FSx for Lustre
- Parallel distributed file system designed for high-performance computing.
- Scales to 100s GB/s throughput, sub-ms latencies, and millions of IOPS.
- Seamless integration with Amazon S3 for reading and writing data.
- Supports on-premises deployment via VPN or AWS Direct Connect.
- Storage options
  - SSD: Low-latency, IOPS-intensive workloads.
  - HDD: Throughput-intensive, large sequential workloads.

### Other FSx Services
- **FSx for NetApp ONTAP**
  - Managed NetApp ONTAP compatible with NFS, SMB, and iSCSI.
  - Offers snapshots, compression, replication, and data de-duplication.
  - Works with Linux, Windows, macOS, and VMware environments.
  - Provides point-in-time cloning.
  - Clients: EC2, ECS, EKS, VMware Cloud on AWS, Amazon AppStream 2.0, Amazon WorkSpaces, On-Premises Server
- **FSx for OpenZFS**
  - Managed ZFS file system supporting NFS protocol (v3, v4, v4.1, v4.2).
  - Ideal for workloads running on Open ZFS.
  - Offers high performance with 1,000,000 IOPS and 0.5ms latency.
  - Supports snapshots, compression, and point-in-time cloning.

### Deployment Options
- **Scratch File System**
  - Temporary storage with high burst throughput.
  - Non-replicated storage; data does not persist on file server failures.
- **Persistent File System**
  - Long-term storage with replication within the same AZ.
  - Replaces failed files in minutes.

## AWS Transfer Family

### Overview
- Fully managed service for file transfers into and out of AWS S3/EFS.
- Protocols: FTP, FTPS, SFTP.
- Supports AWS-native credential storage or external authentication (e.g., AD, LDAP, Amazon Cognito).
- Useful for CRM, ERP, public data sharing.
- Flow: Users (FTP client) → Route 53 → AWS Transfer for SFTP / FTPS / FTP (only within VPC) → IAM Role → S3 / EFS; auth via MS Active Directory / LDAP

## AWS DataSync

### Overview
- Automate moving large data volumes to/from AWS via SMB, NFS, HDFS, or S3 APIs.
- Can migrate data across AWS services (e.g., S3 ↔ FSx).
- Supports all S3 storage classes and options like lifecycle policies or replication.
- Enables on-prem to AWS or intra-AWS sync without agents.
- Flow: On-premises NFS/SMB server → AWS DataSync Agent (or AWS Snowcone with agent pre-installed) → TLS → DataSync → AWS storage resources (S3 classes, EFS, FSx)

## Storage Comparisons

### Overview
- **S3**: Object-based storage.
- **S3 Glacier**: Archival storage.
- **EBS Volumes**: Network storage for single EC2 instances.
- **Instance Store**: Physical EC2 storage with extremely high IOPS.
- **EFS**: Network File System (Linux, POSIX compliant).
- **FSx**
  - For Windows File Server: SMB, NTFS, MSSQL support.
  - For Lustre: HPC workloads.
  - For NetApp ONTAP: High interoperability.
  - For OpenZFS: POSIX file system with advanced features.
- **AWS Snow Family**: Physical devices for offline migration or processing large datasets.
- **AWS Storage Gateway**: Hybrid bridge between on-prem and AWS storage.
- **AWS Transfer Family**: FTP family protocols to store files in S3/EFS.
- **AWS DataSync**: Scheduled data replication/synchronization.

## Hybrid Cloud for Storage

### Overview
- Mix of cloud and on-prem infrastructure due to long migrations, compliance, or IT strategies.
- AWS Storage Gateway bridges on-prem data and AWS cloud.
- Exposes S3 data as NFS/SMB protocols for on-prem access.
- Use cases
  - Disaster Recovery
  - Backup & Storage
  - Tiered Storage
  - On-Premises Cache & Low-latency Files Access

### Storage Gateway Options
- **S3 File Gateway**
  - Expose S3 buckets as NFS/SMB.
  - Supports caching of recently used data.
  - Bucket access controlled by IAM roles.
  - SMB protocol integrates with Active Directory.
  - Flow: Application server → NFS/SMB → S3 File Gateway → HTTPS → S3 (Standard, Standard-IA, One Zone-IA, Intelligent-Tiering) → lifecycle policy → S3 Glacier
- **FSx File Gateway**
  - Native access to FSx for Windows File Server.
  - Includes local caching.
  - Ideal for group file sharing.
- **Volume Gateway**
  - iSCSI protocol-backed block storage synced with S3.
  - Cached Volumes: Low-latency access to recent data.
  - Stored Volumes: On-premise datasets with scheduled S3 backups.
  - Backed by S3 bucket + Amazon EBS snapshots
- **Tape Gateway**
  - Virtual tape library (VTL) backed by Amazon S3 and Glacier.
  - Works with backup software while using existing tape-based processes.
  - Useful for backup/archival scenarios.
  - Virtual tapes stored in S3; archived tapes stored in Glacier
- **Storage Gateway - Hardware Appliance**
  - Physical device for NFS, Volume, and Tape Gateways.
  - Suitable for setups without virtualization infrastructure.
  - SSD cache resources for faster local access.
  - Gateway deployment options: VM (VMware, Hyper-V, KVM) or Hardware Appliance
