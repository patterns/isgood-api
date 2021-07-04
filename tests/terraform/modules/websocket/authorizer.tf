

resource "aws_apigatewayv2_route" "connect" {
  api_id             = aws_apigatewayv2_api.websocket.id
  route_key          = "$connect"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.webapp_api_key_authorizer.id

  target = "integrations/${aws_apigatewayv2_integration.examplewsconnectint.id}"
}

resource "aws_apigatewayv2_integration" "examplewsconnectint" {
  api_id                    = aws_apigatewayv2_api.websocket.id
  integration_type          = "AWS_PROXY"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.examplewslambda.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
  content_handling_strategy = "CONVERT_TO_TEXT"
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/webapp-api-key-authorizer.py"
  output_path = "${path.module}/webapp-api-key-authorizer.zip"
}

resource "aws_apigatewayv2_authorizer" "webapp_api_key_authorizer" {
  api_id           = aws_apigatewayv2_api.websocket.id
  authorizer_type  = "REQUEST"
  authorizer_uri   = aws_lambda_function.webapp_api_key_authorizer_lambda.invoke_arn
####  identity_sources = ["route.request.header.x-api-key"]
  name             = "webapp-api-key-authorizer"
}

resource "aws_lambda_function" "webapp_api_key_authorizer_lambda" {
  function_name    = "webapp-api-key-authorizer"
  handler          = "webapp-api-key-authorizer.handler"
  role             = aws_iam_role.webapp_api_key_authorizer_role.arn
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  memory_size      = "256"
  runtime          = var.runtime

  environment {
    variables = {
      WEBAPP_API_KEY = var.webapp_api_key
    }
  }
}

resource "aws_lambda_permission" "webapp_api_key_authorizer_lambda_perm" {
  statement_id  = "AllowAPIGatewayAuthorizer"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.webapp_api_key_authorizer_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.websocket.execution_arn}/*/*"
}

resource "aws_iam_role" "webapp_api_key_authorizer_role" {
  name        = "webapp-api-key-authorizer-role"
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

resource "aws_iam_role_policy_attachment" "webapp_api_key_authorizer_rolepolicy" {
  role       = aws_iam_role.webapp_api_key_authorizer_role.name
  policy_arn = aws_iam_policy.examplewspolicy.arn
}

resource "aws_iam_role_policy_attachment" "webapp_api_key_authorizer_basicpolicy" {
  role       = aws_iam_role.webapp_api_key_authorizer_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

