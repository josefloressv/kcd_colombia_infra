# Helm release de ArgoCD
resource "helm_release" "argocd" {
  depends_on = [module.eks]
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version

  namespace        = "argocd"
  create_namespace = true
  set = [
    {
      name  = "server.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
    }
  ]
}

# Helm release del AWS Load Balancer Controller
# https://github.com/aws/eks-charts
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.8.1"
  set = [
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = kubernetes_service_account.alb_sa.metadata[0].name
    },
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = module.vpc.vpc_id
    }
    # ,{
    #   name  = "defaultIngressClass.enabled"
    #   value = "true"
    # }
  ]

  depends_on = [kubernetes_service_account.alb_sa]
}

###############################################################################
# Helm release ExternalDNS
# Docs: https://github.com/kubernetes-sigs/external-dns
###############################################################################
resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = "1.15.0" # ajustar si se requiere

  depends_on = [module.eks, kubernetes_service_account.externaldns_sa]
  set = [
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = kubernetes_service_account.externaldns_sa.metadata[0].name
    },
    {
      name  = "provider"
      value = "aws"
    },
    {
      name  = "policy"
      value = "upsert-only"
    },
    {
      name  = "domainFilters[0]"
      value = var.domain_name
    },
    {
      name  = "registry"
      value = "txt"
    },
    {
      name  = "txtOwnerId"
      value = local.name_prefix
    },
    {
      name  = "interval"
      value = "1m"
    },
    {
      name  = "logLevel"
      value = "info"
    },
    {
      name  = "triggerLoopOnEvent"
      value = "true"
    }
  ]
}