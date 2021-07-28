
variable "echo_uri" {
  description = "FQDN target to demonstrate integration to an external HTTP endpoint"
  default     = "https://www.isgood.ai/"
  type        = string
}

variable "stage_name" {}
variable "foxtrot_uri" {}
variable "rest_lambda_arn" {}
variable "rest_lambda_name" {}
variable "event_invoke_arn" {}
variable "event_invoke_name" {}

