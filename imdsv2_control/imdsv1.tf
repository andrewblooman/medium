# Creates EC2 instance with IMDSv1
resource "aws_instance" "imdsv1_example" {
  ami                     = data.aws_ami.amazon_linux_2023.id
  instance_type           = "t3.micro"
  iam_instance_profile    = aws_iam_instance_profile.ec2_ssm_instance_profile.name
  subnet_id               = data.aws_subnet.subnet.id
  vpc_security_group_ids  = ["${aws_security_group.inbound_ssh.id}"]
  disable_api_termination = true
  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }
  tags = {
    Name        = "imdsv1_example"
    Environment = "Development"
    Owner       = "Medium Article"
  }
}