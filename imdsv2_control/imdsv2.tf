# Creates EC2 instance with IMDSv2
resource "aws_instance" "imdsv2_example" {
  ami                     = data.aws_ami.amazon_linux_2023.id
  instance_type           = "t3.micro"
  iam_instance_profile    = aws_iam_instance_profile.ec2_ssm_instance_profile.name
  subnet_id               = data.aws_subnet.subnet.id
  vpc_security_group_ids  = ["${aws_security_group.inbound_ssh.id}"]
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
    Name        = "imdsv2_example"
    Environment = "Development"
    Owner       = "Medium Article"
  }
}