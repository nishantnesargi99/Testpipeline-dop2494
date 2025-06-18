provider "aws" {
  region = "us-east-2"
}
# Get the default VPC
data "aws_vpc" "default" {
  default = true
}
# Filter a single subnet from default VPC in us-east-2a
data "aws_subnet" "default_az2a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-2a"]
  }
}
# Use the default security group of that VPC
data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "group-name"
    values = ["default"]
  }
}
# EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = "ami-019eeff96c2865995"
  instance_type          = "t3.micro"
  key_name               = var.existing_key_name
  subnet_id              = data.aws_subnet.default_az2a.id
  vpc_security_group_ids = [data.aws_security_group.default.id]
  tags = {
    Name = "AppServerFromJenkins"
  }
}
output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
