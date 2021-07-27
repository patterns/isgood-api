
resource "aws_lambda_function" "rest_route_lambda" {
  function_name    = "rest-route"
  handler          = "rest-route.handler"
  role             = aws_iam_role.examplerole.arn
  filename         = data.archive_file.rest_route_zip.output_path
  source_code_hash = data.archive_file.rest_route_zip.output_base64sha256
  runtime          = var.runtime

}

resource "aws_iam_role" "examplerole" {
  name        = "examplerole"
  path        = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "archive_file" "rest_route_zip" {
  type        = "zip"
  source_file = "${path.module}/functions/rest-route.py"
  output_path = "${path.module}/rest-route.zip"
}

