---
title: Networking - VPC
markmap:
  colorFreezeLevel: 2
  initialExpandLevel: 2
---

# Networking - VPC

## Core Networking Concepts

### CIDR (Classless Inter-Domain Routing)

- Method for allocating IP addresses and routing.
- Defines IP address ranges (e.g., /32 for one IP, /0 for all IPs).
- Composed of Base IP and Subnet Mask.
- Subnet mask defines how many bits can change (e.g., /32, /24, /16, /8, /0).

### Private vs. Public IP (IPv4)

- IANA allocates specific blocks for private (LAN) and public (Internet) use.
- Private IP ranges: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16.
- All other IPs are public.

### IPv6

- Successor to IPv4, providing a vastly larger address space.
- AWS IPv6 addresses are public and internet-routable.
- VPCs can operate in dual-stack mode (IPv4 & IPv6).
- EC2 instances get both private IPv4 and public IPv6 addresses.
- IPv4 cannot be disabled for VPCs/subnets.
- Launch failures might be due to lack of IPv4, not IPv6.

## VPC (Virtual Private Cloud)

### Overview

- Logically isolated section of the AWS Cloud.
- Can have multiple VPCs per region (default limit 5).
- Max 5 CIDR blocks per VPC.
- CIDR block size range: /16 (max) to /28 (min).
- Requires private IPv4 ranges.
- VPC CIDR should not overlap with other networks (e.g., corporate).

### Default VPC

- Provided for all new AWS accounts.
- Instances launched here by default if no subnet specified.
- Has internet connectivity; instances get public IPv4.
- Includes public and private DNS names.

### Subnets

- A segment of a VPC's IP address range within a specific Availability Zone (AZ).
- AWS reserves 5 IP addresses per subnet (first 4, last 1).
  - .0: Network Address
  - .1: VPC Router
  - .2: AWS DNS
  - .3: Future Use
  - .255: Broadcast Address (not supported, reserved)
- Determine required subnet size based on needed IPs (e.g., need 29 IPs → requires /26, not /27).

### Route Tables

- Control where network traffic from subnets is directed.
- Must be edited to enable internet access, VPC peering, etc.

## Network Security

### Security Groups (SG)

- Act as a firewall for EC2 instances (instance level).
- Stateful: If outbound traffic is allowed, return inbound traffic is automatically allowed.
- Support ALLOW rules only.
- Evaluate all rules before allowing traffic.
- Can reference other Security Groups as source/destination (even across peered VPCs in the same region).

### Network Access Control Lists (NACLs)

- Act as a firewall for subnets (subnet level).
- Stateless: Return traffic must be explicitly allowed by rules.
- Support ALLOW and DENY rules.
- Rules evaluated in order (lowest number first); first match determines action.
- Default NACL allows all inbound/outbound traffic.
- Newly created NACLs deny all traffic by default.
- Useful for blocking specific IP addresses at the subnet level.
- **Ephemeral Ports**: Remember to allow return traffic on ephemeral port ranges (e.g., 1024-65535) for stateless NACLs.
  - Example: client 11.22.33.44:50105 → web server 55.66.77.88:443; response goes back to the client's ephemeral port 50105

### Security Groups vs. NACLs

- SG: Instance level, stateful, allow only.
- NACL: Subnet level, stateless, allow/deny, rules evaluated by number.
- Incoming request: NACL inbound → SG inbound → instance; response passes SG automatically (stateful) but must pass NACL outbound rules (stateless)
- Outgoing request: SG outbound → NACL outbound; response passes NACL inbound rules, SG automatically

### AWS Network Firewall

- Managed firewall service to protect entire VPCs.
- Provides Layer 3 to Layer 7 protection.
- Inspects traffic in any direction (VPC-to-VPC, Inbound/Outbound Internet, DX/VPN).
- Fine-grained controls: Thousands of rules (IP, port, protocol, domain lists, regex).
- Stateful inspection and Intrusion Prevention capabilities.
- Centrally managed via AWS Firewall Manager.

## VPC Connectivity

### Internet Gateway (IGW)

- Allows VPC resources to connect to the internet.
- Horizontally scaled, redundant, and highly available.
- Must be attached to a VPC (one IGW per VPC).
- Requires route table updates to function.
- Supports IPv4 and IPv6.

### Egress-only Internet Gateway

- For IPv6 only.
- Allows outbound IPv6 connections from VPC instances while preventing inbound initiation from the internet.
- Like a NAT Gateway for IPv6.
- Requires route table updates.

### NAT Instances (Network Address Translation - Outdated)

- Allow instances in private subnets to connect out to the internet.
- Launched in a public subnet.
- Requires disabling Source/Destination check on the EC2 instance.
- Requires an Elastic IP.
- Needs route table configuration.
- Requires manual management (HA, patching, Security Groups).
- Bandwidth depends on EC2 instance type.

### NAT Gateways

- AWS-managed NAT service.
- Higher bandwidth (5 Gbps, scales to 100 Gbps), HA within an AZ, no admin overhead.
- Priced per hour and data processed.
- Created in a specific AZ, uses an Elastic IP.
- Requires an IGW.
- Cannot be used by instances in the same subnet.
- No Security Groups required.
- For HA across AZs, create multiple NAT Gateways in different AZs.

### Bastion Hosts

- EC2 instance in a public subnet used to securely access instances in private subnets (e.g., via SSH).
- Security Group should allow inbound SSH (port 22) from trusted IPs (e.g., corporate CIDR).
- Private instance SGs should allow traffic from the Bastion Host's SG or private IP.

### VPC Peering

- Connects two VPCs privately using AWS network.
- VPCs behave as if in the same network.
- CIDRs must not overlap.
- Not transitive (A-B and B-C does not mean A-C).
- Requires route table updates in both peered VPCs.
- Works across accounts and regions.
- Can reference Security Groups in peered VPC (same region).

### VPC Endpoints (AWS PrivateLink)

- Connect privately to AWS services without using IGW, NAT, etc.
- Powered by AWS PrivateLink.
- Redundant and scalable.
- **Troubleshooting**: Check VPC DNS settings and Route Tables.
- Types
  - **Interface Endpoints**
    - Provisions an ENI with a private IP.
    - Requires a Security Group.
    - Supports most AWS services.
    - Charged per hour + data processed.
    - Preferred for on-prem, cross-VPC, or cross-region access.
  - **Gateway Endpoints**
    - Provisions a gateway target for route tables.
    - Does not use Security Groups.
    - Supports S3 and DynamoDB only.
    - Free.

### Site-to-Site VPN

- Securely connect on-premises network or datacenter to a VPC over the public internet.
- Components
  - **Virtual Private Gateway (VGW)**: VPN concentrator on AWS side, attached to the VPC.
  - **Customer Gateway (CGW)**: Physical device or software app on customer side. Uses public IP (or NAT-T public IP).
  - Requires route propagation enabled in VPC route tables.
  - Often used as a backup for Direct Connect.

### AWS VPN CloudHub

- Hub-and-spoke model for secure communication between multiple sites using Site-to-Site VPN connections.
- Connects multiple CGWs to a single VGW.
- Low-cost alternative for connecting multiple locations over VPN.

### Direct Connect (DX)

- Dedicated private physical network connection from on-premises to AWS Direct Connect locations.
- Bypasses the public internet.
- Use cases: High bandwidth needs, consistent network experience, hybrid environments.
- Requires VGW on the VPC.
- Can access public (S3) and private (EC2) resources.
  - Private Virtual Interface → VPC resources; Public Virtual Interface → public AWS services (S3, Glacier)
- Supports IPv4 and IPv6.
- Connection Types
  - **Dedicated**: 1/10/100 Gbps physical port.
  - **Hosted**: 50 Mbps to 10 Gbps via DX Partners.
- Encryption: Data is not encrypted by default but is private. Use DX + VPN for IPsec encryption.
- Resiliency: Achieved via multiple connections to one or more DX locations.

### Direct Connect Gateway

- Connect a single Direct Connect connection to multiple VPCs across different regions within the same account.

### Transit Gateway

- Central hub for transitive peering between VPCs, VPNs, and Direct Connect Gateways.
- Simplifies complex network topologies (replaces mesh peering).
- Regional resource, can be peered across regions.
- Can be shared across accounts using RAM.
- Route tables control inter-VPC communication.
- Supports IP Multicast.
- **ECMP (Equal-Cost Multi-Path Routing)**: Use multiple Site-to-Site VPNs to increase bandwidth to TGW (up to 50 Gbps).

## Monitoring & Troubleshooting

### VPC Flow Logs

- Captures IP traffic information for VPCs, Subnets, or ENIs.
- Monitors and troubleshoots connectivity issues.
- Captures traffic for AWS managed interfaces (ELB, RDS, NATGW, etc.).
- Logs ACCEPT and REJECT actions based on SGs/NACLs.
- Destinations: S3, CloudWatch Logs, Kinesis Data Firehose.
- Can be queried using Athena (on S3) or CloudWatch Logs Insights.
  - Flow Logs → CloudWatch Logs → Contributor Insights → top 10 IP addresses
  - Flow Logs → CloudWatch Logs → metric filter → CloudWatch Alarm → SNS
  - Flow Logs → S3 → Athena → QuickSight
- **Troubleshooting SG/NACL Issues**
  - Inbound REJECT ⇒ NACL or SG problem.
  - Inbound ACCEPT, Outbound REJECT ⇒ NACL problem.
  - Outbound REJECT ⇒ NACL or SG problem.
  - Outbound ACCEPT, Inbound REJECT ⇒ NACL problem.

### VPC Traffic Mirroring

- Copies network traffic from ENIs (source) to security/monitoring appliances (target: ENI or NLB).
- Used for content inspection, threat monitoring, troubleshooting.
- Can filter or truncate packets.
- Source and target can be in the same or different (peered) VPCs.

## Networking Costs

- Diagram: traffic in is free; same AZ via private IP free; across AZs $0.01 via private IP, $0.02 via public/Elastic IP; inter-region $0.02

### Data Transfer In (Ingress)

- Mostly free.

### Data Transfer Out (Egress)

- Charged per GB; varies by destination (Internet, other regions).

### Intra-Region Costs

- Within same AZ using Private IP: Free.
- Across AZs using Private IP: $0.01/GB each way.
- Across AZs using Public IP/Elastic IP: $0.02/GB.

### Inter-Region Costs

- Higher egress charges apply.

### Minimizing Costs

- Use Private IPs instead of Public IPs within AWS.
- Keep traffic within the same AZ (trade-off with HA).
- Use services like CloudFront for internet egress (often cheaper than direct S3 egress, plus caching).
- Use Gateway VPC Endpoints (free) instead of NAT Gateways (charged) for S3/DynamoDB access from within VPC.
- Co-locate Direct Connect locations in the same AWS Region.
