resource "aws_cloudtrail" "cloudtrail" {
  depends_on                    = [aws_s3_bucket_policy.cloudtrail_s3_policy]
  name                          = "cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  s3_key_prefix                 = "logs"
  include_global_service_events = true # recommended unless you have a reason to disable
  is_multi_region_trail         = false
  enable_log_file_validation    = true
}