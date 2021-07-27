


variable "client_id" {
  description = "client ID to send request to auth0"
}
variable "client_secret" {
  description = "client secret to send request to auth0"
}

variable "webapp_endpoint" {
  description = "known webapp exposes endpt to accept POST of result from DS/Brain process"
}

variable "runtime" {
  default = "python3.7"
}

