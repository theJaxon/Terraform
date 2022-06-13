terraform {
  required_version = "~> 1.2"
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "3.4.0"
    }

    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "local_file" "private_key_file" {
    content  = tls_private_key.private_key.private_key_pem
    filename = "${path.module}/tls-private-key.pem"
}

