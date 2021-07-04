

output "baseURL" {
  value       = module.websocket.base_url
  description = "Endpoint for websocket service (needs stage appended for full path)."
}



