module "rt" {
  source = "./rt"
  vpc_id = aws_vpc.example.id
  igw_id = module.igw.igw_id
}