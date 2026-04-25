terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.31.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.0"
    } 
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }   
  }
}

provider "aws" {
  # Configuration options
}

## AWS Provider Data Sources Region
data "aws_region" "current" {}


## AWS Provider Data Sources Account ID
data "aws_caller_identity" "current" {}

## -----------------------------------------------

## AWS Provider Data Sources EKS Cluster
data "aws_eks_cluster" "default" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}
data "aws_eks_cluster_auth" "default" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}
## -----------------------------------------------

## AWS Provider Data Sources for helm provider
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
}