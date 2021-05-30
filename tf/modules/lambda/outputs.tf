

output "invoke_arn" {
  value = aws_lambda_function.examplefunc.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.examplefunc.function_name
}

