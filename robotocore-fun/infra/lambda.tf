resource "aws_lambda_function" "my_function" {
  filename      = "${path.module}/../lambda/function.zip"
  function_name = "my-function"
  role          = "arn:aws:iam::123456789012:role/lambda-execution-role"
  handler       = "index.handler"
  runtime       = "python3.12"
}
