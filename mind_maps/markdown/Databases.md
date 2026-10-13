---
title: Databases
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# Databases

## Choosing The Right Database

- Workload Type: Read-heavy, Write-heavy, Balanced
- Throughput Needs: Constant, Fluctuating, Scaling required?
- Data Volume & Growth: How much data now? Expected growth? Object size?
- Data Durability & Source of Truth: How critical is data loss prevention?
- Latency Requirements: Milliseconds, Sub-milliseconds? Concurrent users?
- Data Model: Relational (SQL, Joins), Key-Value, Document (JSON), Graph, Time-Series, Ledger?
- Query Patterns: Simple lookups, Complex queries, Joins needed? Full-text search?
- Schema: Fixed or Flexible/Evolving?
- Consistency Needs: Strong, Eventual?
- Operational Overhead: Managed vs Self-managed? Serverless?
- Cost: Licensing (e.g., Oracle/SQL Server vs Cloud-Native like Aurora), Operational costs.

## Relational Database Service

### Amazon RDS

- **Overview**
    - Fully managed relational database service for SQL-based workloads.
    - Supported Engines: PostgreSQL, MySQL, MariaDB, Oracle, Microsoft SQL Server, IBM DB2.
    - Core Benefits
        - High Availability: Multi-AZ setup for Disaster Recovery (DR).
        - Monitoring: Continuous health dashboards & alerts (Amazon CloudWatch).
        - Offloaded Management: Infrastructure management handled by AWS.
        - Automation
            - Automated Provisioning
            - OS Patching
            - Continuous backups and restore to specific timestamp (Point in Time Restore - PITR)
            - Maintenance Windows
        - Scalability
            - Vertical Scaling: Adjust instance size.
            - Horizontal Scaling: Read Replicas for scaling read workloads.
- **Instance & Storage**
    - Compute and Memory: Choose instance size (e.g., db.t3.micro).
    - Storage Auto Scaling: Automatically increases storage when nearing capacity to prevent downtime.
    - Storage Types
        - General Purpose SSD (gp2/gp3): Cost-efficient, balances price and performance.
        - Provisioned IOPS SSD (io1/io2 Block Express): High-performance for OLTP with low latency and user-specified IOPS.
- **Backup & Restore**
    - Automated Backups
        - Daily full snapshot taken during the backup window, with transaction logs captured continuously.
        - Enables Point-in-Time Recovery (PITR) up to a retention period of 1–35 days (default: 7 days).
    - Manual Snapshots
        - User-initiated; stored indefinitely (even after DB deletion).
        - Useful for long-term archival or creating new DB instances.
    - Restore
        - Always creates a new RDS instance using snapshots or PITR.
        - Restoring MySQL RDS DB from S3
            - Create a backup of our on-premise DB
            - Store it on S3
            - Restore the backup file onto a new RDS instance running MySQL
- **Read Replicas**
    - Purpose: Offload read workloads and provide horizontal scalability.
    - Number
        - Up to 15 replicas supported for MySQL, PostgreSQL, MariaDB.
        - Up to 5 replicas for Oracle and SQL Server.
    - Replication: Asynchronous (reads are eventually consistent → some replication lag may occur).
    - Location: Replicas can be within the same AZ, across AZs, or even Cross-Region.
    - Promotion: Read replicas can be promoted to standalone primary DBs (breaks replication).
    - Use Cases: Read-heavy applications and reporting/analytics workloads without impacting the primary DB.
    - Network cost
        - Same region, same AZ → free
        - Same region, different AZ → free
    - Diagram: application writes/reads the master; ASYNC replication to read replicas which serve reads
- **Multi-AZ Deployment**
    - Purpose: High Availability (HA) and Disaster Recovery (DR); not designed for read scaling.
    - Mechanism: Creates a synchronous standby replica in a different Availability Zone.
    - Engine: Available for all supported RDS engines
    - Failover
        - Automatic failover to the standby DB during primary failure, maintenance, or AZ disruption.
        - Minimal downtime (typically 1–2 minutes).
    - Diagram: application → one DNS name (automatic failover) → master (AZ A) — SYNC replication → standby (AZ B)
    - From Single-AZ to Multi-AZ
        - Zero downtime operation (no need to stop DB)
        - A snapshot is taken → a new DB instance is restored from the snapshot in a new AZ → synchronization is established between the two DBs
- **Security**
    - Encryption At-Rest
        - AWS KMS (AES-256) encryption enabled during DB setup. Applies to the primary instance, snapshots, and replicas.
        - Transparent Data Encryption (TDE) supported for Oracle/SQL Server.
            - Transparent meaning the application doesn't need any special modifications or additional code to use it.
    - Encryption In-Transit
        - SSL/TLS configured using AWS-provided certificates via console or CLI.
        - Enforce SSL connections to the DB using parameters.
    - Network Security
        - Typically deployed in Private Subnets.
        - Access controlled via Security Groups to restrict traffic.
    - IAM Authentication: Supported for MySQL and PostgreSQL, allowing centralized credential management.
    - Traditional Authentication: Standard username/password credentials managed within the DB engine itself.
- **Monitoring & Performance**
    - CloudWatch Metrics: Provides standard DB metrics (CPU, RAM, Disk Space, Network, Connections, IOPS, Latency, Throughput).
    - Enhanced Monitoring
        - Offers OS-level metrics (e.g., CPU details, processes).
        - Configurable refresh frequency (1, 5, or 10 seconds).
        - Metrics stored in CloudWatch Logs (additional cost).
    - Performance Insights
        - Interactive dashboard to identify SQL bottlenecks (e.g., slow queries, resource waits).
        - Helps diagnose and optimize DB performance. Free tier availability.
    - RDS Recommendations: Automated suggestions for improving performance, security, and configuration.
    - Event Notifications: Uses SNS to notify about key events (e.g., backups, failovers, maintenance).
- **RDS Proxy**
    - Purpose: Managed connection pooling service for RDS/Aurora DBs.
        - Allows apps to pool and share DB connections established with the database
    - Benefits
        - Reduces failover times significantly (up to 66% reduction).
        - Scales applications by pooling and sharing connections, reducing resource consumption (e.g., CPU/memory).
        - Enforces IAM authentication securely and stores credentials via AWS Secrets Manager.
    - Use Cases
        - Ideal for serverless apps (e.g., AWS Lambda).
        - Handles applications that frequently open and close many DB connections.
        - Improves resilience to failures and scalability.
    - Diagram: Lambda functions (IAM authentication) → RDS Proxy (private subnet) → RDS DB instance
- **RDS Custom**
    - Engines: Oracle, Microsoft SQL Server.
    - Purpose: Required for custom OS/DB environment configurations (e.g., proprietary patches, customization).
    - Access: Provides SSH and SSM to manage the underlying OS.
    - Trade-offs
        - User is responsible for more management (e.g., patching OS/DB)
        - Some automation features are disabled (e.g., storage auto-scaling).
    - Supported Automation: Backup automation is still available.

### Amazon Aurora

- **Overview**
    - Fully managed service.
    - AWS cloud-native relational database
    - Compatibility: MySQL, PostgreSQL
    - Offering higher performance and availability than standard RDS MySQL/PostgreSQL, at potentially lower cost than commercial databases.
- **Architecture**
    - Cloud Native Design: Storage and compute are decoupled.
    - Storage Subsystem
        - Distributed, fault-tolerant, self-healing.
        - Data stored in 10GB chunks replicated **6 times across 3 Availability Zones (AZs)**
        - Can handle the loss of up to 2 copies without affecting write availability.
        - Can handle the loss of up to 3 copies without affecting read availability.
        - Storage automatically scales in 10GB increments up to **128 TiB**. No need to pre-provision storage.
        - Self-healing: Data blocks and disks are continuously scanned for errors and automatically repaired.
    - Compute Instances: Handles query processing, caching, connections. Can be scaled independently.
- **Performance**
    - Throughput Claims: Up to **5x** the performance of standard MySQL on RDS, up to **3x** the performance of standard PostgreSQL on RDS (on similar hardware).
    - Low Latency Reads: Achieved through efficient storage access and caching.
- **High Availability & Durability**
    - Built-in Fault Tolerance: Due to the 6-way storage replication across 3 AZs.
    - Instance Failover: Automatic failover typically occurs in **under 30 seconds** (often under 15 seconds).
    - Failover Priority: Can set promotion tiers (0-15) for replicas to control failover order. Tier 0 is highest priority.
- **Scalability**
    - Read Replicas (Aurora Replicas)
        - Number: Up to **15** Aurora Replicas (vs 5 for RDS MySQL/PostgreSQL).
        - Replication Lag: Typically **< 10 milliseconds** (significantly lower than RDS replicas' async lag).
        - Role: Primarily for read scaling, can also serve as failover targets.
        - Types: Can be within AZ, Cross-AZ, or Cross-Region (as part of Aurora Global Database).
    - Auto Scaling Replicas: Automatically adjust the number of Aurora Replicas based on CPU utilization or connections.
- **Endpoints**
    - Custom Endpoints: Define subsets of Aurora Replicas (e.g., replicas with specific instance types). Allows directing specific workloads (e.g., analytics) to dedicated replicas.
    - Cluster Endpoint (Writer Endpoint): Connects to the current primary/writer instance. DNS automatically points to the new primary after failover. Use for all write operations.
    - Reader Endpoint: Connects to one of the available Aurora Replicas. Provides load balancing for read connections across replicas. Use for read-only workloads.
    - Instance Endpoint: Connects directly to a specific DB instance (primary or replica). Useful for specific diagnostics or configurations, generally avoided for application use due to failover complexity.
- **Aurora Serverless**
    - Concept: On-demand, auto-scaling configuration. Automatically starts up, shuts down, and scales compute capacity based on application load.
    - Versions
        - Serverless v1: Scales by doubling/halving capacity. Can 'pause' (scale to 0) after inactivity (configurable, min 5 mins). Good for infrequent/intermittent workloads. Proxy Fleet required for connections.
        - Serverless v2: Scales compute capacity more granularly (increments of 0.5 ACU) almost instantly. Does not pause, scales down to minimum configured capacity. Better suited for variable/unpredictable workloads without long pauses. No Proxy Fleet needed.
    - Aurora Capacity Units (ACUs): Unit of compute/memory capacity. Pay per ACU-second consumed (minimum 1 minute for v1).
    - Use Cases: Infrequent, intermittent, or unpredictable workloads; development/test environments; new applications with uncertain load.
- **Aurora Global Database**
    - Purpose: Designed for globally distributed applications requiring low-latency global reads and disaster recovery from region-wide outages.
    - Architecture
        - Primary Region: Contains the primary writer instance and cluster.
        - Secondary Region(s): Up to 5 read-only secondary regions.
    - Replication: Uses dedicated infrastructure for physical replication. Typically **< 1 second** replication lag between primary and secondary regions.
    - Performance: Allows fast local reads for users in secondary regions.
    - Disaster Recovery: Can promote a secondary region to be the primary R/W region in **less than 1 minute** (low Recovery Time Objective - RTO).
    - Use Cases: Global applications needing low-latency reads across regions, robust cross-region disaster recovery strategy.
- **Backup & Restore**
    - Manual Snapshots: User-initiated, stored in S3, retained until deleted.
    - Automated Backups: Enabled by default (cannot be disabled), PITR up to retention period (1-35 days), stored in S3. Minimal performance impact.
    - Restore: Creates a **new** Aurora cluster from snapshot or PITR.
- **Backtrack**
    - Functionality: Allows "rewinding" the DB cluster to a specific point in time within a configured window (up to 72 hours) **without** creating a new cluster from a backup.
    - Mechanism: Uses distributed log structures. Very fast operation (minutes).
    - Use Case: Rapid recovery from logical errors (e.g., accidental table drop, wrong data update). Not a replacement for backups.
- **Aurora Cloning**
    - Functionality: Creates a new, independent Aurora cluster from an existing one very quickly (minutes).
    - Mechanism: Uses a copy-on-write protocol. Only changed data blocks consume new storage initially.
    - Use Case: Creating fast test/dev/staging environments using production data, running analytical queries without impacting production.
- **Machine Learning Integration**
    - Services: Integrates with Amazon SageMaker (for ML models) and Amazon Comprehend (for sentiment analysis).
    - Mechanism: Invoke ML models/services directly using SQL functions within Aurora queries.
    - Use Cases: Fraud detection, product recommendations, sentiment analysis directly on data within the database.
- **Security**
    - Encryption At-Rest: Via AWS KMS (AES-256). Enabled by default for the cluster volume. Snapshots and replicas are also encrypted.
    - Encryption In-Transit: Using SSL/TLS (automatically provisioned certificates). Enforce SSL connection in parameter groups.
    - Network Security: Runs within VPC, uses Security Groups to control access.
    - IAM Authentication: Supported for MySQL and PostgreSQL compatibility.
    - Authentication: Standard DB username/password also supported.

## In-Memory Database

### Amazon ElastiCache

- Purpose: Reduce load on backend databases (like RDS, DynamoDB), improve read latency, store session state.
- Description: Managed in-memory data store and cache service. Used to improve performance of web applications by retrieving data from fast, managed, in-memory caches, instead of relying entirely on slower disk-based databases.
- **Security**
    - Network: Uses Security Groups to control access (similar to RDS). Deploy within a VPC.
    - Encryption: Supports In-Transit Encryption (TLS) and At-Rest Encryption.
    - Authentication: Redis AUTH, IAM Authentication (Redis), SASL (Memcached).
- **Supported Engines**
    - **Redis**
        - Data Types: Supports complex data types like Strings, Lists, Sets, Sorted Sets, Hashes, Bitmaps, HyperLogLogs, Geospatial indexes.
        - Persistence: Offers Multi-AZ with automatic failover for High Availability. Optional persistence via RDB snapshots and AOF logs.
        - Scalability: Read Replicas for read scaling (up to 5). Sharding via Cluster Mode for write/memory scaling across multiple nodes.
        - Features: Pub/Sub capabilities, Lua scripting, Transactions.
        - Security: Supports Redis AUTH command (password/token), IAM Authentication, In-Transit Encryption (TLS), At-Rest Encryption.
        - Use Cases: Advanced caching, session management, real-time leaderboards (Sorted Sets), Pub/Sub messaging, geospatial indexing.
    - **Memcached**
        - Data Types: Simple key-value store (strings).
        - Persistence: Purely in-memory, no persistence options. No Multi-AZ failover capability (node failure results in data loss for that node).
        - Scalability: Multi-threaded architecture (utilizes multiple cores). Scales horizontally by adding more nodes (sharding handled client-side).
        - Features: Simpler, potentially lower latency for simple GET/SET operations due to multi-threading.
        - Security: Supports SASL authentication. Supports In-Transit Encryption (TLS), At-Rest Encryption.
        - Use Cases: Basic object caching where data loss on node failure is acceptable, applications needing the simplest caching model or highest performance on multi-core instances for simple operations.
- **Caching Patterns / Strategies**
    - **Lazy Loading / Cache-Aside**: Application requests data; if in cache (cache hit), return it. If not in cache (cache miss), fetch from DB, store in cache, return to app. Simple, only caches requested data, but initial cache miss has higher latency. Cache data can become stale.
    - **Write-Through**: Application writes data to cache *and* database simultaneously. Ensures cache is always up-to-date. Higher write latency (writes to two places). DB is not necessarily read from (unless cache miss). Solves staleness.
    - **Session Store**: Store temporary user session data (e.g., user profile, login status, shopping cart) in the cache for fast retrieval. Requires TTL (Time-To-Live) for session expiry.
    - **TTL (Time-To-Live)**: Common strategy for cache invalidation. Set an expiration time on cache keys. Helps manage staleness in Lazy Loading.

## NoSQL Databases

### Amazon DynamoDB

- Type: Fully managed, serverless, key-value & document NoSQL DB.
- Performance: Delivers single-digit ms performance at any scale.
- **Use Cases**
    - High-scale web applications, mobile backends, serverless application backends, microservices.
    - gaming leaderboards/session stores
    - AdTech (real-time bidding)
    - IoT data ingestion
- **Scalability & Capacity Modes**
    - Serverless: No servers to provision or manage. Scales automatically to handle load.
    - Capacity Modes
        - On-Demand: Pay-per-request pricing. Scales automatically based on traffic. Good for unpredictable workloads or new applications.
        - Provisioned Capacity: Specify required Read Capacity Units (RCUs) and Write Capacity Units (WCUs). Can use Auto Scaling to adjust provisioned capacity based on utilization. Potentially more cost-effective for predictable workloads.
- **Key Features**
    - DynamoDB Accelerator (DAX): Fully managed, highly available, in-memory cache specifically for DynamoDB. Provides microsecond read latency for eventually consistent reads. Transparently integrates with existing DynamoDB API calls.
    - Global Tables: Build globally distributed applications with multi-region, active-active replication. Provides fast local read/write performance for users across regions and cross-region disaster recovery. Uses asynchronous replication.
    - DynamoDB Streams: Time-ordered sequence of item-level modifications (Create, Update, Delete) in a table. Change Data Capture (CDC) mechanism. Can trigger AWS Lambda functions or be consumed by Kinesis Data Streams or applications for event-driven architectures, data replication, analytics, etc. Records stored for 24 hours.
    - Time To Live (TTL): Automatically expires and deletes items from tables after a specified timestamp attribute. Reduces storage costs for irrelevant data without consuming WCUs for deletion. Use cases: session data, logs, temporary information.
    - Indexes: Global Secondary Indexes (GSIs) and Local Secondary Indexes (LSIs) allow flexible querying on non-key attributes.
- **Security**
    - Authentication & Authorization: Primarily uses IAM policies for fine-grained access control to tables and operations.
    - Encryption: All data encrypted at rest by default using AWS-owned keys (option to use KMS Customer Managed Keys). Supports HTTPS for encryption in transit.
- **Backup & Restore**
    - Point-in-Time Recovery (PITR): Protects against accidental writes/deletes. Continuous backups allow restoring to any point in the last 35 days. Enabling PITR doesn't affect performance or availability.
    - On-Demand Backup/Restore: Create full backups for long-term archival or compliance. Independent of PITR. Can be restored to a new table.

### Amazon DocumentDB

- Type: Fully managed, fast, scalable, highly available NoSQL document DB service that supports MongoDB workloads
- Performance: Designed for high throughput and low latency reads/writes.
- High Availability: Built-in fault tolerance due to storage replication. Automatic failover for compute instances. Supports up to 15 low-latency read replicas.
- Managed Service: Handles provisioning, patching, backup, recovery, monitoring, scaling.
- **Architecture: Similar to Aurora - decouples storage and compute.**
    - Storage: Distributed, fault-tolerant, self-healing, auto-scales up to 128 TiB. Data replicated **6 times across 3 AZs**.
    - Compute: Managed instances for processing queries.
- **Backup**
    - Automated continuous backups with PITR (up to 35 days)
    - Manual snapshots.
- **Security**
    - Runs in VPC, uses Security Groups
    - supports TLS encryption in transit, encryption at rest using KMS
    - IAM database authentication.
- **Use Cases**
    - Migrating self-managed MongoDB databases to AWS
    - Content management systems
    - User profiles, catalogs, applications needing flexible JSON-like document structures with MongoDB API compatibility.

### Graph Database (Amazon Neptune)

- Type: Fully managed graph DB.
- **Features**
    - Supports Property Graph (Gremlin) and RDF (SPARQL) query languages.
    - Optimized for querying highly connected datasets.
    - Millisecond latency even for billions of relationships.
    - Neptune Streams: Change Data Capture - CDC for change tracking (insert/update/delete).
        - Neptune cluster (writes) → Neptune Streams → stream reader apps (EC2, Lambda, …) via Neptune API HTTP GET → S3 / ElasticSearch / ElastiCache
- **High Availability**
    - Replicates storage across **3 AZs**
    - Supports up to **15 read replicas** with automatic failover.
- **Backup**
    - Continuous backups with PITR (up to 35 days).
    - Manual snapshots supported.
- **Security**
    - IAM-based access control.
    - Encryption at rest (KMS) and in transit (TLS).
- **Use Cases**
    - Social networking
    - Recommendation engines
    - Fraud detection, knowledge graphs.

### Ledger Database - Amazon QLDB (Quantum Ledger Database)

- Type: Managed Ledger DB.
- High Availability: Data replicated across **3 AZs** by default
- **Features**
    - Immutable, cryptographically verifiable transaction log
    - SQL-like query language (PartiQL).
    - Serverless, automatically scales with demand.
    - Centralized trust model (unlike blockchain).
- **Security**
    - IAM for access control.
    - TLS for encryption in transit, KMS for encryption at rest.
- **Use Cases**
    - Systems of record
    - Tracking financial transactions
    - Supply chain tracking
    - Audit logs where data immutability is crucial.

### Time-Series Database (Amazon Timestream)

- Type: Managed Time-Series DB.
- SQL Compatibility: Native support for querying via SQL.
- **Features**
    - Serverless, Fast, Scalable (handles trillions of events/day).
    - Built-in analytics functions for time-series data (e.g., smoothing, aggregation).
    - Storage tiering: recent data in memory, historical data on magnetic storage.
- **Security**
    - IAM for access control.
    - TLS for encryption in transit, KMS for encryption at rest.
- **Use Cases**
    - IoT sensor data
    - Application monitoring metrics
    - Operational data, real-time analytics on time-stamped data.
- Diagram: AWS IoT, Kinesis Data Streams (→ Lambda), Prometheus, Kinesis Data Streams / Amazon MSK (→ Managed Flink) → Timestream → QuickSight, SageMaker, Grafana

### Amazon Keyspaces (for Apache Cassandra)

- Type: Scalable, highly available, and managed Apache Cassandra-compatible database service.
- Compatibility: Supports Cassandra Query Language (CQL) code, Apache 2.0 licensed Cassandra drivers, and developer tools.
- Serverless: No clusters to manage, no servers to provision/patch. Scales automatically based on traffic.
- Performance: Single-digit millisecond latency at any scale. Handles thousands of requests per second.
- High Availability & Durability: Data replicated **3 times across multiple AZs** by default for high availability.
- **Scalability & Capacity Modes**
    - On-Demand: Pay only for reads/writes actually performed. Good for variable/unpredictable workloads.
    - Provisioned Capacity: Specify read/write capacity per second. Can use Auto Scaling. Cost-effective for predictable workloads.
- **Backup**
    - Continuous backups with PITR (up to 35 days).
    - Manual snapshots supported.
- **Security**
    - Encrypted at rest (AWS owned or KMS CMK) and in transit (TLS).
    - Uses IAM for access control, integrates with VPC endpoints.
    - Use Cases: Store IoT device information, time-series data, high-throughput workloads using Cassandra APIs without managing infrastructure.

## Object Storage

### Amazon S3 (Often used with Databases)

- Type: Key-value store for objects (not a traditional database).
- **Features**
    - Highly scalable and durable (11 9s).
    - Storage tiers: Standard, IA (Infrequent Access), Intelligent-Tiering, Glacier, Glacier Deep Archive.
    - Event Notifications for Lambda triggers.
    - S3 Select / Glacier Select for partial querying.
    - Lifecycle rules for data transition and expiration.
- **Security**
    - IAM, Bucket Policies, ACLs for fine-grained control.
    - HTTPS for encryption in transit.
    - Encryption at rest with SSE-S3, SSE-KMS, or SSE-C.
- **Use Cases**
    - Storing large objects
    - Backups for databases
    - Data lake source
    - Static website hosting
    - Log storage.
