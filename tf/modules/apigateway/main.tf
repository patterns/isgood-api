
resource "aws_api_gateway_rest_api" "exampleapi" {
  name        = "exampleapi"
  description = "Example API"
  endpoint_configuration {
    types = [
    "REGIONAL"]
  }

  body = templatefile("${path.module}/swagger.json", {
    echoUri     = "${var.echo_uri}"
    lambdaUri   = "${var.example_lambda_arn}"
    userPoolArn = "${var.user_pool_arn}"
  })
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    aws_api_gateway_rest_api.exampleapi,
  ]

  rest_api_id = aws_api_gateway_rest_api.exampleapi.id
  stage_name  = "${var.stage_name}"
}

resource "aws_lambda_permission" "exampleperm" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.example_lambda_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.exampleapi.execution_arn}/*/*"
}

