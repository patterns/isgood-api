
data "aws_iam_policy_document" "exampledynamopolicydoc" {
  statement {
    actions = [
      "execute-api:Invoke",
      "execute-api:ManageConnections",
    ]
    resources = ["${aws_apigatewayv2_api.examplewsapi.execution_arn}/*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
    ]
    resources = [var.table_arn]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "examplewspolicy" {
  name   = "examplewspolicy"
  policy = data.aws_iam_policy_document.exampledynamopolicydoc.json
}

