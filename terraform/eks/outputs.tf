#region EKS outputs
output "eks_name" {
  value = module.eks.cluster_name
}

output "eks_connect" {
  value = "aws eks --region us-east-1 update-kubeconfig --name ${module.eks.cluster_name}"
}
#endregion

#region VPC outputs 
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
#endregion

#region ACM
output "acm_certificate_arn" {
  value = module.acm.certificate_id
}
#endregion

#region SA
output "irsa_aws_alb_service_account_name" {
  value = kubernetes_service_account.alb_sa.metadata[0].name
}

output "irsa_aws_alb_service_account_arn" {
  value = kubernetes_service_account.alb_sa.metadata[0].annotations["eks.amazonaws.com/role-arn"]
}

output "irsa_aws_externaldns_service_account_name" {
  value = kubernetes_service_account.externaldns_sa.metadata[0].name
}

output "irsa_aws_externaldns_service_account_arn" {
  value = kubernetes_service_account.externaldns_sa.metadata[0].annotations["eks.amazonaws.com/role-arn"]
}
#endregion