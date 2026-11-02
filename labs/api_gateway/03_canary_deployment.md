# API Gateway Lab: Canary Deployment on a Stage

[← Labs index](../README.md) · **Service:** API Gateway · **Level:** Intermediate · **Est. time:** 20 min · **Est. cost:** Free tier

**Reference:** [Udemy DVA-C01 - API Gateway Canary Deployment Hands On](https://www.udemy.com/course/aws-certified-developer-associate-dva-c01/learn/lecture/19731564#overview)

## Contents

- [Objectives](#objectives)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [References](#references)

## Objectives

- Add a method that calls **Lambda version 1** and deploy it to a new stage `canary`.
- Turn on **canary settings** for the stage and send **50%** of the requests to the canary.
- Deploy a change (the method now calls **version 2**) to the **canary only**, then promote or roll it back.

## Prerequisites

- [Lab 02 - Stages, Stage Variables and Lambda Aliases](02_stages_and_stage_variables.md): the API
    `DVA_DemoAPIGatewayStages` and the function `DVA_DemoAPIGatewayStages` with versions `1` and `2`.
- Theory: [Canary deployment in the Serverless mind map](../../mind_maps/markdown/ServerlessArchitecture.md).

## Steps

### 1. Add a Method that Calls Version 1

1. Open the API `DVA_DemoAPIGatewayStages` > **Resources** > **Create resource**, **Resource name** `canary-demo`.
2. On `/canary-demo` click **Create method**: **Method type** `GET`, **Integration type** Lambda function,
    turn on **Lambda proxy integration**, and enter the ARN of **version 1**:

    ```text
    arn:aws:lambda:REGION:ACCOUNT_ID:function:DVA_DemoAPIGatewayStages:1
    ```

3. Click **Create method**. The ARN points to one version (no stage variable), so the console adds the
    invoke permission for `:1` itself.

### 2. Deploy a New Stage

1. **Deploy API** > **New stage**, **Stage name** `canary` > **Deploy**.
2. Open `https://API_ID.execute-api.REGION.amazonaws.com/canary/canary-demo`: it returns `"Hello from Lambda version 1!"`.

### 3. Turn on the Canary for the Stage

1. **Stages** > `canary` > **Canary** tab > **Create canary**.
2. **Requests directed to canary:** `50` (50/50 makes the split easy to see; in real life start small, e.g. 5–10%).
    Click **Create**.

    ![Canary settings of the canary stage: 50% to the canary, 50% to the stage, no stage variable overrides](../shared_assets/api_gateway/03_canary-settings.png)

> 💡 **Stage variables** has a **Canary override** column: the canary can use other values than the base
> (e.g. a different `lambdaAlias`) without a separate stage.

### 4. Point the Method at Version 2 and Deploy to the Canary

1. **Resources** > `/canary-demo` > `GET` > **Integration request** > **Edit**.
2. Change the Lambda function to **version 2** and click **Save** (the console adds the permission for `:2`):

    ```text
    arn:aws:lambda:REGION:ACCOUNT_ID:function:DVA_DemoAPIGatewayStages:2
    ```

3. **Deploy API** > **Stage** `canary` > **Deploy**. Because the stage has a canary, this deployment goes to the
    **canary** only; the base deployment still serves version 1.

### 5. Watch the Split, Then Promote or Roll Back

1. Reload `/canary/canary-demo` several times: about half of the answers are `version 1!`, the other half `version 2!`.
2. If version 2 looks healthy, open the stage's **Canary** tab > **Promote canary**: the canary deployment
    becomes the base and gets 100% of the traffic.
3. To roll back instead, **Delete** the canary: all traffic returns to the base deployment (version 1).

## Verification

- With the canary at 50%, repeated calls return both messages (step 5).
- After **Promote canary**, every call returns `"Hello from Lambda version 2!"`.
- CLI alternative: set the two values first. The API ID is the first part of the invoke URL
    (`https://abc123defg.execute-api.ap-northeast-1.amazonaws.com/...` → `abc123defg`).

    ```bash
    API_ID=<your-api-id>
    REGION=<your-region>   # e.g. ap-northeast-1

    for i in $(seq 1 10); do
      curl -s "https://$API_ID.execute-api.$REGION.amazonaws.com/canary/canary-demo"; echo
    done
    aws apigateway get-stage --rest-api-id "$API_ID" --stage-name canary \
      --region "$REGION" --query canarySettings
    ```

    Expected: a mix of `"Hello from Lambda version 1!"` and `"Hello from Lambda version 2!"` (about half
    each, e.g. 6/4 over 10 calls), and `canarySettings` with `"percentTraffic": 50.0`.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Every call still returns version 1 | The change was saved but not deployed, or deployed before the canary existed | Create the canary first, then **Deploy API** to the `canary` stage |
| Every call returns version 2 right away | The canary was promoted, or the stage had no canary when you deployed | Check the **Canary** tab; recreate it and redeploy |
| 500 `Internal server error` from one side of the split | No invoke permission for that version | Re-select the function in the integration request so the console adds it, or run `aws lambda add-permission` for `:1` / `:2` |
| `{"message":"Missing Authentication Token"}` | Wrong path | Call `/canary/canary-demo` (stage, then resource) |
| `zsh: no matches found: arn:aws:execute-api:...` | An ARN was passed to `--rest-api-id`, and zsh expands its unquoted `*` as a file pattern | `--rest-api-id` takes only the API ID (e.g. `abc123defg`); quote any value that contains `*` |
| `You must specify a region` | No default Region in the local AWS CLI profile | Add `--region "$REGION"`, or run the commands in CloudShell |

## Cleanup

> 💸 Deployed stages stay public on the Internet until you delete them.

- [ ] Delete the `canary` stage (or the whole API `DVA_DemoAPIGatewayStages` if you are done with Lab 02 too).
- [ ] Delete the function `DVA_DemoAPIGatewayStages`, its log group and its execution role when you no longer need them.

## References

- [Set up an API Gateway canary release deployment (AWS docs)](https://docs.aws.amazon.com/apigateway/latest/developerguide/canary-release.html)
- [Promote a canary release (AWS docs)](https://docs.aws.amazon.com/apigateway/latest/developerguide/promote-canary-deployment.html)
