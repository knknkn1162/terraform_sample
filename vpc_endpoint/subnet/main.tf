variable "vpc_id" {}
variable "availability_zone" {
  type = string
}
variable "public_cidr_block" {
  type = string
}
variable "private_cidr_block" {
  type = string
}
variable "public_rt_id" {
}
variable "suffix" {
  type = string
}

resource "aws_subnet" "public" {
  vpc_id = var.vpc_id
  cidr_block = var.public_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = "public_sn_${var.suffix}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = var.vpc_id
  cidr_block = var.private_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = "private_sn_${var.suffix}"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = var.public_rt_id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}