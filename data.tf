data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_availability_zone" "input" {
  count = length(var.availability_zone)
  name  = var.availability_zone[count.index]
}

data "aws_eip" "nat_eip" {
  count = length(var.nat_eip)
  public_ip  = var.nat_eip[count.index]
}