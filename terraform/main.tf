provider "aws" {
  region = "us-east-2"
}
# Get the default VPC
data "aws_vpc" "default" {
  default = true
}
# Get all subnet IDs from the default VPC
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
# Get all subnet details (one for each ID)
data "aws_subnet" "selected" {
  for_each = toset(data.aws_subnet_ids.default.ids)
  id       = each.value
}
# Filter subnet IDs by specific AZ: us-east-2a
locals {
  selected_subnet_id = [
    for s in data.aws_subnet.selected :
    s.id if s.availability_zone == "us-east-2a"
  ][0]
}
# Use the default security group of the VPC
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
# Create the EC2 instance
resource "aws_instance" "app_server" {
  ami                    = "ami-019eeff96c2865995"
  instance_type          = "t3.micro"
  key_name               = var.existing_key_name
  subnet_id              = local.selected_subnet_id
  vpc_security_group_ids = [data.aws_security_group.default.id]
  tags = {
    Name = "AppServerFromJenkins"
  }
}
# Output public IP of the EC2 instance
output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
