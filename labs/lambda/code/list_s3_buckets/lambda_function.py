import json
import boto3
from botocore.exceptions import ClientError

# Initialize the client outside the handler to reuse connection across invocations
s3_client = boto3.client("s3")

def lambda_handler(event, context):
    try:
        response = s3_client.list_buckets()
        bucket_names = [bucket["Name"] for bucket in response.get("Buckets", [])]

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": f"Successfully retrieved {len(bucket_names)} bucket(s).",
                "buckets": bucket_names
            })
        }
    except ClientError as err:
        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": err.response["Error"]["Message"]
            })
        }
