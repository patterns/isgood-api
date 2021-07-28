
resource "aws_api_gateway_api_key" "demo_api_key" {
  name        = "demo_api_key"
  description = "temp API key during demo because AWS mgt console will be used in prod"

}

resource "aws_api_gateway_usage_plan" "demo_usage_plan" {
  name = "demo_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.rest.id
    stage  = aws_api_gateway_deployment.rest_deploy.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "demo_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.demo_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.demo_usage_plan.id
}

