resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(
    var.tags,
    {
      Name = join("-", compact([
        lookup(var.tags, "Platform", null),
        lookup(var.tags, "Environment", null),
        "main-vpc"
      ]))
    }
  )
}
