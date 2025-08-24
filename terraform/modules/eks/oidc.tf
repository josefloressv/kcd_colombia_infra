# OIDC provider para el cluster EKS
resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  # El ALB controller usa STS como audience
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"] # Thumbprint típico para el issuer OIDC de EKS, para todos los EKSs
}