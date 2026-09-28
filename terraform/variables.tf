variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type (t2.micro = free tier eligible)"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair created in AWS"
  type        = string
  default     = "todolist-key"
}

variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
  default     = "todolist-app"
}

variable "allowed_ssh_ip" {
  description = "Your local public IP in CIDR form (e.g. 203.0.113.5/32)"
  type        = string
}