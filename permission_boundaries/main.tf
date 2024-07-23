resource "aws_iam_role" "developer_power_user" {
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.account_id}:oidc-provider/${var.oidc_provider}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringLike": {
          "gitlab.com:sub": "project_path:${var.gitlab_project}/*:ref_type:branch:ref:*"
        }
      }
    }
  ]
}
EOF
  permissions_boundary = aws_iam_policy.developers_permissions_boundary.arn
  name                 = "developer_power_user"
  managed_policy_arns  = ["${aws_iam_policy.developers_permissions_policy.arn}"]
}

resource "aws_iam_policy" "developers_permissions_policy" {
  name        = "DevelopersPermissionsPolicy"
  description = "Permissions Policy for developer roles"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "NotAction" : [
          "organizations:*",
          "account:*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:CreateServiceLinkedRole",
          "iam:DeleteServiceLinkedRole",
          "iam:ListRoles",
          "organizations:DescribeOrganization",
          "account:ListRegions",
          "account:GetAccountInformation"
        ],
        "Resource" : "*"
      }
    ]
    }
  )
}

resource "aws_iam_policy" "developers_permissions_boundary" {
  name        = "DevelopersPermissionsBoundary"
  description = "Permissions boundary for developer roles"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "DenyIAMUsersAndKeys",
        "Effect" : "Deny",
        "Action" : [
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:CreateUser",
          "iam:CreateAccessKey"
        ],
        "Resource" : "arn:aws:iam::${var.account_id}:policy/DevelopersPermissionsBoundary"
      },
      {
        "Sid" : "AllowRoleCreationWithAttachedPermissionsBoundary",
        "Effect" : "Allow",
        "Action" : "iam:CreateRole",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:PermissionsBoundary" : "arn:aws:iam::${var.account_id}:policy/DevelopersPermissionsBoundary"
          }
        }
      },
      {
        "Sid" : "DenyPermissionsBoundaryDeletion",
        "Effect" : "Deny",
        "Action" : "iam:DeleteRolePermissionsBoundary",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:PermissionsBoundary" : "arn:aws:iam::${var.account_id}:policy/DevelopersPermissionsBoundary"
          }
        }
      },
      {
        "Sid" : "DenyPolicyChange",
        "Effect" : "Deny",
        "Action" : [
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:DetachRolePolicy",
          "iam:SetDefaultPolicyVersion"
        ],
        "Resource" : "arn:aws:iam::${var.account_id}:policy/DevelopersPermissionsBoundary"
      }
    ]
  })
}