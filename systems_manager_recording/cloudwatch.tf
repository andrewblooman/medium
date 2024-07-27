resource "aws_cloudwatch_log_group" "session_manager_logs_group" {
  name              = "session_manager_logs"
  kms_key_id        = aws_kms_key.log_key.arn
  log_group_class   = "STANDARD"
  retention_in_days = 30
  tags = {
    Environment = "Sandbox"
  }
}