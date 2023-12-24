variable "vpc_id" {
}

variable "igw_id" {
}


data "aws_vpc" "example" {
  id = var.vpc_id
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_default_route_table" "private" {
  default_route_table_id = data.aws_vpc.example.main_route_table_id

  tags = {
    Name = "private_rt"
  }
}


output "public_rt_id" {
  value = aws_route_table.public.id
}

output "private_rt_id" {
  value = aws_default_route_table.private.id
}