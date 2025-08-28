application        = "webapp-color"
vpc_cidr           = "10.99.0.0/16"
kubernetes_version = "1.33"
instance_types     = ["t3.medium"]
node_scaling_config = {
  min_size     = 2
  desired_size = 2
  max_size     = 3
}

# ArgoCD
argocd_chart_version = "8.3.0"

# ACM
domain_name               = "eks.gitops.club"
subject_alternative_names = ["preview.eks.gitops.club"]

# Route53 Zone
route53_zone_id = "Z00971581ZTIB608MSIO0"