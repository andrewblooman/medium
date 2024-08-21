resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-unique-bucket-name"
  tags = {
    Name        = "MyS3Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms_encryption_config" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.log_key.id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.website_bucket.id
  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "log" {
  bucket        = aws_s3_bucket.website_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "logs/" # Optional: Define a prefix for log files
}


resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.log_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
        }
      }
    ]
  })
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

resource "aws_s3_bucket" "log_bucket" {
  bucket = "log-bucket-unique-name"
  tags = {
    Name        = "LoggingBucket"
    Environment = "Dev"
  }
}