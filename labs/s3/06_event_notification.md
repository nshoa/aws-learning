### S3 Event Notifications (SQS)

**Ref:** [Udemy DVA-C01](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/23743680#lecture-article)

---

### Lab Objectives

- [ ]  Create an SQS Queue to receive notifications.
- [ ]  Configure SQS Access Policy to allow S3 to send messages.
- [ ]  Set up an S3 Event Notification for object uploads.
- [ ]  Verify message delivery in the SQS console.

---

### 1. Create the SQS Queue

1. Go to the **SQS Console** and click **Create queue**.
2. **Type:** Standard.
3. **Name:** `s3-notification-queue`.
4. Leave other settings at default and click **Create queue**.
5. **Important:** Copy the **ARN** (Amazon Resource Name) of your queue.

---

### 2. Authorize S3 to Publish to SQS

By default, S3 does not have permission to write to your queue. You must add a resource-based policy.

1. In your SQS Queue, go to the **Access policy** tab and click **Edit**.
2. Add the following statement to your JSON policy (Replace placeholders with your values):

```json
{
  "Version": "2012-10-17",
  "Id": "example-ID",
  "Statement": [
    {
      "Sid": "AllowS3ToPublish",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "SQS:SendMessage",
      "Resource": "YOUR-SQS-QUEUE-ARN",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:s3:::YOUR-S3-BUCKET-NAME"
        }
      }
    }
  ]
}
```

---

### 3. Configure S3 Event Notification

1. Go to your **S3 Bucket** > **Properties** tab.
2. Scroll to **Event notifications** and click **Create event notification**.
3. **Event name:** `NewObjectUpload`.
4. **Event types:** Check `All object create events` (s3:ObjectCreated:*).
5. **Destination:** Select **SQS queue**.
6. **SQS queue:** Choose your queue from the dropdown (or enter the ARN).
7. Click **Save changes**.

---

### 4. Verification & Results
1. Upload a file to your S3 bucket.
2. Go back to the SQS Console > Select your queue.
3. Click Send and receive messages > Poll for messages.
4. You should see a message. Click it to inspect the JSON body.


---

### 🧹 Cleanup

- [ ]  Delete the S3 Event Notification.
- [ ]  Delete the SQS Queue.
- [ ]  Delete test objects from S3.