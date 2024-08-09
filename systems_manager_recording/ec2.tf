# Creates EC2 instance
resource "aws_instance" "ssm_recording_example" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_instance_profile.name
  subnet_id              = data.aws_subnet.subnet.id
  vpc_security_group_ids = ["${aws_security_group.session_manager_security_group.id}"]
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # This enforces the use of IMDSv2
    http_put_response_hop_limit = 1
  }
  tags = {
    Name        = "Session Manager Demo"
    Environment = "Development"
    Owner       = "Medium Article"
  }
}

# Creates Security Group
resource "aws_security_group" "session_manager_security_group" {
  name        = "Session Manager Security Group"
  description = "Session Manager Security Group"
  vpc_id      = data.aws_vpc.main.id
  tags = {
    Name : "Session Manager Security Group"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creates EC2 IAM Policy
resource "aws_iam_policy" "session_manager_recording_policy" {
  name        = "SSM-SessionManager-S3-KMS-Logging"
  description = "Policy for SSM Session Manager logging to S3 with KMS encryption"
  policy      = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PutObjectsBucket",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.log_bucket.arn}/*"
    },
    {
      "Sid": "ListBucketAndEncryptionConfig",
      "Action": [
        "s3:GetEncryptionConfiguration"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.log_bucket.arn}"
    },
    {
      "Sid": "S3KMSSessionManagerKMS",
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:GenerateDataKey*"
      ],
      "Resource": [
        "${aws_kms_key.log_key.arn}"
      ]
    },
        {
            "Sid": "cloudwatch",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        }
  ]
}
EOF
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
  managed_policy_arns = ["${aws_iam_policy.session_manager_recording_policy.arn}", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

# Creates instance profile
resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "ec2_ssm_instance_profile"
  role = aws_iam_role.ec2_ssm_role.name
}
