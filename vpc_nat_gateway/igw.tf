module "igw" {
  source = "./igw"
  vpc_id = aws_vpc.example.id
}