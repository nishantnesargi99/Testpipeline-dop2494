variable "subnet_id" {
  description = "ID of the existing Subnet where the EC2 instance will be launched"
  type        = string
}
variable "security_group_id" {
  description = "ID of the existing Security Group to associate with the EC2 instance"
  type        = string
}
variable "existing_key_name" {
  description = "Name of the existing EC2 Key Pair to use for SSH access"
  type        = string
}
