provider "aws" {
  region     = "us-east-2"  
}
resource "aws_instance" "app_server" {
  ami                    = "ami-019eeff96c2865995"  
  instance_type          = "t3.micro"
  key_name               = var.existing_key_name     # Use existing EC2 key pair
  subnet_id              = var.subnet_id             # Optional if you use default VPC
  vpc_security_group_ids = [var.security_group_id]   # Attach existing SG
  tags = {
    Name = "AppServerFromJenkins"
  }
  
}
output "instance_ip" {
  value = aws_instance.app_server.public_ip 
}
