data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [module.default_vpc.id]
  }
}

module "default_vpc" {
    source = "../"
}

output "subnet_ids" {
   value = data.aws_subnets.default.ids
}