resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn         = aws_iam_role.vpc_flow_log_role.arn
  log_destination      = aws_cloudwatch_log_group.vpc_logs_group.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = data.aws_vpc.main.id
  tags = {
    Name = "VPC Flow Log"
  }
}