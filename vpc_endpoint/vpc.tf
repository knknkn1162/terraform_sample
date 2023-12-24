variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
resource "aws_vpc" "example" {
  cidr_block       = var.vpc_cidr_block
  #instance_tenancy = "default"
  enable_dns_support = true
  # for VPC endpoint
  enable_dns_hostnames = true
  tags = {
    Name = "example"
  }
}