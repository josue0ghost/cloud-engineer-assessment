
# EKS Auto Mode
resource "aws_eks_cluster" "cea_eks_cluster" {
  name = "cea-eks-cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.31"

  bootstrap_self_managed_addons = false

  compute_config {
    enabled       = true
    node_pools    = ["general-purpose"]
    node_role_arn = aws_iam_role.node.arn
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = [ 
      aws_subnet.private_subnet_az1.id,
      aws_subnet.private_subnet_az2.id 
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSComputePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSBlockStoragePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSLoadBalancingPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSNetworkingPolicy,
  ]
}

# Extract OIDC issuer URL and format it for IAM Role trust relationship
locals {
  oidc_issuer_url = aws_eks_cluster.cea_eks_cluster.identity[0].oidc[0].issuer
}

# Retrieve the IAM OIDC provider details 
data "aws_iam_openid_connect_provider" "oidc" {
  url = local.oidc_issuer_url
}

# Kubernetes Service Account for IRSA
resource "kubernetes_service_account_v1" "irsa_sa" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_role.arn
    }
  }
}
