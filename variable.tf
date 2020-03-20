locals {
  availability_zones = length(var.availability_zones) > 1 ? data.aws_availability_zones.input : data.aws_availability_zones.available
  
}

variable "project_name" {
  type = string
}

variable "workspace" {
  description = "Terraform workspace or development environment/stage"
  type = string
}

variable "nat_eip" {
  type = list(string)
  default = []
}

variable "availability_zones" {
	description = "availability_zone"
  type = list
  default = []
}

variable "vpc_cidr" {
  description = "Each vpc_cidr by workspace"
  type = string
}

variable "subnet_network_bit" {
  description = "Network bits for each subnet"
  type = number
}

variable "public_subnets" {
  type = list(number)
  # default = []
}
variable "private_subnets" {
  description = "Private subnet lists other than the basic subnets"
  type = map(object({
    string = list(number)
    string = list(number)   
  }))
  # default = []
}

variable "single_nat_gateway" {
  default = false
}

variable "tags" {
  type = map
}

variable "vpc_use" {
  default = true
}
