terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

     acme = {
      source  = "vancluever/acme"
      version = "~> 2.5.3"
    }
  }
}