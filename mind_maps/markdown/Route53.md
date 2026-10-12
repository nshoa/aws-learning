---
title: Route 53
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# Route 53

## DNS Fundamentals

### Overview
- Translates human-friendly domain names (e.g., www.google.com) into machine-friendly IP addresses (e.g. 8.9.10.11).
- Core component of the Internet's infrastructure with a hierarchical naming structure.
- **Structure of URL**: `https://api.example.com`
  - Protocol: https
  - Sub Domain: api
  - Second Level Domain - SLD: example
  - Top Level Domain - TLD: .com
  - Root (SLD + TLD): example.com
  - Full Qualified Domain Name - FQDN (Sub-domain + root): api.example.com

### Terminologies
- **Domain Registrar**: Entities like Amazon Route 53 and GoDaddy that sell domain names.
- **DNS Records**: Include A, AAAA, CNAME, NS, and several advanced record types (CAA, DS, MX, etc.).
- **Zone File**: A collection of DNS records for a given domain.
- **Name Servers**: Servers that resolve DNS queries (can be either authoritative or non-authoritative).
- **Top Level Domain (TLD)**: e.g., .com, .org, .gov.
- **Second Level Domain (SLD)**: e.g., amazon.com, google.com.

### DNS Lookup Process
1. User enter a domain name in the browser
2. Check the DNS Cache (Local Cache Lookup)
3. Query the Local DNS Resolver
4. Query External DNS Servers (Hierarchical Process)
5. Return the Result to the Resolver
6. Browser Connects to the Web Server
- Diagram: Web browser → Local DNS server (assigned by company/ISP) → Root DNS server (managed by ICANN) → TLD DNS server `.com` (managed by IANA) → SLD DNS server `example.com` (managed by domain registrar, e.g. Amazon Registrar) → IP returned (with TTL) → browser accesses web server

## Route 53 Overview

### Definition & Purpose
- A highly available, scalable, and fully managed authoritative DNS service provided by AWS.
- Functions as both a DNS service and a Domain Registrar.
- Offers a 100% availability Service Level Agreement - SLA along with integrated health checking for automated DNS failover.
- The name "53" is a reference to the standard DNS port.

### Key Capacities
- Dynamic DNS *record management* and *routing policies*.
- Native integration with AWS resources such as ELB, CloudFront, API Gateway, etc.

## Hosted Zones
- **Concept & Role**: A container that holds DNS records defining how to route traffic for a domain and its subdomains.
- **Cost Consideration**: Typically around $0.50 per month per hosted zone.
- **Types of Hosted Zones**
  - **Public Hosted Zones**: Manage DNS records for public domains accessible on the Internet.
    - Client asks `example.com?` → public hosted zone returns `54.22.33.44` → S3 bucket / CloudFront / EC2 (public IP) / ALB
  - **Private Hosted Zones**: Manage records used internally within one or more VPCs.
    - e.g. `webapp.example.internal` → `api.example.internal` (10.0.0.10) → `db.example.internal` (10.0.0.35), all private IPs

## DNS Records

### Record Components
- **Domain/Subdomain Name**: e.g., example.com or www.example.com.
- **Record Type**: e.g., A, AAAA, CNAME, NS, etc.
- **Value**: Contains information such as an IP address or an AWS resource endpoint.
- **Routing Policy**: Defines how responses to DNS queries are formulated.

### Supported Record Types
- **TTL (Time To Live)**: Duration for which the record remains cached by DNS resolvers.
- **A Record**: Maps a hostname to an IPv4 address.
- **AAAA Record**: Maps a hostname to an IPv6 address.
- **CNAME Record**: Points a hostname to another hostname (must be used for subdomains, never at the zone apex).
- **NS Record**: Designates the name servers for the hosted zone.
- **Advanced Records**: Include CAA, DS, MX, NAPTR, PRT, SOA, TXT, SPF, and SRV for more complex requirements.

## CNAME vs. Alias Record

### CNAME Record
- Map one hostname to another hostname.
- Cannot be used at the zone apex (e.g., example.com).
- Suitable for subdomain redirection (e.g., app.mydomain.com to another external hostname - blabla.anything.com).

### Alias Record
- Designed to point a hostname directly to AWS resources. e.g. mycoolcompany.com to my-elb-1234567890.us-west-2.elb.amazonaws.com
- Can be used for both subdomains and the zone apex.
- Automatically track changes in the AWS resource's IP addresses.
- TTL is managed by AWS and cannot be customized.
- Type A or AAAA

## Health Checks and Failover Mechanisms

### Health Check Overview
- Monitors endpoint health (e.g., web servers, AWS resources) using around 15 global checkers.
- Operates on
  - Defined thresholds (default healthy/unhealthy threshold = 3 checks).
  - intervals (default 30 seconds, configurable to as low as 10 seconds, impacting costs).
- Supports HTTP, HTTPS, and TCP protocols.
- Health is determined by response codes (2xx and 3xx) and can also check for specific text in the response.
- Route 53 Health Checkers are outside VPC
  - → they can't access private endpoints
  - → we can create CloudWatch Metric and associate a CloudWatch Alarm
  - → create a Health Check that checks the alarm itself
- Diagram: health checkers send HTTP requests to `/health` on ALBs; ALB must allow incoming requests from Route 53 health checkers' IP address range

### Calculated Health Checks
- Combine results from multiple child health checks using Boolean logic (OR, AND, NOT).
- Useful for maintenance and ensuring overall service stability even if some endpoints are momentarily offline.
- Diagram: parent health checker ← child health checkers monitoring EC2 instances

### Active-Passive Failover
- Enables automated failover by routing traffic to a standby resource if the primary resource fails its health checks.
- Diagram: DNS requests → Route 53 + health checker (mandatory) → EC2 primary; on failure → EC2 secondary (disaster recovery)

## Routing Policies

### Purpose & Distinctions
- Define how Route 53 responds to DNS queries based on various criteria.
- Note that DNS "routing" isn't the same as traffic routing performed by a load balancer.

### Routing Policy Types
- **Simple Routing**
  - Directs traffic to a single resource.
  - When multiple resource values exist, records are returned at random. (a random one is chosen by the client)
  - Not compatible with health checks when using alias configurations.
- **Weighted Routing**
  - Distributes traffic based on relative weight percentages assigned to resource records.
  - Traffic (%) = Weight for a specific record / Sum of all the weights for all records
  - Enables gradual rollouts or testing of new application versions.
  - Use cases
    - Load Balancing between regions
    - Use Weighted Routing when directing a small percentage (e.g., 5%) of production traffic to a new environment for validation.
  - Can be associated with Health Checks
  - Example: weights 70 / 20 / 10 → 70% / 20% / 10% of traffic
- **Latency-Based Routing**
  - Routes queries to the resource that provides the lowest latency based on the user's location relative to AWS Regions.
  - Can be associated with Health Checks (has failover capability)
  - Use cases: Ideal for applications hosted in multiple regions (e.g., us-west-1 and eu-west-2) to minimize response times.
- **Geolocation Routing**
  - Routes users based on their geographic location (continent, country, or even state).
  - A "default" record is used when a user's location isn't explicitly defined.
  - Can be associated with Health Checks
  - Use cases
    - Load balancing
    - Suitable when a legal requirement restricts access, such as blocking all countries except France.
- **Geoproximity Routing (via Traffic Flow)**
  - Routes traffic based on the physical location of users and resources, with an option to bias results.
  - Specify bias values (from 1 to 99).
    - To expand (1 to 99): more traffic to the resources
    - To shrinking (-1 to -99): less traffic to the resources
  - Resources can be
    - AWS resources (specify AWS region)
    - Non AWS resources (specify Latitude and Longitude)
- **IP-Based Routing**
  - Routes based on client IP address ranges.
  - Use cases: Useful for optimizing performance or cost by matching specific CIDR blocks to endpoints.
- **Multi-Value Answer Routing**
  - Returns multiple healthy resource records for a single DNS query, provided they pass the associated health checks.
  - Not intended as a substitute for load balancing using a service like an ELB.
