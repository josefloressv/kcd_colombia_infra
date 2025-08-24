resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = join("-", compact([
        lookup(var.tags, "Platform", null),
        lookup(var.tags, "Environment", null),
        "public-subnet",
        count.index
      ]))
  # Tags for AWS Load Balancer Controller / auto-discovery
  "kubernetes.io/role/elb" = "1"
      # If you later use private subnets for internal load balancers, tag them with kubernetes.io/role/internal-elb = 1
    }
    , var.cluster_name != "" ? { "kubernetes.io/cluster/${var.cluster_name}" = "shared" } : {}
  )
}