# EC2 Lab: Launch an Instance with a User-Data Web Server

[← Labs index](../README.md) · **Service:** EC2 · **Level:** Beginner · **Est. time:** 20 min · **Est. cost:** Free tier (`t2.micro` / `t3.micro`; terminate when done)

**Reference:** [Udemy SAA-C03 - EC2 Fundamentals](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c03/)

## Contents

- [Objectives](#objectives)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [References](#references)

## Objectives

- Launch an Amazon Linux 2023 instance on a free-tier type and bootstrap a web server with **User Data**.
- Allow SSH (22) from your IP and HTTP (80) from anywhere with a **security group**, and explain why SSH should never be open to `0.0.0.0/0`.
- Explain that User Data runs **once**, as root, on the first boot.

## Prerequisites

- An AWS account with EC2 permissions, using the **default VPC**.
- A terminal with `ssh` and `curl`; AWS CLI configured (`aws configure`) for the
    verification commands.

> 💡 Prefer Infrastructure as Code? The same setup is automated in the
> [CloudFormation lab](../cloud_formation/README.md).

## Steps

### 1. Choose the Instance Settings

1. Open the **EC2 Console** > **Instances** > **Launch instances**.
2. **Name:** `my-first-instance`.
3. **AMI:** Amazon Linux 2023 (free tier eligible).
4. **Instance type:** `t2.micro` or `t3.micro`, whichever is marked free tier eligible in
    your region.
5. **Key pair:** create one (or select an existing one) and download the `.pem` file.

### 2. Configure the Security Group

Under **Network settings** > **Edit**, keep **Auto-assign public IP** enabled and create a
security group with two inbound rules:

| Type | Protocol | Port | Source | Purpose |
|------|----------|------|--------|---------|
| SSH | TCP | 22 | **My IP** | Admin access |
| HTTP | TCP | 80 | Anywhere `0.0.0.0/0` | Serve the website |

> ⚠️ An SSH source of `0.0.0.0/0` exposes port 22 to the whole internet. Keep it on
> **My IP**.

### 3. Add User Data and Launch

Expand **Advanced details** > **User data** and paste:

```bash
#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl enable --now httpd
echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
```

Click **Launch instance**.

> 💡 User Data runs **once**, as root, on the first boot. Editing it later does not re-run it.

## Verification

1. Wait until **Instance state** is `Running` and the **Status check** column shows all
    checks passed. Copy the **Public IPv4 address**.
2. Check the web server (give User Data a minute or two to finish after boot):

    ```bash
    curl -s http://<public-ip>
    # Expected: <h1>Hello from ip-172-31-...</h1>
    ```

3. Connect over SSH:

    ```bash
    chmod 400 my-key.pem
    ssh -i my-key.pem ec2-user@<public-ip>
    ```

4. Confirm the instance from the CLI:

    ```bash
    aws ec2 describe-instances --filters "Name=tag:Name,Values=my-first-instance" \
      --query 'Reservations[].Instances[].{State:State.Name,Type:InstanceType,IP:PublicIpAddress}'
    # Expected: "State": "running", "Type": "t2.micro" (or t3.micro), and the public IP
    ```

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Browser shows a connection error | Used `https://`, or the security group lacks port 80 | Use `http://`; add the HTTP rule |
| `curl` connects but the page is the Apache test page or missing | User Data still running, or the script failed | Wait a minute; on the instance check `sudo cat /var/log/cloud-init-output.log` |
| `Permission denied (publickey)` over SSH | Wrong key, wrong user, or key file too open | Use the key chosen at launch, user `ec2-user`, and `chmod 400` |
| SSH times out | Your IP changed since the SG rule was created | Edit the SSH rule and select **My IP** again |
| No public IPv4 address | Auto-assign public IP was disabled | Terminate and relaunch with it enabled (or attach an Elastic IP) |

## Cleanup

> 💸 A running instance keeps consuming free-tier hours, and charges once they run out.

- [ ] **Terminate** the instance (**Instance state** > **Terminate instance**).
- [ ] Delete the **security group** once the instance is terminated.
- [ ] Delete the **key pair** (and the local `.pem`) if you no longer need it.

## References

- [Get started with Amazon EC2 (AWS docs)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html)
- [Run commands when you launch an EC2 instance with user data input (AWS docs)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
