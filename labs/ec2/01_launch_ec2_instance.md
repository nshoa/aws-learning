### AWS Lab: Launch an EC2 Instance (with a User-Data Web Server)

[← Labs index](../README.md) · **Service:** EC2 · **Level:** Beginner

**Ref:** [Udemy SAA-C03 - EC2 Fundamentals](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c03/)

---

### Lab Objectives

- [ ]  Launch an Amazon Linux 2023 EC2 instance (free-tier).
- [ ]  Attach a Security Group allowing SSH (22) and HTTP (80).
- [ ]  Bootstrap a web server with **User Data**.
- [ ]  Connect to the instance and verify the running site.

> 💡 Prefer Infrastructure as Code? The same setup is automated in the
> [CloudFormation lab](../cloud_formation/README.md).

---

### 1. Launch the Instance

1. Go to the **EC2 Console** > **Instances** > **Launch instances**.
2. **Name:** `my-first-instance`.
3. **AMI:** Amazon Linux 2023 (free-tier eligible).
4. **Instance type:** `t2.micro` or `t3.micro` (free-tier eligible).
5. **Key pair:** Create or select one (needed for SSH). Download the `.pem`.

---

### 2. Configure the Security Group

Under **Network settings** > **Edit**, create a security group with two
inbound rules:

| Type | Protocol | Port | Source | Purpose |
|------|----------|------|--------|---------|
| SSH | TCP | 22 | **My IP** | Admin access (lock to your IP!) |
| HTTP | TCP | 80 | Anywhere `0.0.0.0/0` | Serve the website |

> ⚠️ Setting SSH source to `0.0.0.0/0` exposes port 22 to the whole internet.
> Always scope it to **My IP** in real environments.

---

### 3. Add User Data (Bootstrap Script)

Expand **Advanced details** > **User data** and paste:

```bash
#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl enable --now httpd
echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
```

Then click **Launch instance**.

> *Note:* User Data runs **once**, as root, on first boot.

---

### 4. Verify

1. Wait until **Instance state** = `Running` and **Status check** = `2/2 checks passed`.
2. Copy the **Public IPv4 address**.
3. **Web:** open `http://<public-ip>` — you should see the "Hello from ..." page.
4. **SSH (optional):**

   ```bash
   chmod 400 my-key.pem
   ssh -i my-key.pem ec2-user@<public-ip>
   ```

> 🐛 Page not loading? Check: instance is `Running`, the SG allows port 80, and
> you used `http://` (not `https://`).

---

### 🧹 Cleanup

- [ ]  **Terminate** the instance (Instance state > Terminate).
- [ ]  Delete the **Security Group** once the instance is gone.
- [ ]  Delete the **Key Pair** if you no longer need it.
