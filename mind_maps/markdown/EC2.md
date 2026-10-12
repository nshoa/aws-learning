---
title: EC2
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# EC2

## EC2 Basics

### Key Concepts
- Renting Virtual Machines: Instances
- Storing Data: EBS, EFS, Instance Store
- Distributing Load: ELB
- Scaling Services: ASG

### Instance Configuration
- Operating System: Linux, Windows, MacOS
- Compute Power: CPU
- Memory: RAM
- Storage: Network-Attached (EBS, EFS), Hardware (EC2 Instance Store)
- Network Card: Speed, Public IP
- Firewall Rules: Security Groups
- Bootstrap Script: EC2 User Data

### EC2 User Data
- Automate boot tasks: Install updates, software, download files
- Runs **only once** at the first start
- Root user privileges

## EC2 Instance Types

### Naming Convention: e.g. m5.2xlarge
- m: instance type
- 5: generation
- 2xlarge: size within the instance type

### General Purpose
- **Balanced between: compute, memory and networking**
- Great for diversity of workloads
  - *Web servers*
  - *Code repositories*

### Compute Optimized
- **High performance processors**
- Great for compute-intensive tasks
  - *Batch processing workloads*
  - *Media transcoding*
  - *High performance web servers / computing*
  - *Science modeling & Machine learning*

### Memory Optimized
- **Large data sets in memory**
- Fast performance for workloads that process large datasets in memory
  - *High performance, relation/non-relation database*
  - *Distributed web scale cache stores*
  - *In-memory databases optimized for BI*
  - *Application performing real-time processing for big unstructured data*

### Storage Optimized
- **High, sequential read/write access**
- Great for storage-intensive tasks that required high, sequential read and write access to large datasets on local storage
  - High frequency online transaction processing (OLTP)
  - Relation & NoSQL databases
  - Cache for in-memory databases (e.g. Redis)
  - Data warehousing applications
  - Distributes file systems

## EC2 Networking

### IP Addressing
- Private IP: within VPC
- Public IP: internet accessible
- IPv4 & IPv6
- Elastic IP (static public IP)

### Elastic Network Interfaces (ENI)
- Virtual network card
- Attributes: private IPs, Elastic IP, Public IP, Security Group, MAC Address
- Can be moved between instances (for failover)

## EC2 Storages

### EC2 Instance Store
- Directly attached hardware
- High performance
  - Better IO performance
  - Good for buffer / cache / scratch data / temporary content
- Ephemeral
  - Data lost on instance stop / termination
  - Backup and Replication are our responsibility

### Elastic Block Store - EBS
- Network drive attached to instance
- Persistent data storage
- Bound to a specific Availability Zone (AZ)
- **Snapshots**
  - Backup of EBS volume
  - Can copy across AZ/Region
    - EBS (us-east-1a) → *snapshot* → EBS Snapshot → *restore* → EBS (us-east-1b)
  - EBS Snapshot Archive: lower cost, lower restore
  - Recycle Bin: recover deleted snapshots
  - Fast Snapshot Restore - FSR
- **Volume Types**
  - **General Purpose SSD**
    - gp2, gp3
    - Balanced between price and performance
    - *System boot volumes, virtual desktops, development and test environments*
  - **Provisioned IOPS SSD**
    - io1, io2 Block Express
    - Highest-performance SSD volume for mission-critical low-latency or high throughput workloads
    - Great for databases workloads
  - **Throughput Optimized HDD**
    - st1
    - Low cost HDD volume designed for frequently accesses, throughput-intensive workloads
    - Big data, Data warehouse, Log processing
  - **Cold HDD**
    - sc1
    - Lowest cost HDD volume designed for less frequently accessed workloads
- **EBS Multi-Attach**
  - io1, io2
  - Attach to multiple instances in the same AZ
- **EBS Encryption**
  - Data at rest is encrypted inside the volume
  - All data in flight moving between instance and volume is encrypted
  - All snapshots are encrypted
  - EBS Encryption leverages keys from KMS (AES-256)

### Elastic File System - EFS
- Managed NFS for multiple EC2 instances
- Multi-AZ capable
- Scalable and highly available
- Performance modes: general purpose, Max I/O
- Throughput modes: bursting, provisioned, elastic
- Storage tiers: standard, infrequently accessed, archive

## EC2 Security Group
- Virtual firewall for EC2 Instances
- Control inbound and outbound rules
- Allows rules only
- Stateful

## EC2 Instance Management
- Instance states: Running, Stopped, Terminated, Hibernated

### EC2 Hibernate
- "Sleeping" mode
- Preserve in-memory (RAM) state
- Faster boot times
- Root EBS volume must be encrypted
- Flow: Running → hibernate → Stopping (RAM dumped to root EBS) → Stopped → start → Running

### Amazon Machine Image - AMI
- Customization of an EC2 instance
  - Can add our own software, configuration, operating system, monitoring, …
  - Faster boot / configuration time since all softwares are pre-packaged
- Region-specific
- Sources: Public, Own, AWS marketplace
- Process: Customize → Stop → Build AMI → Launch

## EC2 Purchasing Options

### On-demand Instances
- Pay per second (Linux/Window OS) / hour (others OS)
- No commitment
- Short-term and un-predicted workloads

### Reserved Instances - RI
- Discount for long-term commitment (1 or 3 years)
- Convertible Reserved Instance: can change instance type, instance family, OS, scope and tenancy
- Steady-state usage applications: databases

### Saving Plans
- Discount based on usage commitment (1 or 3 years)
- Locked to a specific instance family and AWS region

### Spot Instances
- Up to 90% discount compared to On-demand
- Can be interrupted
- Spot Instance requests, Spot Fleets
- Workloads that are resilient to failure or with a flexible start and end time
  - Batch processing
  - Data analysis
  - Image processing

### Dedicated Hosts
- Entire physical server dedicated to you
- The most expensive option
- Useful for software that have complicated licensing model (BYOL - Bring Your Own License)
- Useful for companies that have strong regulatory or compliance needs

### Dedicated Instances
- Instances run on dedicated hardware
- May share hardware with other instances in the same account

### Capacity Reservations
- Reserve capacity in a specific AZ
- No commitment
- Short-term, uninterrupted workloads that need to be in a specific AZ

### Thinking Purchasing Options In Booking Hotel Ways
- **On demand**: coming and staying in resort whenever we like, we pay the full price.
- **Reserved**: like planning ahead and if we plan to stay for a long time, we may get a discount.
- **Saving Plans**: pay a certain amount per hour for certain period and stay in any room type (e.g. King, Suite, Sea View, …)
- **Spot Instances**: the hotel allows people to bid for the empty rooms and the highest bidder keeps the rooms. You can get kicked out at any time.
- **Dedicated Hosts**: we book an entire building of the resort
- **Capacity Reservations**: you book a room for a period with full price even we don't stay in it.

## EC2 Placement Group

### Cluster Placement Groups
- Low latency within a single AZ
- Pros / Cons
  - Pros: great network
  - Cons: if the AZ fails, all instances fails at the same time
- Use cases
  - Big data job that needs to complete fast
  - Application requires low latency and high network throughput

### Spread Placement Groups
- Instances are spread across AZ, high availability
- Pros / Cons
  - Pros: Reduced risk of simultaneous failure
  - Cons: Limited to 7 instances per placement group
- Use cases
  - Application that needs to maximize high availability
  - Critical applications where each instance must be isolated from failure from each other

### Partition Placement Groups
- Instances across different partitions (racks)
- Up to 7 partitions per AZ, up to 100s of EC2 instances
- The instance in a partition do not share racks with the instances in the other partitions
- A partition failure can affect many EC2 but won't affect other partitions
- Use cases: HDFS (Hadoop distributed file system), HBASE, Cassandra, Kafka

## ELB & ASG

### High Availability
- Survive data center loss
- Run application in at least 2 AZ
- Often paired with horizontal scaling
- Passive (e.g. RDS Multi AZ)
- Active (horizontal scaling)

### High Scalability
- **Vertical Scalability**
  - Increase instance size
  - Suitable for non-distributed systems.
  - E.g. databases: RDS, ElastiCache
  - Hardware limits
- **Horizontal Scalability (Elasticity)**
  - Increase number of instances
  - Implies distributed systems
  - Common for web applications
  - Easy with cloud offerings like Amazon EC2

## Elastic Load Balancer - ELB

### Overview
- Forward traffics to multiple servers
- Spreads load across instances
- Expose a single point of access (DNS) to our application.
- Handles downstream instance failures
- SSL termination
- Separate public and private traffic

### Health Checks
- Crucial for knowing instance availability
- Performed on a port and route (e.g. /health)
- Unhealthy if response is not 200

### Types of Load Balancers
- **Classic Load Balancer - CLB**
  - Old generation: v1
  - Protocols: HTTP, HTTPS, TCP, SSL
- **Application Load Balancer - ALB**
  - New generation: v2
  - Layer 7: HTTP
  - HTTP2 support
  - Protocols: HTTP, HTTPS, WebSocket
  - Redirects (HTTP to HTTPS)
  - Load balancing to multiple HTTP applications or containers
  - Target Groups: EC2, ECS, Lambda, IP Addresses
  - Health Checks at target group level
  - Routing tables to different target groups
    - Routing based on path in URL, e.g. example.com/**users** & example.com/**posts**
    - Routing based on hostname in URL, e.g. **one**.example.com & **other**.example.com
    - Routing based on Query String, Headers, e.g. example.com/users?id=123&order=false
- **Network Load Balancer - NLB**
  - New generation: v2
  - Layer 4
  - Protocols: TCP, TLS, UDP
  - Millions of requests per second, ultra-low latency
  - Static IP per AZ, Elastic IP support
  - Used for high performance, TCP/UDP traffic
  - Target groups: EC2, ALB, IP Addresses
  - Health Checks: TCP, HTTP, HTTPS
- **Gateway Load Balancer - GLB**
  - New generation: v2
  - Layer 3
  - For third-party network virtual applications: firewalls, intrusion detection
  - Transparent Network Gateway: single entry/exit for all traffic
  - Uses the GENEVE protocol on port 6081
  - Target groups: EC2 Instances, Private IP Addresses

### Security Groups
- Control inbound and outbound traffic
- Users → HTTPS/HTTP from anywhere → Load Balancer → HTTP restricted to load balancer → EC2

### Sticky Sessions (Session Affinity)
- Direct same client to the same instance
- Application-based or Load balancer-generated cookies
- May cause load imbalance
- The "cookie" used for stickiness has an expiration date
  - **Application-based Cookies**
    - Custom Cookie
      - Generated by the target
      - Can include any custom attributes required by the application
    - Application Cookie
      - Generated by the load balancer
  - **Duration-based Cookies**
    - Generated by the load balancer

### Cross-Zone Load Balancing
- Distribute traffic evenly across all instances in all AZs
- Enabled by default for ALB, disabled for NLB and CLB

### SSL Certificates
- Encrypt traffic between clients and load balancer
  - Users → HTTPS (encrypted) over www → Load Balancer → HTTP over private VPC → EC2
- Managed by ACM (AWS Certificate Manager)
- HTTPS listener requires a default certificate
- Server Name Indication (SNI) for multiple SSL certificates on one listener

### Connection Draining / Deregistration Delay
- Time to complete in-flight requests before de-registering instance
- Prevents new requests to de-registering instances

## Auto Scaling Group - ASG

### Overview
- Scales out (add instances) for increased load
- Scales in (remove instances) for decreased load
- Maintain minimum and maximum number of instances
- Registers new instances to load balancer
- Recreates terminated instances
- ASG is free → pay for the underlying EC2 instances
- Capacity: Minimum ≤ Desired ≤ Maximum (scale out as needed)

### Launch Template
- AMI + Instance Type
- EC2 User Data
- EBS Volume
- Security Group
- SSH Key Pair
- IAM Roles for our EC2 Instances
- Network & Subnets
- Load Balancer Information
- Initial / Min / Max Capacity

### Scaling Policies
- Based on CloudWatch alarms
- **Cooldown Period**
  - Time after scaling activity before further scaling
  - Default 300s
- **Health Check**
  - EC2 Status Checks
  - ALB Health Checks
- **Dynamic Scaling**
  - **Target Tracking Scaling**
    - Maintain a target value for a metric
    - E.g. CPU utilization to stay at around 40%
  - **Simple / Step Scaling**
    - Add or remove fixed number of units based on alarm
    - E.g. When a CloudWatch alarm is triggered (>70%), then add 2 units
  - **Scheduled Scaling**
    - Scale based on known usage patterns
    - E.g. Increase the min capacity to 10 at 5pm on Fridays
  - **Predictive Scaling**
    - Forecast load and schedule scaling
