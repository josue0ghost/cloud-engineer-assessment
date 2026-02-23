# Scenario 1

# OIDC Provider ARN
output "oidc_provider_arn" {
  value = data.aws_iam_openid_connect_provider.oidc.arn
}
# OIDC Provider URL
output "oidc_provider_url" {
  value = local.oidc_issuer_url
}
# IAM Role ARN for IRSA
output "irsa_role_arn" {
  value = aws_iam_role.irsa_role.arn
}
# Kubernetes Service Account Name for IRSA
output "kubernetes_service_account_name" {
  value = kubernetes_service_account_v1.irsa_sa.metadata[0].name
}