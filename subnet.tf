resource "aws_subnet" "public" {
  count             = var.vpc_use ? length(var.public_subnets) : 0
  vpc_id            = aws_vpc.vpc[0].id
  availability_zone = var.availability_zones.*.name[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_network_bit, var.public_subnets[count.index])
  map_public_ip_on_launch = true
  tags = merge(
      var.tags,
      map(
        "Name", format("%s-%s-public2%s-sn", var.project_name, var.workspace, var.availability_zones.*.name_suffix[count.index])
      )
  )
}


resource "aws_subnet" "privates" {
  count             = var.vpc_use ? length(var.availability_zones.*.name) * length(var.private_subnets) : 0
  vpc_id            = aws_vpc.vpc[0].id
  availability_zone = var.availability_zones.*.name[count.index % length(var.availability_zones.*.name)]
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_network_bit, values(var.private_subnets)[floor(count.index / length(var.availability_zones.*.name))][count.index % length(var.availability_zones.*.name)])
  tags = merge(
      var.tags,
      map(
        "Name", format("%s-%s-%spriv2%s-sn", var.project_name, var.workspace, keys(var.private_subnets)[floor(count.index / length(var.availability_zones.*.name))], var.availability_zones.*.name_suffix[count.index % length(var.availability_zones.*.name)])
      )
  ) 
}
