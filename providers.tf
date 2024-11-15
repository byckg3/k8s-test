data "terraform_remote_state" "eks" {
  backend = "remote"

  config = {
    organization = "tf-team"
    workspaces = {
      name = "eks-dev-ap-northeast"
    }
  }
}

# Retrieve EKS cluster information
locals {
  aws_region            = data.terraform_remote_state.eks.outputs.aws_region
  eks_cluster_name      = data.terraform_remote_state.eks.outputs.eks_cluster_name
  eks_oidc_provider_arn = data.terraform_remote_state.eks.outputs.eks_oidc_provider_arn
}

data "aws_eks_cluster" "this" {
  name = local.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = local.eks_cluster_name
}

locals {
  cluster_endpoint = data.aws_eks_cluster.this.endpoint
  ca_certificate   = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  auth_token       = data.aws_eks_cluster_auth.this.token
}

provider "aws" {
  region  = local.aws_region
  profile = "tf-user"
}

provider "kubernetes" {
  host                   = local.cluster_endpoint
  cluster_ca_certificate = local.ca_certificate
  token                  = local.auth_token
  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   command     = "aws"
  #   args        = ["eks", "get-token", "--cluster-name", data.eks_cluster.this.name]
  # }
}

provider "helm" {
  kubernetes {
    host                   = local.cluster_endpoint
    cluster_ca_certificate = local.ca_certificate
    token                  = local.auth_token
  }
}