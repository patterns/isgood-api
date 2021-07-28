
resource "aws_lambda_function" "event_invoke_step_lambda" {
  function_name    = "event-invoke-step"
  handler          = "event-invoke-step.handler"
  role             = aws_iam_role.event_invoke_step_role.arn
  filename         = data.archive_file.event_invoke_step_zip.output_path
  source_code_hash = data.archive_file.event_invoke_step_zip.output_base64sha256
  runtime          = var.runtime
}


resource "aws_lambda_function_event_invoke_config" "event_invoke_step_config" {
  function_name = aws_lambda_function.event_invoke_step_lambda.function_name

  # Do not retry when error occurs (until we have re-entrant handling)
  maximum_retry_attempts = 0


  # Final step after subprocess ends
  destination_config {

    # Move forward when function is successful
    # by sending invocation record to destination child Lambda
    on_success {
      destination = aws_lambda_function.event_invoke_final_lambda.arn
    }
  }

}

resource "aws_iam_role" "event_invoke_step_role" {
  name        = "event-invoke-step-role"
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


resource "aws_iam_role_policy_attachment" "event_invoke_step_basicpolicy" {
  # Enable Cloudwatch logs for this role
  role       = aws_iam_role.event_invoke_step_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "event_invoke_step_zip" {
  type        = "zip"
  source_file = "${path.module}/functions/event-invoke-step.py"
  output_path = "${path.module}/event-invoke-step.zip"
}

resource "aws_iam_role_policy_attachment" "event_invoke_step_policy" {
  role       = aws_iam_role.event_invoke_step_role.name
  policy_arn = aws_iam_policy.event_invoke_step_policy.arn
}
data "aws_iam_policy_document" "event_invoke_step_policy_doc" {
  # Give its role permission to run any (final) function
  # todo instead of wildcard, limit to known function
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "event_invoke_step_policy" {
  name   = "event-invoke-step-policy"
  policy = data.aws_iam_policy_document.event_invoke_step_policy_doc.json
}


