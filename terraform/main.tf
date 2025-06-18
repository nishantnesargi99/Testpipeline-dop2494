provider "aws" {
  region = "us-east-2"  # Change if using a different region
}
# Get the default VPC
data "aws_vpc" "default" {
  default = true
}
# Get a subnet from the default VPC 
data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  # Optional: Limit to public subnets
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}
# Get the default security group of the default VPC
data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "group-name"
    values = ["default"]
  }
availability_zone = "us-east-2a"
}
# EC2 instance resource
resource "aws_instance" "app_server" {
  ami                    = "ami-019eeff96c2865995"  # Replace with valid AMI ID for your region
  instance_type          = "t3.micro"
  key_name               = var.existing_key_name
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [data.aws_security_group.default.id]
  tags = {
    Name = "AppServerFromJenkins"
  }
}
# Output public IP
output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
