resource "aws_internet_gateway" "vpc_ig" {
  count   = var.vpc_use ? 1 : 0
  vpc_id  = aws_vpc.vpc[0].id
  tags = merge(
      var.tags,
      map(
        "Name", format("%s-%s-ig", var.project_name, var.workspace)
      )
  )

}