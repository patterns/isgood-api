


module "lambda" {
  source        = "./modules/lambda"
  client_id     = var.client_id
  client_secret = var.client_secret
  webapp_host   = var.webapp_host
  webapp_path   = var.webapp_path
}

module "rest" {
  source            = "./modules/rest"
  echo_uri          = var.echo_fqdn
  foxtrot_uri       = "${var.echo_fqdn}/foxtrot"
  stage_name        = var.stage_name
  rest_lambda_arn   = module.lambda.invoke_arn
  rest_lambda_name  = module.lambda.function_name
  event_invoke_arn  = module.lambda.event_invoke_arn
  event_invoke_name = module.lambda.event_invoke_name
}

