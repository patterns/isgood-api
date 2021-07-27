variable "echo_fqdn" {
  description = "URL of echo test service"
}

variable "stage_name" {
  description = "API Gateway stage name and appears in base_url"
  default     = "test"
}

variable "client_id" {}
variable "client_secret" {}
variable "webapp_endpoint" {}

