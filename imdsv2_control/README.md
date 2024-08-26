# Project Summary
Demonstrates how to fix the Server Side Request Forgery Vulnerabilty in Instance Metadata Service Version 1.

# How to Use
As per my article, use the following process to exploit IMDSv1 on the EC2 instance.

- Run the following command to see the name of the role (if any) attached to the EC2 instance
'curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/'

- We can store the output as an environment variable, in this case role_name
'role_name=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/)'

- Finally, we can run a command to retrieve the credentials
'curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/$role_name'

# Notes
Ensure to update the variables to those for your AWS account.