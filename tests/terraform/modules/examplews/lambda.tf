
resource "aws_lambda_function" "examplewslambda" {
  function_name    = "examplewslambda"
  handler          = "lambda-function.handler"
  role             = aws_iam_role.examplewsrole.arn
  filename         = "${path.module}/examplews-lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/examplews-lambda.zip")
  memory_size      = "256"
  runtime          = var.runtime

  environment {
    variables = {
      table_name = var.table_name
    }
  }
}

resource "aws_lambda_permission" "examplewsperm" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.examplewslambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.examplewsapi.execution_arn}/*/*"
}

resource "aws_iam_role" "examplewsrole" {
  name        = "examplewsrole"
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

resource "aws_iam_role_policy_attachment" "examplewsrolepolicy" {
  role       = aws_iam_role.examplewsrole.name
  policy_arn = aws_iam_policy.examplewspolicy.arn
}

resource "aws_iam_role_policy_attachment" "examplewsbasicpolicy" {
  role       = aws_iam_role.examplewsrole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

