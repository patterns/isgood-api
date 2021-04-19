
output "baseURL" {
  value = module.apigateway.base_url
}

output "userPoolID" {
  value = module.cognito.user_pool_id
}

output "userPoolClientID" {
  value = module.cognito.user_pool_client_id
}

output "tester" {
  value = local.tester.Username
}

