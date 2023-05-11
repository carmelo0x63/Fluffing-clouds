// Configure the provider: AWS
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 6
}

resource "aws_key_pair" "ssh-keypair" {
  key_name   = "aws-static-webserver"
  public_key = file(var.public_key)
}

