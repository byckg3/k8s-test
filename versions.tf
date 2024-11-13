terraform {
  cloud {
    organization = "tf-team"
    workspaces {
      name = "k8s-dev-ap-northeast"
    }
  }
  required_version = "~> 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.4"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}