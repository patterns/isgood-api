
resource "aws_lambda_function" "event_invoke_lambda" {
  function_name    = "event-invoke"
  handler          = "event-invoke.handler"
  role             = aws_iam_role.event_invoke_role.arn
  filename         = data.archive_file.event_invoke_zip.output_path
  source_code_hash = data.archive_file.event_invoke_zip.output_base64sha256
  runtime          = var.runtime
}


resource "aws_iam_role" "event_invoke_role" {
  name        = "event-invoke-role"
  path        = "/"
  description = "."

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

resource "aws_iam_role_policy_attachment" "event_invoke_basicpolicy" {
  role       = aws_iam_role.event_invoke_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "event_invoke_policy" {
  role       = aws_iam_role.event_invoke_role.name
  policy_arn = aws_iam_policy.event_invoke_policy.arn
}

data "archive_file" "event_invoke_zip" {
  type        = "zip"
  source_file = "${path.module}/functions/event-invoke.py"
  output_path = "${path.module}/event-invoke.zip"
}

data "aws_iam_policy_document" "event_invoke_policy_doc" {
  # Give its role permission to run any (step) function
  # todo instead of wildcard, limit to known function
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "event_invoke_policy" {
  name   = "event-invoke-policy"
  policy = data.aws_iam_policy_document.event_invoke_policy_doc.json
}

