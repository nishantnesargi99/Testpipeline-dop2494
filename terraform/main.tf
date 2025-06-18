provider "aws" {
  region = "us-east-2"
}
# Get default VPC
data "aws_vpc" "default" {
  default = true
}
# Get a default subnet in that VPC
data "aws_subnet" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
resource "aws_instance" "app_server" {
  ami                    = "ami-019eeff96c2865995"
  instance_type          = "t3.micro"
  key_name               = var.existing_key_name
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = "AppServerFromJenkins"
  }
}
output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
