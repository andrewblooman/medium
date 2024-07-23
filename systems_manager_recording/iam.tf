data "aws_iam_policy_document" "session_manager_recording_policy_document" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "${aws_s3_bucket.log_bucket.arn}/*"
    ]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      aws_kms_key.log_key.arn
    ]
  }
}

resource "aws_iam_policy" "session_manager_recording_policy" {
  name        = "SSM-SessionManager-S3-KMS-Logging"
  description = "Policy for SSM Session Manager logging to S3 with KMS encryption"
  policy      = data.aws_iam_policy_document.session_manager_recording_policy_document.json
}

# Create IAM role
resource "aws_iam_role" "ec2_ssm_role" {
  name = "eec2_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = ["${aws_iam_policy.session_manager_recording_policy.arn}"]
}


# Create IAM instance profile
resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "ec2_ssm_instance_profile"
  role = aws_iam_role.ec2_ssm_role.name
}

