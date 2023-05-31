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

variable "domainName" {
  default = "www.carmelo0x99.it"
  type    = string
}

variable "bucketName" {
  default = "www.carmelo0x99.it"
  type    = string
}
