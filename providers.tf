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
provider "aws" {
  region  = data.terraform_remote_state.eks.outputs.aws_region
  profile = "tf-user"
}

data "aws_eks_cluster" "this" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   command     = "aws"
  #   args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.this.name]
  # }
}