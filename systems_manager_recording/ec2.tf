# Launch EC2 instance
resource "aws_instance" "ssm_recording_example" {
  ami                  = "ami-046d5130831576bbb" # Replace with a valid AMI ID
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_instance_profile.name
  tags = {
    Name        = "Session Manager Demo"
    Environment = "Development"
    Owner       = "Medium Article"
  }
  # Add other instance configuration parameters as needed
}