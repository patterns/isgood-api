terraform {
  required_version = "~> 0.14"
  backend "remote" {
    organization = "savewhales"
    workspaces {
      name = "gh-actions-demo"
    }
  }
}

variable "indicationsfqdn" {
  description = "URL of echo test service"
  default     = "https://www.isgood.ai/"
}

module "cognito" {
  source = "./modules/cognito"
}

module "apigateway" {
  source              = "./modules/apigateway"
  echo_uri            = var.indicationsfqdn
  user_pool_arn       = module.cognito.user_pool_arn
  example_lambda_arn  = aws_lambda_function.examplefunc.invoke_arn
  example_lambda_name = aws_lambda_function.examplefunc.function_name
}

