provider "aws" {
  region = "eu-west-1"
}

data "aws_vpc" "common-tooling-vpc" {
  id = "vpc-03bf0cefd39d0e5fb"
}

resource "aws_subnet" "k8s-subnet-1" {
  vpc_id = data.aws_vpc.common-tooling-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "eu-west-1a"

  tags = {
    Name = "k8s-subnet-1"
  } 
}