variable "aws_region" {
  description = "Closest region"
  type        = string
  default     = "eu-south-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "aws_az" {
  description = "AWS AZ"
  type        = string
  default     = "eu-south-1c"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.1.64.0/18"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  type        = string
  default     = "10.1.64.0/24"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "ssh_port" {
  description = "Standard port for SSH"
  type        = number
  default     = 22
}

variable "public_key" {
  default = "~/.ssh/aws-static-webserver.pub"
}

variable "private_key" {
  default = "~/.ssh/aws-static-webserver"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI - updated 20240906"
  type        = string
  default     = "ami-08abf76f1e23f10c2"
}
