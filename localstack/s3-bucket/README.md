### s3-bucket 
- Create a text file locally named `localstack.txt`
- Upload the file to localstack S3
- File can be retrieved with [awslocal CLI](https://github.com/localstack/awscli-local) 

```bash
# List Files in the bucket 
awslocal s3 ls localstack-bucket --recursive --human-readable --summarize

# Retrieve file from S3
awslocal s3 cp s3://localstack-bucket/localstack.txt /tmp/localstack.txt
```