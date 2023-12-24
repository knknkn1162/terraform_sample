variable "service_names" {
  type = set(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
}

variable "security_group_ids" {
  type = list(string)
}


resource "aws_vpc_endpoint" "default" {
  for_each = var.service_names
  vpc_id       = var.vpc_id
  service_name = each.value
  vpc_endpoint_type = "Interface"
  security_group_ids = var.security_group_ids
  subnet_ids        = var.subnet_ids
  private_dns_enabled = true
  tags = {
    Name = "vpc_endpoint_${each.value}"
  }
}