resource "aws_kms_key" "log_key" {
  description         = "KMS key for CloudWatch log group"
  enable_key_rotation = true
  policy              = <<POLICY
  {
  "Sid": "Allow CloudWatch Logs to use the key",
  "Effect": "Allow",
  "Principal": {
    "Service": "logs.${var.region}.amazonaws.com"
  },
  "Action": [
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:ReEncrypt*",
    "kms:GenerateDataKey*"
  ],
  "Resource": "*"
}
POLICY
}

resource "aws_kms_alias" "log_key" {
  name          = "alias/logging_key"
  target_key_id = aws_kms_key.log_key.id
}