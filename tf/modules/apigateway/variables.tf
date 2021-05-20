
variable "echo_uri" {
  description = "FQDN target of HTTP endpoint integration"
  default     = "https://www.isgood.ai/"
  type        = string
}

variable "user_pool_arn" { type = string }
variable "example_lambda_arn" { type = string }
variable "example_lambda_name" { type = string }

