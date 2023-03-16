data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "${path.module}/code/main.js"
    output_path = "${path.module}/code/main.js.zip"
}

# Lambda Assume Role
resource "aws_iam_role" "lambda_exec_role" {
  assume_role_policy = file("${path.module}/role/lambda_exec_role.json")
}

# Lambda Role Policy
resource "aws_iam_policy" "lambda_exec_role_policy" {
    policy = file("${path.module}/policy/lambda_exec_role_policy.json")
}

resource "aws_iam_role_policy" "lambda_exec_role_policy" {
  role   = aws_iam_role.lambda_exec_role.id
  policy = aws_iam_policy.lambda_exec_role_policy.policy
}

resource "aws_lambda_function" "lambda" {
    function_name = "hello-world-function"
    filename = data.archive_file.lambda_zip.output_path
    handler = "main.handler"
    runtime = "nodejs12.x"
    role    = aws_iam_role.lambda_exec_role.arn

}