module "sg_vpc_endpoint" {
  source = "./sg"
  name = "sg_vpc_endpoint"
  vpc_id = aws_vpc.example.id
  cidr_blocks = [var.vpc_cidr_block]
  port = "443"
}