resource "aws_eip" "nat_eip" {
  count   = var.vpc_use && (length(var.nat_eip) != length(local.availability_zones)) ? var.single_nat_gateway ? 1 : length(local.availability_zones) : 0
  vpc     = true
  tags = merge(
      var.tags,
      map(
        "Name", format("%s-%s-ng2%s-eip", var.project_name, var.workspace, local.availability_zones.*.name_suffix[count.index])
      )
  )
}

resource "aws_nat_gateway" "natgateway" {
  count   = var.vpc_use ? var.single_nat_gateway ? 1: length(local.availability_zones) : 0
  allocation_id = length(var.nat_eip) == length(local.availability_zones) ? data.aws_eip.nat_eip.*.id[count.index] : aws_eip.nat_eip.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]
  tags = merge(
      var.tags,
      map(
        "Name", format("%s-%s2%s-ng", var.project_name, var.workspace, local.availability_zones.*.name_suffix[count.index])
      )
  )
}
