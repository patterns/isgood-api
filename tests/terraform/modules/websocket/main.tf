resource "aws_apigatewayv2_api" "websocket" {
  name                       = "websocket"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_route" "disconnect" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.examplewsdiscoint.id}"
}

resource "aws_apigatewayv2_route" "sendmessage" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "sendmessage"
  target    = "integrations/${aws_apigatewayv2_integration.examplewssendint.id}"
}

resource "aws_apigatewayv2_integration" "examplewsdiscoint" {
  api_id                    = aws_apigatewayv2_api.websocket.id
  integration_type          = "AWS_PROXY"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.examplewslambda.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
  content_handling_strategy = "CONVERT_TO_TEXT"
}
resource "aws_apigatewayv2_integration" "examplewssendint" {
  api_id                    = aws_apigatewayv2_api.websocket.id
  integration_type          = "AWS_PROXY"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.examplewslambda.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
  content_handling_strategy = "CONVERT_TO_TEXT"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id        = aws_apigatewayv2_api.websocket.id
  name          = var.environment
  deployment_id = aws_apigatewayv2_deployment.examplewsdeploy.id
}

resource "aws_apigatewayv2_deployment" "examplewsdeploy" {
  api_id = aws_apigatewayv2_api.websocket.id

  depends_on = [
    aws_apigatewayv2_route.connect,
    aws_apigatewayv2_route.disconnect,
    aws_apigatewayv2_route.sendmessage,
  ]

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    deployed_at = "Deployed at ${timestamp()}"
  }
}
