variable "existing_key_name" {
  description = "Name of existing EC2 Key Pair"
  type        = string
}
variable "security_group_id" {
  description = "ID of existing security group"
  type        = string
}
variable "subnet_id" {
  description = "ID of the subnet where EC2 will be launched"
  type        = string
}
