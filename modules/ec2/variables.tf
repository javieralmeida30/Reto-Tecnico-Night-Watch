variable "ami_id" {
  type        = string
  description = "AMI ID to use for EC2 instances"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "Name of the EC2 key pair"
}

variable "public_subnet_id" {
  type        = string
}

variable "private_subnet_id" {
  type        = string
}

variable "public_sg_id" {
  type        = string
}

variable "private_sg_id" {
  type        = string
}
