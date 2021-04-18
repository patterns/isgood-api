
output "user_pool_id" {
  value = "${aws_cognito_user_pool.pool.id}"
}

output "user_pool_arn" {
  value = "${aws_cognito_user_pool.pool.arn}"
}

output "user_pool_client_id" {
  value = "${aws_cognito_user_pool_client.pool_client.id}"
}


output "app_user_name" {
  value = "${aws_iam_user.cognito_app_user.name}"
}

output "app_user_arn" {
  value = "${aws_iam_user.cognito_app_user.arn}"
}

