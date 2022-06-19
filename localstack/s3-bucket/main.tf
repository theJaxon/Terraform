resource "local_file" "s3_sample_file" {
  content  = "localstack Rocks!"
  filename = "${path.module}/localstack.txt"
}

resource "aws_s3_bucket" "localstack_bucket" {
  bucket = "localstack-bucket"
}

resource "aws_s3_bucket_acl" "localstack_bucket_acl" {
  bucket = aws_s3_bucket.localstack_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "localstack_file_upload" {
  bucket = aws_s3_bucket.localstack_bucket.id
  key    = "localstack.txt"
  source = "${path.module}/localstack.txt"
}
