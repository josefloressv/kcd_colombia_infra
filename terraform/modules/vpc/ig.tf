resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = join("-", compact([
        lookup(var.tags, "Platform", null),
        lookup(var.tags, "Environment", null),
        "main-ig"
      ]))
    }
  )
}
