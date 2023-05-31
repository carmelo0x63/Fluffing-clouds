terraform {
  required_version = ">= 1.4"

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.66"
    }
  }
}

