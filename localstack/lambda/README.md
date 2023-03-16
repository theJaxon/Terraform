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