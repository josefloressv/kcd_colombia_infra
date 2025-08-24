provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks.endpoint
  token                  = data.aws_eks_cluster_auth.main.token
  cluster_ca_certificate = base64decode(module.eks.certificate_authority)
}

# Connect to the EKS cluster
provider "helm" {
  kubernetes = {
    host                   = module.eks.endpoint
    token                  = data.aws_eks_cluster_auth.main.token
    cluster_ca_certificate = base64decode(module.eks.certificate_authority)
  }
}
# provider "helm" {
#   kubernetes = {
#     host     = "https://cluster_endpoint:port"

#     client_certificate     = file("~/.kube/client-cert.pem")
#     client_key             = file("~/.kube/client-key.pem")
#     cluster_ca_certificate = file("~/.kube/cluster-ca-cert.pem")
#   }
# }
