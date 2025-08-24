###############################################################################
# IRSA: rol IAM para el ServiceAccount del ALB Controller
# Usa el módulo terraform-aws-modules/iam/aws
###############################################################################
module "alb_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.39"

  role_name          = join("-", [local.name_prefix, "alb-controller-irsa"])
  policy_name_prefix = "${local.name_prefix}-"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    this = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

###############################################################################
# ServiceAccount anotado con el role ARN (IRSA)
###############################################################################
resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.alb_irsa.iam_role_arn
    }
    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
  }
  automount_service_account_token = true
}

###############################################################################
# IRSA: rol IAM para ExternalDNS
###############################################################################
module "externaldns_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.39"

  role_name          = join("-", [local.name_prefix, "externaldns-irsa"])
  policy_name_prefix = "${local.name_prefix}-"

  attach_external_dns_policy = true

  external_dns_hosted_zone_arns = [
    "arn:aws:route53:::hostedzone/${var.route53_zone_id}"
  ]

  oidc_providers = {
    this = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}

resource "kubernetes_service_account" "externaldns_sa" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.externaldns_irsa.iam_role_arn
    }
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }
  automount_service_account_token = true
}
