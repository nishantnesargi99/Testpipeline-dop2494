provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "app_server" {
  ami                         = "ami-019eeff96c2865995"
  instance_type               = "t4g.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]  # Use existing SG
  key_name                    = var.existing_key_name
  user_data = <<-EOF
              #!/bin/bash
              sed -i 's/^#Port 22/Port 9211/' /etc/ssh/sshd_config
              sed -i 's/^Port 22/Port 9211/' /etc/ssh/sshd_config
              systemctl restart sshd
              EOF
  tags = {
    Name = "AppServerFromJenkins"
  }
}
# :white_check_mark: Add SSH port 9211 to existing security group
resource "aws_security_group_rule" "allow_ssh_9211" {
  type              = "ingress"
  from_port         = 9211
  to_port           = 9211
  protocol          = "tcp"
  security_group_id = var.security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow SSH on custom port 9211"
}
# (Optional) Add HTTP rule if needed
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = var.security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP"
}
output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
