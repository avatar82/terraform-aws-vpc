resource "aws_route_table" "public" {
  count             = var.vpc_use ? 1 : 0
  vpc_id            = "${aws_vpc.vpc[0].id}"
  tags = "${merge(
      var.tags,
      map(
        "Name", format("%s-%s-public-rt", var.project_name, var.workspace)
      )
  )}"
}

resource "aws_route" "public" {
  count                   = var.vpc_use ? 1 : 0
  route_table_id          = "${aws_route_table.public[0].id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.vpc_ig[0].id}"
}

resource "aws_route_table_association" "public" {
  count             = var.vpc_use ? length(aws_subnet.public) : 0
  subnet_id         = "${aws_subnet.public.*.id[count.index]}"
  route_table_id    = "${aws_route_table.public[0].id}"
}


resource "aws_route_table" "privates" {
  count             = var.vpc_use ? local.nat_gateway_count == length(local.availability_zones) ? length(local.availability_zones) * (length(var.private_subnets)) : length(var.private_subnets) : 0
  vpc_id            = "${aws_vpc.vpc[0].id}"
  tags = "${merge(
      var.tags,
      map(
        "Name", format("%s-%s-%spriv2%s-rt", 
          var.project_name, 
          var.workspace, 
          var.single_nat_gateway ? 
            keys(var.private_subnets)[count.index % (length(var.private_subnets))], 
            keys(var.private_subnets)[floor(count.index / (length(local.availability_zones)))]:
          var.single_nat_gateway ? 
            local.availability_zones.*.name_suffix[floor(count.index / (length(var.private_subnets)))]
            local.availability_zones.*.name_suffix[count.index % (length(local.availability_zones))]:
        )
      )
  )}"
}

resource "aws_route" "privates" {
  count             = var.vpc_use ? local.nat_gateway_count !=0 ? length(aws_route_table.privates) : 0 : 0
  route_table_id          = "${aws_route_table.privates.*.id[count.index]}"
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id  = "${length(aws_nat_gateway.natgateway) != 1 ? aws_nat_gateway.natgateway.*.id[count.index % length(local.availability_zones)] : aws_nat_gateway.natgateway.*.id[0]}"
}

resource "aws_route_table_association" "privates" {
  count             = var.vpc_use ? length(aws_subnet.privates) : 0
  subnet_id         = "${aws_subnet.privates.*.id[count.index]}"
  route_table_id    = "${var.single_nat_gateway ? aws_route_table.privates.*.id[floor(count.index / length(local.availability_zones))] : aws_route_table.privates.*.id[count.index]}"
}