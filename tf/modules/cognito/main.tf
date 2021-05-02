
resource "aws_cognito_user_pool" "pool" {
  name = local.lbluspool

  auto_verified_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }
}

resource "aws_cognito_user_pool_client" "pool_client" {
  user_pool_id           = aws_cognito_user_pool.pool.id
  name                   = local.lbluspoolc
  generate_secret        = false
  refresh_token_validity = 30
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
  ]

  read_attributes  = ["email"]
  write_attributes = ["email"]

  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_identity_pool" "apps_identity_pool" {
  identity_pool_name               = local.lblidpool
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.pool_client.id
    provider_name           = aws_cognito_user_pool.pool.endpoint
    server_side_token_check = false
  }

  depends_on = [aws_cognito_user_pool.pool]
}

resource "aws_iam_role" "apps_identity_pool_authenticated" {
  name = local.lblidpoolauth

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.apps_identity_pool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "apps_identity_pool_authenticated" {
  name = local.lblidpoolauthp
  role = aws_iam_role.apps_identity_pool_authenticated.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "cognito-identity:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

# finally, we can attach our roles to our identity pools
resource "aws_cognito_identity_pool_roles_attachment" "apps_identity_pool_role_attachment" {
  identity_pool_id = aws_cognito_identity_pool.apps_identity_pool.id
  roles = {
    "authenticated" = aws_iam_role.apps_identity_pool_authenticated.arn
  }
}


