
resource "aws_iam_group" "cognito_app_group" {
  name = "${var.name}_group"
}

resource "aws_iam_user" "cognito_app_user" {
  name = "${var.name}_user"
}

# note:
# we don't also create an 'aws_iam_access_key' resource
# because we don't want the access key to be committed
# 
# so we manually create access/secret keys via the console

resource "aws_iam_user_group_membership" "cognito_app_user_groups" {
  user = "${aws_iam_user.cognito_app_user.name}"

  groups = [
    "${aws_iam_group.cognito_app_group.name}",
  ]
}

data "aws_iam_policy_document" "cognito_app_group_policy" {
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
      "${aws_cognito_user_pool.pool.arn}",
    ]
  }
}

resource "aws_iam_policy" "cognito_app_group_policy" {
  name   = "${var.name}_group_policy"
  policy = "${data.aws_iam_policy_document.cognito_app_group_policy.json}"
}

resource "aws_iam_group_policy_attachment" "cognito_app_group_attachment" {
  group      = "${aws_iam_group.cognito_app_group.name}"
  policy_arn = "${aws_iam_policy.cognito_app_group_policy.arn}"
}
