
variable "indicationsfqdn" {
  description = "FQDN target of HTTP endpoint integration"
  default     = "https://docs.isgood.ai/"
}

output "baseURL" {
  value = aws_api_gateway_deployment.example.invoke_url
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_api_gateway_rest_api" "exampleapi" {
  name        = "exampleapi"
  description = "Example API"
  endpoint_configuration {
    types = [
    "REGIONAL"]
  }

  body = templatefile("swagger.json", {
    indicationsfqdn = "${var.indicationsfqdn}"
    indicationsuri  = "${aws_lambda_function.examplefunc.invoke_arn}"
  })
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    aws_api_gateway_rest_api.exampleapi,
  ]

  rest_api_id = aws_api_gateway_rest_api.exampleapi.id
  stage_name  = "test"
}

resource "aws_lambda_permission" "exampleperm" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.examplefunc.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.exampleapi.execution_arn}/*/*"
}

