terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.31.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}