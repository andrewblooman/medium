resource "aws_s3_bucket" "log_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_encryption" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.log_key.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetEncryptionConfiguration",
            "Resource": "${aws_s3_bucket.log_bucket.arn}",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "${var.organization_id}"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "${aws_s3_bucket.log_bucket.arn}/*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "${var.organization_id}"
                }
            }
        }
    ]
}
POLICY
}