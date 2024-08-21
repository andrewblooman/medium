resource "aws_kms_alias" "log_key_alias" {
  name          = "alias/logging_key"
  target_key_id = aws_kms_key.log_key.id
}

resource "aws_kms_key" "log_key" {
  description = "KMS key for S3 bucket encryption"
  enable_key_rotation = true
  rotation_period_in_days = 90
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.aws_account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow S3 Use of the Key",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${var.aws_account_id}",
          "kms:ViaService": "s3.${var.aws_region}.amazonaws.com"
        }
      }
    }
  ]
}
EOF
  tags = {
    Name = "s3-bucket-kms-key"
  }
}

resource "aws_kms_alias" "s3_bucket_key_alias" {
  name          = "alias/s3-bucket-kms-key"
  target_key_id = aws_kms_key.log_key.id
}