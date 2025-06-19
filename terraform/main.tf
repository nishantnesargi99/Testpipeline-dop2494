provider "aws" {
  region = "us-east-2"
}
# Create a security group that allows port 9211 for SSH
resource "aws_security_group" "app_sg" {
  name        = "jenkins-app-sg"
  description = "Allow custom SSH on port 9211"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow SSH on port 9211"
    from_port   = 9211
    to_port     = 9211
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Launch the EC2 instance
resource "aws_instance" "app_server" {
  ami                    = "ami-019eeff96c2865995"
  instance_type          = "t4g.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.existing_key_name
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
# Output the instance public IP
output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
