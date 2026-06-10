# Lab: Infrastructure as Code with CloudFormation

[← Labs index](../README.md) · **Service:** CloudFormation · **Level:** Intermediate

**Ref:** [Udemy SAA-C03 - CloudFormation](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c03/)

Provision EC2 infrastructure declaratively instead of clicking through the
console. Each template builds on the previous one.

| # | Template | Teaches |
|---|----------|---------|
| 1 | [`ec2-only.yaml`](templates/ec2-only.yaml) | Smallest useful template; SSM-resolved latest AMI; `Parameters`, `Outputs` |
| 2 | [`ec2-with-sg-eip.yaml`](templates/ec2-with-sg-eip.yaml) | Security groups + Elastic IP; **`SecurityGroupIds` vs `SecurityGroups`** pitfall; AWS-specific parameter types |

---

## Lab Objectives

- [ ] Deploy a stack from a template (console **and** CLI).
- [ ] Use the **SSM Public Parameter Store** to always get the latest AMI.
- [ ] Understand why VPC instances reference security groups **by ID**.
- [ ] Read stack **Outputs** and clean up by deleting the stack.

---

## ⚠️ The one bug worth remembering: `SecurityGroups` vs `SecurityGroupIds`

A very common first CloudFormation error:

```yaml
# ❌ WRONG inside a VPC - deploy fails with:
#    "The parameter groupName cannot be used with the parameter subnet"
Properties:
  SubnetId: !Ref SubnetId
  SecurityGroups:            # <- takes group NAMES, EC2-Classic / default VPC only
    - !Ref SSHSecurityGroup
```

```yaml
# ✅ CORRECT inside a VPC
Properties:
  SubnetId: !Ref SubnetId
  SecurityGroupIds:          # <- takes group IDs
    - !Ref SSHSecurityGroup
```

`!Ref` on a VPC `AWS::EC2::SecurityGroup` returns its **group ID**, which is
exactly what `SecurityGroupIds` expects. The older `SecurityGroups` property
expects group *names* and cannot be combined with a `SubnetId`.

---

## Why `LatestAmiId` instead of a hard-coded AMI

```yaml
LatestAmiId:
  Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
  Default: /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64
```

A literal `ami-0453ec754f44f9a4a` is **Region-specific** and gets
**deregistered** over time, breaking the template. AWS publishes the current
AMI IDs in the SSM Public Parameter Store, so this resolves the right AMI at
deploy time in any Region.

---

## 1. Deploy via the Console

1. Go to **CloudFormation** > **Create stack** > **With new resources**.
2. **Upload a template file** and choose `templates/ec2-only.yaml`.
3. Give the stack a name (e.g. `ec2-only-lab`), accept the parameter defaults.
4. Click through and **Submit**. Wait for `CREATE_COMPLETE`.
5. Open the **Outputs** tab to see the `InstanceId`.

For `ec2-with-sg-eip.yaml`, the `VpcId` and `SubnetId` parameters render as
**dropdowns** (thanks to their `AWS::EC2::VPC::Id` / `AWS::EC2::Subnet::Id`
types) - pick a VPC and a subnet that belongs to it.

---

## 2. Deploy via the CLI

```bash
# Template 1 - all defaults
aws cloudformation deploy \
  --template-file templates/ec2-only.yaml \
  --stack-name ec2-only-lab

# Template 2 - pass the VPC/subnet (and ideally lock down SSH to your IP)
aws cloudformation deploy \
  --template-file templates/ec2-with-sg-eip.yaml \
  --stack-name ec2-sg-eip-lab \
  --parameter-overrides \
      VpcId=vpc-0123456789abcdef0 \
      SubnetId=subnet-0123456789abcdef0 \
      SSHLocation=$(curl -s https://checkip.amazonaws.com)/32

# Read the outputs
aws cloudformation describe-stacks --stack-name ec2-sg-eip-lab \
  --query "Stacks[0].Outputs" --output table
```

> 💡 From the repo root you can also run `make validate` to lint every template
> with `cfn-lint`, or `make deploy TEMPLATE=ec2-only STACK=ec2-only-lab`.

---

## 🧹 Cleanup

Deleting the stack removes everything it created (instance, security groups,
Elastic IP) in one shot - no orphaned resources:

```bash
aws cloudformation delete-stack --stack-name ec2-only-lab
aws cloudformation delete-stack --stack-name ec2-sg-eip-lab
```

Or in the console: select the stack > **Delete**.
