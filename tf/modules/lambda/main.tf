
resource "aws_lambda_function" "examplefunc" {
  role             = aws_iam_role.examplerole.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = "${path.module}/lambda.zip"
  function_name    = var.function_name
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")
  environment {
    variables = {
      userpool_id  = var.userpool_id
      appclient_id = var.appclient_id
    }
  }
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

resource "aws_iam_role_policy_attachment" "examplepolicyattachment" {
  role       = aws_iam_role.examplerole.name
  policy_arn = aws_iam_policy.examplerolepolicy.arn
}

