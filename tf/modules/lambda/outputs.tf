

output "invoke_arn" {
  value = aws_lambda_function.rest_route_lambda.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.rest_route_lambda.function_name
}

output "event_invoke_arn" {
  value = aws_lambda_function.event_invoke_lambda.invoke_arn
}

output "event_invoke_name" {
  value = aws_lambda_function.event_invoke_lambda.function_name
}

