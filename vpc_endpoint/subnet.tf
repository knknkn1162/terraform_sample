module "az_0" {
  source = "./subnet"
  availability_zone = "ap-northeast-1a"
  vpc_id = aws_vpc.example.id
  public_rt_id = module.rt.public_rt_id
  public_cidr_block = "10.0.1.0/24"
  private_cidr_block = "10.0.11.0/24"
  suffix = "0"
}

module "az_1" {
  source = "./subnet"
  availability_zone = "ap-northeast-1c"
  vpc_id = aws_vpc.example.id
  public_rt_id = module.rt.public_rt_id
  public_cidr_block = "10.0.2.0/24"
  private_cidr_block = "10.0.21.0/24"
  suffix = "1"
}