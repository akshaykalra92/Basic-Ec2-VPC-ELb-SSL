terraform {
  required_providers {
    aws  = {
      source  = "hashicorp/aws"
      version = "4.20.1"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.5.3"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}