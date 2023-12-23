module "rt" {
  source = "./rt"
  vpc_id = aws_vpc.example.id
  igw_id = module.igw.igw_id
  nat_gateway_id = aws_nat_gateway.example.id
}