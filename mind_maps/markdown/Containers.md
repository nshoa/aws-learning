---
title: "Containers: ECS, Fargate, ECR & EKS"
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# Containers: ECS, Fargate, ECR & EKS

## Docker Fundamentals

### Overview

- Software platform to deploy applications in containers.
- Ensures apps run consistently across environments.
- Benefits: No compatibility issues, predictable behavior, less work, easier maintenance/deployment.
- Works with any language, OS, technology.
- Use Cases: Microservices, lift-and-shift applications.

### Docker vs. Virtual Machines (VMs)

- Docker shares resources with the host OS, allowing many containers per server.
  - Stack: containers → Docker Daemon → Host OS (EC2 Instance) → Infrastructure
- VMs require a guest OS for each application, consuming more resources.
  - Stack: Apps → Guest OS (VM) → Hypervisor → Host OS → Infrastructure

### Docker Image Storage

- **Docker Hub**: Public repository for base images (Ubuntu, MySQL, etc.).
- **Amazon ECR (Elastic Container Registry)**: AWS's private and public container registry.

### Getting Started with Docker

- **Dockerfile**: Defines how to build a Docker image.
- **Build**: Creates a Docker image from a Dockerfile.
- **Push/Pull**: Store/retrieve images from a Docker Repository (Docker Hub, ECR).
- **Run**: Executes a Docker container from an image.
- Flow: Dockerfile → *build* → image → *run* → container; image ⇄ *push/pull* ⇄ Docker Repository (Docker Hub / Amazon ECR)

## AWS Container Management Services

- **Amazon ECS (Elastic Container Service)**: AWS's proprietary container orchestration service.
- **Amazon EKS (Elastic Kubernetes Service)**: AWS's managed Kubernetes service.
- **AWS Fargate**: Serverless compute engine for containers (works with ECS and EKS).
- **Amazon ECR (Elastic Container Registry)**: Stores container images.

## Amazon ECS (Elastic Container Service)

### Overview

- Launch Docker containers (ECS Tasks) on ECS Clusters.

### Launch Types

- **EC2 Launch Type**
  - Requires provisioning and managing EC2 instances.
  - EC2 instances need the ECS Agent installed to register with the cluster.
- **Fargate Launch Type**
  - Serverless - no need to manage EC2 instances.
  - Define tasks, and AWS runs them based on specified CPU/RAM.
  - Scaling involves adjusting the number of tasks.

### IAM Roles

- **EC2 Instance Profile (EC2 Launch Type Only)**
  - Used by the ECS Agent on EC2 instances.
  - Permissions needed: Call ECS API, send logs to CloudWatch, pull images from ECR, access Secrets Manager/SSM Parameter Store.
- **ECS Task Role**
  - Grants specific permissions to individual ECS tasks.
  - Allows different roles for different services/tasks.
  - Defined within the ECS Task Definition.
  - Example: Task A Role → S3; Task B Role → DynamoDB

### Load Balancer Integration

- **Application Load Balancer (ALB)**: Recommended for most use cases.
- **Network Load Balancer (NLB)**: For high throughput/performance or AWS PrivateLink integration.
- **Classic Load Balancer (CLB)**: Supported but not recommended (lacks features, no Fargate support).
- Flow: Users → 80/443 → ALB → ECS Tasks on EC2 instances in the ECS Cluster

### Data Volumes (Amazon EFS)

- Mount EFS file systems onto ECS tasks.
- Compatible with both EC2 and Fargate launch types.
- Provides persistent, multi-AZ shared storage for containers.
- Enables serverless persistent storage.

### ECS Service Auto Scaling

- Automatically adjusts the number of running ECS tasks.
- Uses AWS Application Auto Scaling.
- **Scaling Metrics**
  - ECS Service Average CPU Utilization.
  - ECS Service Average Memory Utilization.
  - ALB Request Count Per Target.
- **Scaling Policies**
  - **Target Tracking**: Maintain a metric around a target value.
  - **Step Scaling**: Scale based on CloudWatch Alarm thresholds.
  - **Scheduled Scaling**: Scale based on a predictable schedule.

### EC2 Launch Type - Auto Scaling EC2 Instances

- Scales the underlying EC2 infrastructure to support ECS task scaling.
- **Auto Scaling Group (ASG) Scaling**: Scale ASG based on EC2 metrics (e.g., CPU).
- **ECS Cluster Capacity Provider**
  - Automates infrastructure provisioning for ECS tasks.
  - Links an ASG to ECS, adding EC2 instances when tasks need more capacity (CPU, RAM).
- Flow: CloudWatch Metric (ECS Service CPU Usage) → *trigger* → CloudWatch Alarm → scale service tasks → (optional) scale ECS Capacity Providers

### ECS Solution Architectures

- **Event-Driven Tasks (EventBridge)**: Trigger ECS tasks based on events (e.g., S3 object upload).
  - Client uploads object → S3 → event → EventBridge rule "Run ECS Task" → Fargate task (ECS Task Role: access S3 & DynamoDB) gets object → saves result to DynamoDB
- **Scheduled Tasks (EventBridge Schedule)**: Run ECS tasks on a schedule (e.g., hourly batch jobs).
  - EventBridge rule (every 1 hour) → Fargate task (ECS Task Role: access S3) → batch processing into S3
- **Queue Processing (SQS)**: ECS tasks poll an SQS queue for messages and process them; can auto-scale based on queue length.
- **Monitoring Stopped Tasks (EventBridge)**: Capture task state changes (e.g., "STOPPED") and trigger actions (e.g., send SNS notification).
  - Container exited → event → EventBridge → trigger → SNS → email → Admin

## Amazon ECR (Elastic Container Registry)

- **Overview**: Managed Docker container image registry service.
- **Repository Types**: Private and Public (Amazon ECR Public Gallery).
- **Integration**: Integrates with ECS, EKS, Fargate; backed by Amazon S3.
- **Access Control**: Managed via IAM policies.
- **Features**: Image vulnerability scanning, versioning, image tags, lifecycle policies.
- Flow: ECR Repository (Docker images A, B) → *pull* (via IAM Role) → ECS Cluster EC2 instance

## Amazon EKS (Elastic Kubernetes Service)

### Overview

- Managed Kubernetes service on AWS.
- Kubernetes: Open-source container orchestration system.
- Alternative to ECS.

### Use Cases

- Migrating existing Kubernetes workloads from on-premises or other clouds.
- Requires cloud-agnostic container orchestration.

### Node Types

- **Managed Node Groups**: EKS manages EC2 nodes via ASGs (On-Demand or Spot).
- **Self-Managed Nodes**: User manages EC2 nodes and ASGs (using EKS Optimized AMI).
- **AWS Fargate**: Run pods serverlessly without managing nodes.

### Data Volumes

- Relies on Kubernetes `StorageClass` and Container Storage Interface (CSI) drivers.
- Supported Storage: Amazon EBS, Amazon EFS (works with Fargate), Amazon FSx for Lustre, Amazon FSx for NetApp ONTAP.

### Architecture diagram

- VPC across 3 AZs: public subnets (ELB, NGW, EKS Public Service LB), private subnets (EKS nodes running EKS pods in an Auto Scaling Group, EKS Private Service LB)

## AWS App Runner

- Overview: Fully managed service to deploy web applications and APIs from source code or container images.
- Ease of Use: No infrastructure experience required.
- **Features**
  - Automatic build and deployment.
  - Automatic scaling.
  - High availability.
  - Built-in load balancing and encryption.
  - VPC access support for private resources.
- Use Cases: Web apps, APIs, microservices, rapid production deployments.
- Flow: Container image (Docker) or source code → configure settings (vCPU, RAM, Auto Scaling, Health Check) → create & deploy → access using URL

## AWS App2Container (A2C)

- Overview: CLI tool to modernize and migrate Java & .NET web applications to containers.
- Functionality: Lift-and-shift apps from bare metal, VMs, or other clouds to AWS containers.
- Benefits: Accelerates modernization, often without code changes, migrates legacy apps.
- **Process**
  - Discover & Analyze: Inventory apps and analyze dependencies.
  - Extract & Containerize: Package app and dependencies into a Docker image.
  - Create Deployment Artifacts: Generate ECS Task/EKS Pod definitions, CloudFormation templates, CI/CD pipelines.
  - Deploy to AWS: Store image in ECR, deploy to ECS, EKS, or App Runner.
