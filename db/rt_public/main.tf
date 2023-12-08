variable "name" {}
variable "vpc_id" {}
variable "igw_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable destination_cidr_block {
  type = string
}

resource "aws_route_table" "default" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}

resource "aws_route" "default" {
  route_table_id = aws_route_table.default.id
  gateway_id = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "default" {
  for_each = { for idx, val in var.subnet_ids : idx => val }
  subnet_id = each.value
  route_table_id = aws_route_table.default.id
}