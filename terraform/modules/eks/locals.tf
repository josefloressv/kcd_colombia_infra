locals {
  policies    = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
  name_prefix = join("-", compact([
    lookup(var.tags, "Platform", null),
    lookup(var.tags, "Environment", null),
    var.name_suffix != "" ? var.name_suffix : null
  ]))
}
