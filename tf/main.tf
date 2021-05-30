

module "cognito" {
  source = "./modules/cognito"
}

module "lambda" {
  source       = "./modules/lambda"
  userpool_id  = module.cognito.user_pool_id
  userpool_arn = module.cognito.user_pool_arn
  appclient_id = module.cognito.user_pool_client_id
}

module "apigateway" {
  source              = "./modules/apigateway"
  echo_uri            = var.indicationsfqdn
  foxtrot_uri         = "${var.indicationsfqdn}/foxtrot"
  user_pool_arn       = module.cognito.user_pool_arn
  example_lambda_arn  = module.lambda.invoke_arn
  example_lambda_name = module.lambda.function_name
}

