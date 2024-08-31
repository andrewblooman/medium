# Project Summary
Demonstrates how to enable VPC flow logs for a VPC, deploying an EC2 instance to generate traffic. Logs are sent to Cloudwatch, encrypted using KMS.

# How to Use
Change the variables to match your environment, also update the data.tf file with the name of your VPC and subnet. To deploy, run the following commands
- terraform init
- terraform validate
- terraform plan
- terraform apply
