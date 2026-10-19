---
title: "Monitoring & Audit: CloudWatch, X-Ray, CloudTrail & Config"
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# Monitoring & Audit

## Amazon CloudWatch

### CloudWatch Metrics

- **Overview**
    - Collects and tracks metrics (variables like CPUUtilization, NetworkIn) for AWS services.
    - Metrics exist within Namespaces.
    - Dimensions are attributes of metrics (e.g., InstanceId, Environment) - up to 30 per metric.
    - Metrics have timestamps.
    - Used to create monitoring Dashboards.
    - Supports Custom Metrics (e.g., EC2 RAM pushed via CloudWatch Agent).
- **Custom Metrics**
    - Publish your own metrics (e.g., memory/RAM usage, disk space, number of logged-in users, business KPIs) with the `PutMetricData` API, or via the CloudWatch Agent.
    - Define your own **Namespace** (cannot start with `AWS/`), metric name and **Dimensions**.
    - **Standard resolution**: data points at 1-minute granularity (default).
    - **High resolution** (`StorageResolution=1`): data points down to 1, 5, 10 or 30 seconds, at a higher cost.
    - Accepts data points with timestamps up to **2 weeks in the past** and **2 hours in the future** (make sure the EC2 time is correct).
    - Default metrics from AWS services: every 5 minutes; **EC2 Detailed Monitoring**: every 1 minute (extra cost).
- **Metric Streams**
    - Stream metrics near real-time to destinations.
    - Destinations: Kinesis Data Firehose (then to S3, Redshift, OpenSearch, etc.) or 3rd-party providers (Datadog, Splunk, etc.).
    - Option to filter which metrics are streamed.
    - Flow: CloudWatch Metrics → *stream near-real time* → Kinesis Data Firehose → S3 (→ Athena) / Redshift / OpenSearch

### CloudWatch Logs

- **Overview**: Centralized log collection and monitoring service.
- **Structure**
    - **Log Groups**: Containers for log streams (e.g., representing an application).
    - **Log Streams**: Sequences of log events from a source (e.g., an EC2 instance, Lambda function, container).
- **Features**
    - **Log Retention**: Configurable expiration policies (never to 10 years).
    - **Encryption**: Default encryption at rest, option for KMS CMK.
    - **Log Sources**: SDK, CloudWatch Logs Agent, Unified Agent, Elastic Beanstalk, ECS, Lambda, VPC Flow Logs, API Gateway, CloudTrail, Route53 DNS queries.
    - **Destinations/Integrations**: Amazon S3 (exports), Kinesis Data Streams, Kinesis Data Firehose, AWS Lambda, OpenSearch Service.
- **Logs Insights**
    - Query language to search and analyze log data across log groups.
    - Auto-discovers fields from JSON logs/AWS service logs.
    - Supports filtering, aggregations, sorting, saved queries, dashboard integration. Query across accounts. (Note: Not a real-time engine).
- **S3 Export**
    - Batch export logs to S3 (`CreateExportTask` API).
    - Can take up to 12 hours; not near-real-time.
- **Logs Subscriptions**
    - Stream log events in near real-time.
    - Destinations: Kinesis Data Streams, Kinesis Data Firehose, Lambda.
    - Uses Subscription Filters to select logs.
    - Supports Cross-Account subscriptions (requires IAM Role & destination policy).
    - Flow: CloudWatch Logs → Subscription Filter → Lambda (real-time → OpenSearch) / Kinesis Data Firehose (near real-time → OpenSearch, S3) / Kinesis Data Streams (→ KDF, KDA, EC2, Lambda)
- **Log Aggregation**
    - Use cross-account subscriptions to send logs from multiple accounts/regions to a central destination (e.g., central S3 bucket via Firehose).
    - Flow: Accounts A/B/C (regions 1/2/3) CloudWatch Logs → Subscription Filters → Kinesis Data Streams → Kinesis Data Firehose → *near real-time* → S3

### CloudWatch Agent

- **CloudWatch Logs Agent (Legacy)**: Sends log files from EC2/on-prem servers to CloudWatch Logs.
- **CloudWatch Unified Agent (Current)**
    - Collects system-level metrics (RAM, Disk IO, Netstat, Processes, CPU details etc.) *in addition* to logs.
    - Supports EC2 and on-premises servers.
    - Centralized configuration via SSM Parameter Store.

### CloudWatch Alarms

- **Overview**: Trigger actions based on metric thresholds or log metric filters.
- **States**: OK, ALARM, INSUFFICIENT_DATA.
- **Evaluation Period**: Configurable time window for checking the metric. Supports high-resolution (10s, 30s) for custom metrics.
- **Targets/Actions**
    - **EC2 Actions**: Stop, Terminate, Reboot, Recover instance.
    - **Auto Scaling Actions**: Trigger scaling policies.
    - **SNS Notifications**: Send alerts to an SNS topic (for email, SMS, Lambda triggers, etc.).
- **Composite Alarms**
    - Combine the states of multiple alarms using AND/OR logic to reduce alarm noise.
    - Example: CW Alarm A (monitor CPU) + CW Alarm B (monitor IOPS) on an EC2 instance → composite alarm → trigger SNS
- **EC2 Instance Recovery**
    - Trigger automatic recovery based on System Status Check failures.
    - Flow: CloudWatch Alarm (`StatusCheckFailed_System`) monitors EC2 instance → EC2 Instance Recovery; alert → SNS Topic

### CloudWatch Monitoring Insights

- **Container Insights**: Collects, aggregates, summarizes metrics and logs from container platforms (ECS, EKS, Kubernetes on EC2, Fargate).
- **Lambda Insights**: Provides detailed metrics and diagnostics (e.g., cold starts, memory usage) for Lambda functions via a Lambda Layer.
- **Contributor Insights**: Analyzes log data to identify top contributors (Top-N talkers) impacting performance (e.g., high-traffic IPs, error-prone URLs).
- **Application Insights**: Provides automated dashboards and problem detection for specific application stacks on EC2 (e.g., .NET, SQL Server, Java) and related AWS resources. Integrates with SSM OpsCenter and EventBridge.

## Amazon EventBridge (formerly CloudWatch Events)

### Overview

- Serverless event bus service for integrating applications using events.

### Core Concepts

- **Event Sources**: AWS Services, Custom Applications, SaaS Partners (via Partner Event Buses).
- **Event Buses**: Default (AWS events), Partner, Custom. Supports cross-account access via resource policies.
- **Rules**: Match incoming events based on patterns (filtering) and route them to targets.
- **Targets**: Services to invoke upon matching event (Lambda, SQS, SNS, Step Functions, Kinesis, ECS, EC2 actions, etc.).
- Example sources: EC2 instance (start instance), CodeBuild (build failed), S3 event (upload object), Trusted Advisor (new finding), CloudTrail (any API call), schedule or cron (every 4 hours)
- Example destinations: Compute (Lambda, AWS Batch, ECS Task), Integration (SQS, SNS, Kinesis Data Streams), Orchestration (Step Functions, CodePipeline, CodeBuild), Maintenance (Systems Manager, EC2 Actions)

### Use Cases

- **Scheduling**: Run scheduled tasks (Cron jobs).
    - Event (time-based), e.g. schedule every hour → Lambda
- **Event-Driven Architecture**: React to events from AWS services (e.g., S3 PUT, EC2 state change, CloudTrail API call) or custom applications.
    - Event (event-based), e.g. IAM root user sign-in event → SNS topic (email)

### Features

- **Schema Registry**: Discovers and registers event schemas, allows downloading code bindings.
- **Archive & Replay**: Archive events from a bus to S3, replay them later for testing or recovery.
- **Resource-based Policies**: Control cross-account/region access to event buses.

## AWS X-Ray

### Overview

- **Troubleshooting** application performance and errors.
- **Distributed tracing** of microservices: follow a request end to end across services.
- Visual analysis of the application: find bottlenecks, latency and which service is failing.

### Key Concepts

- **Trace**: The end-to-end path of a single request through all services.
- **Segment**: Data sent by each service (application) that handled the request.
- **Subsegment**: More granular detail inside a segment (e.g., a downstream AWS call, an HTTP call, a database query).
- **Annotations**: Key-value pairs that are **indexed** - use them to search and filter traces.
- **Metadata**: Key-value pairs that are **not indexed** - not used for searching.
- **Service Map**: Graph of services and their connections, with latency and error rates.

### How It Works

- Instrument the application with the **X-Ray SDK**; the SDK sends trace data to the **X-Ray daemon** (a local agent), which sends it to the X-Ray service.
- Sampling: only a percentage of requests is traced to reduce cost and overhead.
- Flow: Client request → Service A → Service B → DynamoDB → *trace data* → X-Ray → Service Map / traces in the console

### Use Cases

- Troubleshoot performance (find bottlenecks) and errors; understand dependencies in a microservice architecture.
- Pinpoint which service is causing issues; review request behavior; find errors and exceptions.

## AWS CloudTrail

### Overview

- Logs API calls made within an AWS account for governance, compliance, operational auditing, and risk auditing. Enabled by default.
- Flow: SDK / CLI / Console / IAM users & roles → CloudTrail console (inspect & audit) → CloudWatch Logs / S3 bucket

### Key Features

- **Event History**: Records actions taken by users, roles, or AWS services via Console, SDK, CLI. Stored for 90 days.
- **Trails**: Configurations that enable delivery of CloudTrail events to S3 and optionally CloudWatch Logs for long-term storage and analysis. Can be multi-region (default) or single-region.
- **Event Types**
    - **Management Events**: Operations on resources (e.g., `CreateSubnet`, `AttachRolePolicy`). Logged by default. Can separate Read/Write.
    - **Data Events**: High-volume resource operations (e.g., S3 `GetObject`, Lambda `Invoke`). *Not* logged by default.
- **CloudTrail Insights**
    - Uses ML to detect unusual API activity patterns (e.g., spikes in provisioning, IAM actions) based on normal baselines. Analyzes management `write` events. Generates Insights events sent to S3/EventBridge.
    - Flow: Management events → *continuous analysis* → CloudTrail Insights → *generate* → Insight events → CloudTrail console / S3 bucket / EventBridge event
- **Log File Integrity Validation**: Ensures logs haven't been tampered with.
- **EventBridge Integration**
    - CloudTrail events can trigger EventBridge rules for real-time alerting or automation (e.g., notify on `DeleteTable` API call).
    - Flow: User → `DeleteTable` API call → DynamoDB → log API call → CloudTrail → event → EventBridge → alert → SNS

### Use Cases

- Security analysis, resource change tracking, troubleshooting operational issues, compliance verification. Finding "who terminated an EC2 instance".

## AWS Config

### Overview

- Assesses, audits, and evaluates the configurations of AWS resources. Tracks configuration changes over time. Primarily for compliance and configuration history.

### Key Features

- **Configuration Recorder**: Records configuration details of supported resources.
- **Configuration History**: View timeline of configuration changes for resources.
- **Compliance Evaluation (Config Rules)**
    - Evaluate resource configurations against desired policies.
    - Use AWS Managed Rules or create Custom Rules (Lambda).
    - Triggered by configuration changes or scheduled.
    - Does **not** prevent non-compliant actions, only reports them.
- **Remediation Actions**: Automatically remediate non-compliant resources using SSM Automation documents.
- **Notifications**: Send configuration changes or compliance status changes via SNS/EventBridge.
- **Multi-Account Multi-Region Aggregation**: Centralize Config data and compliance status.
- **Resource Relationship View**: Explore how resources are related.

### Use Cases

- Compliance auditing (e.g., "Is SSH unrestricted?", "Are S3 buckets public?"), tracking configuration drift, security analysis, operational troubleshooting.

## Comparison: CloudWatch vs. X-Ray vs. CloudTrail vs. Config

- **CloudWatch**: Focuses on **performance & operation** (Metrics, Logs, Events, Alarms).
- **X-Ray**: Focuses on **request tracing** across microservices (Where is the latency or error?).
- **CloudTrail**: Focuses on **API activity** (Who did what, when?). Audit trail.
- **Config**: Focuses on **resource configuration & compliance** (What did my resource look like? Is it compliant?). Tracks changes over time.
