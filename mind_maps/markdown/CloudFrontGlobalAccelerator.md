---
title: CloudFront & Global Accelerator
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# CloudFront & Global Accelerator

## AWS CloudFront

### Overview

- Content Delivery Network (CDN).
- Improves read performance by caching content at edge locations.
- Enhances user experience with low latency.
- 216 Points of Presence (PoPs) globally.
- DDoS protection via global distribution.
- Integrated with AWS Shield and AWS Web Application Firewall (WAF).
- Flow: Clients → `GET /beach.png` → CloudFront Edge Location (local cache) → forward request to your Origin (S3 or HTTP)

### Origins

- **S3 Bucket**
  - Distributes files and caches them at edge locations.
  - Enhanced security with CloudFront Origin Access Control (OAC).
  - OAC replaces Origin Access Identity (OAI).
  - Can be used for file uploads via CloudFront as ingress.
  - Diagram: users (public www) → edges (Los Angeles, São Paulo, Mumbai, Melbourne) → private AWS network → origin S3 bucket, protected by OAC + S3 bucket policy
- **Custom Origin (HTTP)**
  - Can use ALB, EC2 instances, or S3 Websites.
  - For S3 Websites, must enable the bucket for static hosting.
  - Diagram:
    - Edge Location → EC2 instances (*must* be public); Security Group allows public IPs of Edge Locations
    - Edge Location → ALB (*must* be public; SG allows public IPs of Edge Locations) → EC2 instances (*can* be private; SG allows Security Group of the Load Balancer)

### Key Features

- **Geo Restriction**
  - Restrict access to content based on geographic location.
  - Uses allowlist (approved countries) or blocklist (banned countries).
  - Country determination relies on a third-party Geo-IP database.
  - Use Cases
    - Compliance with copyright laws.
    - Controlling regional access to content.
- **CloudFront Pricing**
  - Costs vary by edge location.
  - Can reduce costs by limiting edge locations.
  - Three pricing classes
    - **Price Class All**: All regions—best performance.
    - **Price Class 200**: Most regions, excludes costly ones.
    - **Price Class 100**: Least expensive regions only.
- **Cache Invalidations**
  - Necessary when backend origin updates, as CloudFront won't refresh cached data until TTL expires.
  - Can bypass TTL by performing invalidations
    - Invalidate all files (`*`).
    - Invalidate specific paths (e.g., `/images/*`).

### Comparisons

- **CloudFront vs S3 Cross Region Replication**
  - **CloudFront**
    - Caches files globally at **edge locations** for a defined TTL (e.g., one day).
    - Utilizes a **global content delivery network (CDN)** to deliver content with **high availability** and reduced latency.
    - Best suited for **static content** that needs global access.
    - Does not synchronize data changes but instead provides cached content delivery.
  - **S3 Cross Region Replication**
    - Replicates files to specific regions and updates them in **near real-time**.
    - Requires **explicit configuration** for each replication region.
    - Ideal for **dynamic content** requiring **low-latency access** in select regions.
    - Replicates data as **read-only** in the target regions.

## AWS Global Accelerator

### Overview

- Optimizes global applications by routing via AWS internal network.
- Minimizes latency and reduces internet hops for better speed.
- Uses globally available Edge Locations connected to AWS network.

### Unicast IP vs Anycast IP

- **Unicast IP**: one server holds one IP address (e.g. `12.34.56.78`, `98.76.54.32`).
- **Anycast IP**
  - All servers share the same IP address.
  - Client is routed to the nearest available server.

### Key Features

- **Anycast IP**
  - Two Anycast IPs created for each application.
  - Routes traffic to the nearest edge location.
  - Edge locations forward traffic to the application.
  - Works with Elastic IP, EC2 instances, ALB, NLB (public or private).
- **Consistent Performance**
  - Routes to lowest-latency paths.
  - Fast regional failover (deterministic).
  - Doesn't rely on client cache as IPs are static.
  - Leveraging AWS internal network improves reliability.
- **Health Checks**
  - Constantly monitors health of targeted applications.
  - Failover occurs in less than one minute for unhealthy applications.
  - Especially helpful for disaster recovery setups.
- **Security**
  - Only two external IPs need to be whitelisted.
  - DDoS protection integrated with AWS Shield.

### Comparisons

- **Global Accelerator vs CloudFront**
  - Both use AWS global network and Edge Locations worldwide.
  - Both integrate with AWS Shield for DDoS protection.
  - **CloudFront**
    - Optimizes for cacheable content like images and videos.
    - Suitable for dynamic site delivery (API acceleration).
    - Serves content directly at the edge.
  - **Global Accelerator**
    - Enhances apps over TCP and UDP, such as gaming or IoT (MQTT).
    - Maintains static IPs for HTTP/HTTPS use cases.
    - Provides fast and deterministic regional failover.
