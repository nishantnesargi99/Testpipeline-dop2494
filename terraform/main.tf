provider "aws" {
  region = "us-east-2"
}
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

output "instance_ip" {
  value = aws_instance.app_server.public_ip
}
