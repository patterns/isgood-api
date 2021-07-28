output "base_url" {
  value = module.rest.base_url
}

output "demo_api_key" {
  value     = module.rest.demo_api_key
  sensitive = true
}

