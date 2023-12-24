variable "service_names" {
  type = set(string)
}

variable "vpc_id" {
}

variable "route_table_ids" {
  type = list(string)
}


resource "aws_vpc_endpoint" "default" {
  for_each = var.service_names
  vpc_id       = var.vpc_id
  service_name = each.value
  vpc_endpoint_type = "Gateway"
  route_table_ids = var.route_table_ids 
  tags = {
    Name = "vpc_endpoint_${each.value}"
  }
}