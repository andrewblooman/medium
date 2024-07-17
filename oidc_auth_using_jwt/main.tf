resource "aws_iam_openid_connect_provider" "gitlab" {
  url = "https://gitlab.com"
  client_id_list = [
    "https://gitlab.com"
  ]
  thumbprint_list = ["2B8F1B57330DBBA2D07A6C51F70EE90DDAB9AD8E"]
}

resource "aws_iam_role" "gitlab_cicd_oidc" {
  assume_role_policy = <<EOF
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

  name = "gitlab_cicd_oidc"
  managed_policy_arns = [
    "POLICY_ARN"
  ]
}

