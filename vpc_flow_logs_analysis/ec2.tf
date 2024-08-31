resource "aws_instance" "flow_logs_example" {
  ami                     = data.aws_ami.amazon_linux_2023.id
  instance_type           = "t3.micro"
  iam_instance_profile    = aws_iam_instance_profile.ec2_ssm_instance_profile.name
  subnet_id               = data.aws_subnet.subnet.id
  vpc_security_group_ids  = ["${aws_security_group.security_group.id}"]
  disable_api_termination = true
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # This enforces the use of IMDSv2
    http_put_response_hop_limit = 1
  }
  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }
  tags = {
    Name        = "VPC Flow Logs Example"
    Environment = "Development"
    Owner       = "Medium Article"
  }
}

# Creates Security Group
resource "aws_security_group" "security_group" {
  name        = "Security Group"
  description = "Security Group"
  vpc_id      = data.aws_vpc.main.id
  tags = {
    Name : "Security Group"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creates IAM role
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2_ssm_role"

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
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

# Creates instance profile
resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "ec2_ssm_instance_profile"
  role = aws_iam_role.ec2_ssm_role.name
}
