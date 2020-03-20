
output "vpc" {
  value = "${aws_vpc.vpc[0]}"
}

output "public_subnets" {
  value = "${aws_subnet.public.*}"
}

output "private_subnets" {
  value = "${aws_subnet.privates.*}"
}

output "no_nat_private_subnets" {
  value = "${aws_subnet.no_nat_privates.*}"
}

output "public_rts" {
  value = "${aws_route_table.public.*}"
}

output "private_rts" {
  value = "${aws_route_table.privates.*}"
}
