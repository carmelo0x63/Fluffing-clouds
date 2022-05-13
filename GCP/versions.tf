terraform {
  required_version = ">= 1.1.9"

  required_providers {
    google = {
      source = "hashicorp/google"
    }
    random = {
      source = "hashicorp/random"
    }
  }

}

