```bash
# Plan and apply lambda
tflocal plan && tflocal apply -auto-approve

# List Lambda functions
awslocal lambda list-functions

{
    "Functions": [
        {
            "FunctionName": "hello-world-function",
            "FunctionArn": "arn:aws:lambda:us-east-1:000000000000:function:hello-world-function",
            "Runtime": "nodejs12.x",
            "Role": "arn:aws:iam::000000000000:role/terraform-20230316182407137200000002",
            "Handler": "main.handler",
            "CodeSize": 270,
            "Description": "",
            "Timeout": 3,
            "MemorySize": 128,
            "LastModified": "2023-03-16T18:24:08.535+0000",
            "CodeSha256": "8Bd96JMxT7EWhoIrQ8oNhVKBAF32691kdJAcXBYvKCA=",
            "Version": "$LATEST",
            "VpcConfig": {},
            "TracingConfig": {
                "Mode": "PassThrough"
            },
            "RevisionId": "21bd781c-4597-4aa5-9263-83ae80ec5aeb",
            "State": "Active",
            "LastUpdateStatus": "Successful",
            "PackageType": "Zip",
            "Architectures": [
                "x86_64"
            ]
        }
    ]
}

# Invoke hello-world-function
awslocal lambda invoke --function-name hello-world-function output.txt

# Display lambda output 
cat output.txt 

{"body":"Hello world!","headers":{"Content-Type":"text/html"},"statusCode":200}
```

---

### Lambda logging via CloudWatch
- By default lambda uses cloudwatch to store its logs
- Lambda needs permissions to create the necessary log resources

#### CloudWatch Logs Layers
##### Log Group
- Per function
- `/aws/lambda/<function name>` # Log Group name

##### Log Streams
- Per instance, the contain log entries

##### Log entries
- Log content

#### CLoudWatch Logs Permissions
```bash
# Log Group
"logs:CreateLogGroup"

# Log Stream
"logs:CreateLogStream"

# Log Entry
"logs:PutLogEvents"
```

```hcl
data "aws_iam_policy_document" "lambda_exec_role_policy" {
    statement {
        actions = [
            "logs:CreateLogGroup"
            "logs:CreateLogStream"
            "logs:PutLogEvents"
        ]

        resources = [
            "arn:aws:logs:*:*:*"
        ]
    }
}
```

---

### Lambda Managed Log Group
- Requires "logs:CreateLogGroup" permission
- Logs never expire
- Log groups are never deleted

### Terraform Managed Log Group
- Requires `aws_cloudwatch_log_group` resource
- Remove ~~"logs:CreateLogGroup"~~ Permission
- Allows more control over logs (how long should logs be retained)

```hcl
resource "aws_cloudwatch_log_group" "log_group" {
    name = "/aws/lambda/${aws_lamda_function.lambda.function_name}
    retention_in_days = 14
}
```

---

### Passing ENV Vars to Lambda Functions
```hcl
resource "aws_s3_bucket" "bucket" {
    force_destroy = true
}

resource "aws_lambda_function" "lambda" {
    function_name = "hello-function"
    filename = data.archive_file.lambda_zip.output_path
    handler = "main.handler"
    runtime = "nodejs12.x"
    role    = aws_iam_role.lambda_exec_role.arn
    environment {
        variables = {
            BUCKET = aws_s3_bucket.bucket.bucket
        }
    }
}
```

- In code it can be accessed via `process.env.BUCKET`