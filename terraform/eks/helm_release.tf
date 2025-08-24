# Helm release de ArgoCD
resource "helm_release" "argocd" {
  depends_on = [module.eks]
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version

  namespace = "argocd"

  create_namespace = true

  set = [{
    name  = "server.service.type"
    value = "LoadBalancer"
    },
    {
      name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
  }]
}

# Helm release del AWS Load Balancer Controller
# https://github.com/aws/eks-charts
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.8.1"

  # Usamos el SA existente (IRSA)
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
    # (Opcional) Si usas IngressClass por defecto:
    # {
    #   name  = "defaultIngressClass.enabled"
    #   value = "true"
    # }
  ]

  depends_on = [
    kubernetes_service_account.alb_sa
  ]
}