# Output the instance ID
output "imdvsv1_instance_id" {
  value = aws_instance.imdsv1_example.id
}

# Output the instance ID
output "imdvsv2_instance_id" {
  value = aws_instance.imdsv1_example.id
}

output "ami_id" {
  value = data.aws_ami.amazon_linux_2023.id
}