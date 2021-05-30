
variable "userpool_id" {}
variable "appclient_id" {}
variable "userpool_arn" {}

variable "function_name" {
  default = "minimal_lambda_function"
}

variable "handler" {
  default = "lambda.handler"
}

variable "runtime" {
  default = "python3.7"
}

