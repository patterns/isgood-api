
resource "aws_lambda_function" "event_invoke_final_lambda" {
  function_name    = "event-invoke-final"
  handler          = "event-invoke-final.handler"
  role             = aws_iam_role.event_invoke_final_role.arn
  filename         = data.archive_file.event_invoke_final_zip.output_path
  source_code_hash = data.archive_file.event_invoke_final_zip.output_base64sha256
  runtime          = var.runtime

  environment {
    variables = {
      CLIENT_ID     = var.client_id
      CLIENT_SECRET = var.client_secret
      WEBAPP_HOST   = var.webapp_host
      WEBAPP_PATH   = var.webapp_path
    }
  }
}

resource "aws_iam_role" "event_invoke_final_role" {
  name        = "event-invoke-final-role"
  path        = "/"
  description = "This role trusts lambda.amazonaws.com."

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

resource "aws_iam_role_policy_attachment" "event_invoke_final_basicpolicy" {
  # Enable Cloudwatch logs for this role
  role       = aws_iam_role.event_invoke_final_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "event_invoke_final_zip" {
  type        = "zip"
  source_file = "${path.module}/functions/event-invoke-final.py"
  output_path = "${path.module}/event-invoke-final.zip"
}

