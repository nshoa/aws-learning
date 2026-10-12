---
title: Data & Analytics
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# Data & Analytics

## Amazon Athena

### Overview
- Serverless interactive query service for data in Amazon S3.
- Uses standard SQL (based on Presto engine).
- Supported Formats: CSV, JSON, ORC, Avro, Parquet.
- Pricing: Pay per TB of data scanned ($5/TB).
- Integrations: Commonly used with Amazon QuickSight for visualization.
- Use Cases: BI/analytics, reporting, querying service logs (VPC Flow Logs, ELB Logs, CloudTrail), ad-hoc S3 data analysis.
- Flow: Users → *load data* → S3 bucket ← *query & analyze* ← Athena → *reporting & dashboard* → QuickSight

### Performance Improvement
- **Use Columnar Formats**: Apache Parquet or ORC (reduces data scanned). Recommend using AWS Glue for conversion.
- **Compress Data**: Reduces amount of data transferred (bzip2, gzip, snappy, zstd, etc.).
- **Partition Data**: Partition datasets in S3 based on common query filters (e.g., `/year=2024/month=05/`). Allows Athena to scan less data.
- **Use Larger Files**: Consolidate small files into larger ones (>128MB) to reduce overhead.

### Federated Query
- Query data across multiple sources (relational, non-relational, object, custom) beyond S3.
- Uses Lambda-based Data Source Connectors.
- Supported Sources (Examples): S3, RDS, Aurora, DynamoDB, DocumentDB, ElastiCache, Redshift, CloudWatch Logs, HBase on EMR, On-Premises Databases.
- Query results can be stored back in S3.

## Amazon Redshift

### Overview
- Fully managed data warehouse service based on PostgreSQL.
- Optimized for OLAP (Online Analytical Processing) - analytics and complex queries, not OLTP.
- Uses columnar storage and massively parallel processing (MPP).
- Performance: Claims 10x better performance than other data warehouses, scales to Petabytes.
- Query Interface: Standard SQL.
- Integrations: BI tools like QuickSight, Tableau.
- Modes: Provisioned Cluster (choose instances) or Serverless Cluster.
- vs. Athena: Often faster for complex queries, joins, aggregations due to optimized storage, indexes, and compute nodes.

### Architecture (Provisioned)
- **Leader Node**: Manages client connections, query planning, aggregates results.
- **Compute Nodes**: Execute query steps in parallel, send results to leader.

### Loading Data
- **Methods**: `COPY` command from S3 (most common), Kinesis Data Firehose, JDBC inserts (use batches for efficiency).
- **Enhanced VPC Routing**: Forces `COPY`/`UNLOAD` traffic between Redshift and data repositories (S3, DynamoDB, EMR) through your VPC.

### Redshift Spectrum
- Query data directly in Amazon S3 without loading it into Redshift tables.
- Requires an active Redshift cluster to initiate queries.
- Queries execute on separate, scalable Redshift Spectrum nodes.

### Snapshots & DR
- **Snapshots**: Point-in-time backups stored internally on S3, incremental.
- **Automated Snapshots**: Scheduled frequency or size threshold, configurable retention.
- **Manual Snapshots**: Retained until manually deleted.
- **Restore**: Snapshots restore to a *new* cluster.
- **Cross-Region Snapshots**: Configure automatic copy of automated or manual snapshots to another AWS Region for DR.
- **Multi-AZ**: Available for some cluster types to improve availability.
- Flow: Redshift cluster (us-east-1) → take snapshot → automated/manual copy → copied snapshot (eu-west-1) → restore → new Redshift cluster

## Amazon OpenSearch Service (formerly Elasticsearch Service)

### Overview
- Managed service for OpenSearch (search and analytics engine, successor to Elasticsearch).
- Use Cases: Log analytics, real-time application monitoring, website search, clickstream analysis, security monitoring.
- Search Capabilities: Full-text search, search across any field, partial matches (complements databases like DynamoDB).
- Modes: Managed Cluster or Serverless.
- Querying: Primarily uses OpenSearch API/DSL; SQL support available via plugin.
- Integrations: Ingest data from Kinesis Data Firehose, Kinesis Data Streams, CloudWatch Logs, AWS IoT. Security via IAM/Cognito. Visualization with OpenSearch Dashboards.

### Ingestion Patterns
- DynamoDB → DynamoDB Stream → Lambda → OpenSearch.
  - App uses API to search items in OpenSearch, then API to retrieve items from DynamoDB
- CloudWatch Logs → Subscription Filter → Lambda (real-time) → OpenSearch.
- CloudWatch Logs → Subscription Filter → Kinesis Data Firehose (near real-time) → OpenSearch.
- Kinesis Data Streams → Lambda (real-time) → OpenSearch.
- Kinesis Data Streams → Kinesis Data Firehose (near real-time, optional Lambda transform) → OpenSearch.

## Amazon EMR (Elastic MapReduce)

### Overview
- Managed service for running big data frameworks like Apache Hadoop, Spark, Hive, Presto, Flink, HBase on scalable clusters.
- Handles cluster provisioning, configuration, management, scaling.
- Use Cases: Large-scale data processing, ETL, machine learning, web indexing, genomics, financial analysis.

### Node Types
- **Master Node**: Manages and coordinates the cluster.
- **Core Node**: Runs tasks and stores data (HDFS).
- **Task Node**: Optional nodes that only run tasks (no data storage), often use Spot Instances.

### Purchasing & Cluster Options
- **Instance Pricing**: On-Demand, Reserved Instances, Spot Instances.
- **Cluster Lifecycle**: Can be long-running or transient (terminate after job completion).

## Amazon QuickSight

### Overview
- Serverless, ML-powered Business Intelligence (BI) service.
- Creates interactive dashboards and visualizations.
- **Features**: Auto-scaling, embeddable dashboards, per-session pricing.
- **SPICE Engine**: Super-fast, Parallel, In-memory Calculation Engine used when data is imported into QuickSight.
- **Use Cases**: Business analytics, dashboarding, ad-hoc data exploration, generating insights.

### Integrations - Data Sources
- RDS
- Aurora
- Redshift
- Athena
- S3
- OpenSearch
- Timestream
- On-prem DBs (JDBC)
- SaaS apps (Salesforce, Jira)
- File uploads (CSV, TSV, JSON, XLSX, etc.)

### Sharing & Security
- Users/Groups defined within QuickSight (separate from IAM).
- **Analysis**: The workspace where visualizations are built.
- **Dashboard**: A published, read-only version of an analysis, shared with users.
- **Enterprise Edition**: Supports Row-Level Security (RLS) and Column-Level Security (CLS).

## AWS Glue

### Overview
- Fully serverless ETL (Extract, Transform, Load) service.
- Discovers, prepares, moves, and integrates data from multiple sources.
- **Use Cases**
  - Data cleansing, transformation, cataloging
    - S3 bucket / Amazon RDS → *extract* → Glue ETL (*transform*) → *load* → Redshift data warehouse
  - ETL pipeline orchestration, converting data formats (e.g., JSON to Parquet for Athena).
    - S3 put → input S3 bucket → event notification → Lambda (or EventBridge) → trigger Glue ETL job → import CSV → Parquet → output S3 bucket → analyze with Athena

### Components
- **Glue Data Catalog**: Central metadata repository (database schemas, table definitions). Populated by Glue Crawlers scanning data sources (S3, RDS, DynamoDB, JDBC). Acts as a central schema registry for Athena, Redshift Spectrum, EMR.
- **Glue Crawlers**: Automatically discover datasets, infer schemas, and populate the Data Catalog.
- **Glue ETL Jobs**: Run scripts (Python or Scala with Spark) to perform data transformations. Can be triggered on schedule or by events.

### Features
- **Glue Job Bookmarks**: Automatically track data processed by ETL jobs to prevent reprocessing duplicates on subsequent runs.
- **Glue Elastic Views**: Create virtual tables (materialized views) combining data from multiple sources using SQL. Handles replication and updates automatically.
- **Glue DataBrew**: Visual data preparation tool for cleaning/normalizing data with pre-built transformations, requiring no code.
- **Glue Studio**: Graphical interface for creating, running, and monitoring ETL jobs.
- **Glue Streaming ETL**: Process streaming data from Kinesis Data Streams, Apache Kafka, and MSK using Spark Structured Streaming.

## AWS Lake Formation

### Overview
- Service to build, secure, and manage data lakes easily.
- Automates steps like data ingestion, cleaning, cataloging, transformation.
- Centralizes data governance and provides fine-grained access control (table, column, row-level security) across various analytics services.
- Built on top of AWS Glue (uses Glue Data Catalog, ETL jobs).
- Diagram: data sources (S3, RDS, Aurora, on-prem SQL & NoSQL) → *ingest* → Lake Formation (source crawlers, ETL & data prep, data catalog, security settings, access control) ⇄ data lake (stored in S3) → Athena / Redshift / EMR → users

### Workflow
- Register data sources (S3, RDS, etc.) with Lake Formation.
- Crawl data and populate the Glue Data Catalog.
- Define permissions and access policies within Lake Formation.
- Use services like Athena, Redshift, EMR, QuickSight to query/analyze data, respecting Lake Formation permissions.

## Amazon Managed Service for Apache Flink (formerly Kinesis Data Analytics)

### Overview
- Run Apache Flink applications (Java/Scala/SQL) to process streaming data in real-time.
- Managed service: handles provisioning, scaling, application backups (checkpoints/snapshots).
- Sources: Kinesis Data Streams, Amazon MSK.
- Note: Does *not* directly read from Kinesis Data Firehose.

## Amazon MSK (Managed Streaming for Apache Kafka)

### Overview
- Fully managed service for Apache Kafka.
- Simplifies setup, scaling, management of Kafka clusters (brokers, Zookeeper nodes).
- Features: Multi-AZ deployment, automated failure recovery, EBS storage for data retention, MSK Serverless option.
- Use Cases: Real-time data streaming, event sourcing, log aggregation, messaging queue (alternative to Kinesis).

### Consumers & Comparison
- **Consumers**: Lambda, Managed Service for Apache Flink, Glue Streaming ETL, applications on EC2/ECS/EKS.
- **MSK vs. Kinesis Data Streams**: Key differences in message size limits, partitioning/sharding flexibility, encryption details.

## Example Big Data Ingestion Pipeline

### Goal
- Serverless real-time data collection, transformation, querying, and visualization.

### Flow
1. **Ingest**: IoT Core (or other sources) → Kinesis Data Streams (real-time capture).
2. **Deliver & Transform**: Kinesis Data Streams → Kinesis Data Firehose (batch delivery to S3, near real-time, optional Lambda for transformation) → S3 Ingestion Bucket.
3. **Trigger Analysis**: S3 PUT event → SQS → Lambda (decoupled trigger). (Alternatively: S3 → Lambda directly or S3 → EventBridge → Lambda).
4. **Query**: Lambda triggers → Athena (queries transformed data in S3) → S3 Reporting Bucket (stores query results).
5. **Visualize/Warehouse**: QuickSight (dashboards from Athena results) or Load data into Redshift.
