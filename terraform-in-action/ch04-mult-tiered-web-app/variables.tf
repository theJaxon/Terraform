variable "namespace" {
  type        = string
  description = "Project namespace for unique resource naming"
}

variable "ssh_keypair" {
  type        = string
  description = "SSH Keypair for use with EC2"
  default     = null # null is used for optional variables that don't have meaningful default values
}

variable "region" {
  type    = string
  default = "us-west-2"
}