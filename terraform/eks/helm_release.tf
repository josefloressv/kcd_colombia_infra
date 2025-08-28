# # Helm release de ArgoCD
# resource "helm_release" "argocd" {
#   depends_on = [module.eks]
#   name       = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   version    = var.argocd_chart_version

#   namespace        = "argocd"
#   create_namespace = true
#   set = [
#     {
#       name  = "server.service.type"
#       value = "ClusterIP" # LoadBalancer
#     },
#     # {
#     #   name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
#     #   value = "nlb"
#     # },
#     # {
#     #   name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
#     #   value = "internet-facing"
#     # },
#     # {
#     #   name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type"
#     #   value = "ip"
#     # }
#   ]
# }