resource "aws_vpc" "vpc" {
  count                 = var.vpc_use ? 1 : 0
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true
  enable_dns_support    = true
  instance_tenancy      = "default"
  tags = merge(
    var.tags,
    map(
      "Name", format("%s-%s-vpc", var.project_name, var.workspace)
    )
  )
}