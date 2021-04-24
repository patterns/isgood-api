



variable "function_name" {
  default = "minimal_lambda_function"
}

variable "handler" {
  default = "lambda.handler"
}

variable "runtime" {
  default = "python3.7"
}

resource "aws_lambda_function" "examplefunc" {
  role             = aws_iam_role.examplerole.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = "lambda.zip"
  function_name    = var.function_name
  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_iam_role" "examplerole" {
  name        = "examplerole"
  path        = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

