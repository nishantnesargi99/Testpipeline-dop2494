provider "aws" {
  region = "us-east-2" 
}
# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}
# Fetch one of the default subnets in that VPC (you can fetch all if needed)
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
data "aws_subnet" "default" {
  id = tolist(data.aws_subnet_ids.default.ids)[0] 
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
