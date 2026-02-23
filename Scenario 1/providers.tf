terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = aws_eks_cluster.cea_eks_cluster.name
}

provider "kubernetes" {
  host = aws_eks_cluster.cea_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cea_eks_cluster.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.eks_cluster.token
}