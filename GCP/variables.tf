variable "gcp_region" {
  description = "Closest region"
  default     = "europe-west8-a"
  type        = string
}

variable "gcp_username" {
  description = "GCP user name"
  default     = "carmelo_califano"
  type        = string
}

variable "gcp_private_key" {
  description = "SSH private key"
  default     = "~/.ssh/gcp-static-webserver"
  type        = string
}

variable "gcp_project" {
  description = "Project Name"
  default     = "cloudchallenge-349217"
  type        = string
}

