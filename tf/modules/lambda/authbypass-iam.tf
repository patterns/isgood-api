

data "aws_iam_policy_document" "authbypasspolicy" {
  statement {
    actions = [
      "cognito-idp:ListUserPools",
      "cognito-idp:ListUsers",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "cognito-idp:AdminAddUserToGroup",
      "cognito-idp:AdminConfirmSignUp",
      "cognito-idp:AdminCreateUser",
      "cognito-idp:AdminDeleteUser",
      "cognito-idp:AdminDeleteUserAttributes",
      "cognito-idp:AdminDisableProviderForUser",
      "cognito-idp:AdminDisableUser",
      "cognito-idp:AdminEnableUser",
      "cognito-idp:AdminForgetDevice",
      "cognito-idp:AdminGetDevice",
      "cognito-idp:AdminGetUser",
      "cognito-idp:AdminInitiateAuth",
      "cognito-idp:AdminLinkProviderForUser",
      "cognito-idp:AdminListDevices",
      "cognito-idp:AdminListGroupsForUser",
      "cognito-idp:AdminListUserAuthEvents",
      "cognito-idp:AdminRemoveUserFromGroup",
      "cognito-idp:AdminResetUserPassword",
      "cognito-idp:AdminRespondToAuthChallenge",
      "cognito-idp:AdminSetUserMFAPreference",
      "cognito-idp:AdminSetUserSettings",
      "cognito-idp:AdminUpdateAuthEventFeedback",
      "cognito-idp:AdminUpdateDeviceStatus",
      "cognito-idp:AdminUpdateUserAttributes",
      "cognito-idp:AdminUserGlobalSignOut",
    ]

    resources = [
      var.userpool_arn,
    ]
  }
}

resource "aws_iam_policy" "examplerolepolicy" {
  name   = "examplerolepolicy"
  policy = data.aws_iam_policy_document.authbypasspolicy.json
}

