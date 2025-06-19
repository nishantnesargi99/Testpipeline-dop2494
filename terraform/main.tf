provider "aws" {
  region = "us-east-2"
}
# :mag: Get VPC ID from the provided subnet_id
data "aws_subnet" "selected" {
  id = var.subnet_id
}
# :white_check_mark: Create a new SG using that VPC ID
resource "aws_security_group" "jenkins_app_sg" {
  name        = "jenkins-app-sg"
  description = "Security group for Jenkins EC2 with SSH on 9211"
  vpc_id      = data.aws_subnet.selected.vpc_id
  ingress {
    description = "Allow SSH on port 9211"
    from_port   = 9211
    to_port     = 9211
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "jenkins-app-sg"
  }
}
# :white_check_mark: EC2 Instance
resource "aws_instance" "app_server" {
  ami                         = "ami-019eeff96c2865995"
  instance_type               = "t4g.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.jenkins_app_sg.id]
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
# :white_check_mark: Output for Jenkins
output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
