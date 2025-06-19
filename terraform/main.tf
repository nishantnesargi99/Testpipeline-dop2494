provider "aws" {
  region = "us-east-2"
}
# :white_check_mark: Look up the subnet (optional, can be useful for consistency)
data "aws_subnet" "selected" {
  id = var.subnet_id
}
# :white_check_mark: EC2 Instance using existing SG and default SSH port 22
resource "aws_instance" "app_server" {
  ami                         = "ami-019eeff96c2865995"
  instance_type               = "t4g.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.existing_key_name
  tags = {
    Name = "AppServerFromJenkins"
  }
}
# :white_check_mark: Output: Public IP of the EC2 instance
output "instance_ip" {
  description = "Public IP of the deployed EC2 instance"
  value       = aws_instance.app_server.public_ip
}
# :white_check_mark: Optional: Output SSH command for Jenkins logs/debugging
output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${var.existing_key_name}.pem ubuntu@${aws_instance.app_server.public_ip}"
}






