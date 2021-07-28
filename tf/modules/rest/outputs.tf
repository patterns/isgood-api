
output "base_url" {
  value = aws_api_gateway_deployment.rest_deploy.invoke_url
}

output "demo_api_key" {
  value     = aws_api_gateway_api_key.demo_api_key.value
  sensitive = true
}

