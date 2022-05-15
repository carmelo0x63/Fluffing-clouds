terraform {
  required_providers {
    null = {
      version = ">= 3.1.1"
    }
  }
}

resource "null_resource" "main" {
}

