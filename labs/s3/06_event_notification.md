# S3 Lab: Event Notifications to SQS

[← Labs index](../README.md) · **Service:** S3 · **Level:** Intermediate · **Est. time:** 20 min · **Est. cost:** Free tier

**Reference:** [Udemy DVA-C01 - S3 Event Notifications](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/23743680#lecture-article)

## Contents

- [Objectives](#objectives)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [References](#references)

## Objectives

- [ ] Create an SQS queue to receive S3 events.
- [ ] Add an SQS access policy that lets S3 send messages.
- [ ] Configure an S3 Event Notification for object uploads.
- [ ] Read the event message from the queue.

## Prerequisites

- An AWS account with S3 and SQS permissions.
- An S3 bucket you own, in the **same region** as the queue you will create.
- AWS CLI configured (`aws configure`) for the verification commands.

## Steps

### 1. Create the SQS Queue

1. Open the **SQS Console** and click **Create queue**.
2. **Type:** Standard. **Name:** `s3-notification-queue`.
3. Leave the other settings at their defaults and click **Create queue**.
4. Copy the queue **ARN** and **URL** from the queue details.

### 2. Allow S3 to Send Messages

S3 has no permission to write to your queue until the queue's resource policy allows it.

1. Open the queue > **Access policy** tab > **Edit**.
2. Replace the policy with the following, filling in your queue ARN, bucket name and
   account ID:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "AllowS3ToSendMessage",
         "Effect": "Allow",
         "Principal": { "Service": "s3.amazonaws.com" },
         "Action": "SQS:SendMessage",
         "Resource": "YOUR-SQS-QUEUE-ARN",
         "Condition": {
           "ArnLike": { "aws:SourceArn": "arn:aws:s3:::YOUR-BUCKET-NAME" },
           "StringEquals": { "aws:SourceAccount": "YOUR-ACCOUNT-ID" }
         }
       }
     ]
   }
   ```

3. Click **Save**.

### 3. Configure the Event Notification

1. Open your bucket > **Properties** tab > **Event notifications** > **Create event
   notification**.
2. **Event name:** `NewObjectUpload`.
3. **Event types:** check **All object create events** (`s3:ObjectCreated:*`).
4. **Destination:** **SQS queue**, then choose `s3-notification-queue`.
5. Click **Save changes**. S3 validates the destination by sending an `s3:TestEvent`
   message to the queue.

### 4. Trigger an Event

Upload any file to the bucket.

> 💡 The same steps work with **SNS** or **Lambda** destinations; only the resource policy
> changes. For filtering and more targets, S3 can also send events to **EventBridge**.

## Verification

- Receive messages from the queue:

  ```bash
  aws sqs receive-message --queue-url YOUR-QUEUE-URL --max-number-of-messages 10 \
    --query 'Messages[].Body' --output text
  ```

  Expect the `s3:TestEvent` message from step 3, and an event whose
  `"eventName"` is `"ObjectCreated:Put"` with your object key under `"s3"."object"."key"`.
  In the console: queue > **Send and receive messages** > **Poll for messages**.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| "Unable to validate the following destination configurations" when saving | The queue access policy does not allow S3 | Re-check step 2: queue ARN, bucket name and account ID |
| Saving fails for an encrypted queue | The queue uses SSE-KMS with the AWS managed key `aws/sqs`, which S3 cannot use | Use SSE-SQS, or a customer managed KMS key that allows `s3.amazonaws.com` |
| No messages after uploading | Bucket and queue are in different regions, or the message was already received | Use the same region; received messages become visible again after the visibility timeout |

## Cleanup

> 💸 Delete billable resources to avoid surprise charges.

- [ ] Delete the event notification on the bucket.
- [ ] Delete the SQS queue.
- [ ] Delete the test objects (and the bucket, if you created it only for this lab).

## References

- [Amazon S3 Event Notifications (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventNotifications.html)
- [Walkthrough: Configuring a bucket for notifications (AWS docs)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ways-to-add-notification-config-to-bucket.html)
