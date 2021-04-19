terraform {
  required_version = ">= 0.12"
}

variable "indicationsfqdn" {
  description = "URL of echo test service"
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

data "external" "testuser" {
  program = ["python3", "${path.module}/external/create-testuser.py"]

  query = {
    user-pool-id = module.cognito.user_pool_id
  }
}

locals {
  tester = data.external.testuser.result

}


