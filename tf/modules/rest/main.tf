
resource "aws_api_gateway_rest_api" "rest" {
  name        = "rest"
  description = "REST API"
  endpoint_configuration {
    types = [
    "REGIONAL"]
  }

  body = templatefile("${path.module}/oas3.json", {
    echo_uri         = var.echo_uri
    foxtrot_uri      = var.foxtrot_uri
    lambda_uri       = var.rest_lambda_arn
    event_invoke_uri = var.event_invoke_arn
  })
}

resource "aws_api_gateway_deployment" "rest_deploy" {
  depends_on = [
    aws_api_gateway_rest_api.rest,
  ]

  rest_api_id = aws_api_gateway_rest_api.rest.id
  stage_name  = var.stage_name
}

resource "aws_lambda_permission" "rest_perm" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.rest_lambda_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.rest.execution_arn}/*/*"
}
resource "aws_lambda_permission" "rest_event_invoke_perm" {
  statement_id  = "AllowAPIGatewayEventInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.event_invoke_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.rest.execution_arn}/*/*"
}

