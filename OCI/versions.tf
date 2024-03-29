terraform {
  required_version = ">= 1.4"

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    oci = { 
      source  = "hashicorp/oci"
      version = ">= 4.75"
    }
    local = { 
      source = "hashicorp/local"
      version = ">= 2.4"
    }
  }
}

