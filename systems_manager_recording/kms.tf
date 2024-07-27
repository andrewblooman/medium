# Creates KMS Key

resource "aws_kms_key" "log_key" {
  description         = "KMS key for S3 log bucket"
  enable_key_rotation = true
  policy              = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ExamplePolicy01",
    "Statement": [
        {
            "Sid": "AllowUseOfTheKey",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "${var.organization_id}"
                }
            }
        },
        {
            "Sid": "EnableIAMUserPermissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "AllowCloudWatchLogsUseOfTheKey",
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${var.region}.amazonaws.com"
            },
            "Action": [
                "kms:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

# Creates KMS Key Alias
resource "aws_kms_alias" "log_key" {
  name          = "alias/logging_key"
  target_key_id = aws_kms_key.log_key.id
}