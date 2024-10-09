variable "aws_region" {
  description = "Closest region"
  type        = string
  default     = "eu-central-1"
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
  default     = "eu-central-1c"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI - updated 20241009"
  type        = string
  default     = "ami-0592c673f0b1e7665"
}

variable "instance_type" {
  description = "AMI instance type"
  type        = string
  default     = "t3.large"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.10.10.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  type        = string
  default     = "10.10.10.0/24"
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

variable "ollama_port" {
  description = "Ollama API port"
  type        = number
  default     = 11434
}

variable "public_key" {
  default = "~/.ssh/ccalifan-swss-aws8-public.pem"
}

variable "private_key" {
  default = "~/.ssh/ccalifan-swss-aws8-private.pem"
}

