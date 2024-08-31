resource "aws_cloudwatch_log_group" "vpc_logs_group" {
  name              = "vpc_flow_logs"
  kms_key_id        = aws_kms_key.log_key.arn
  retention_in_days = 30
  tags = {
    Environment = "Sandbox"
  }
}