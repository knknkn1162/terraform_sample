module "default_vpc" {
    source = "./vpc"
}

module "default_subnets" {
    source = "./vpc/subnet"
}

module "http_sg" {
  source = "./vpc/sg"
  name = "http-sg"
  vpc_id = module.default_vpc.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}
/*
module "https_sg" {
  source = "./vpc/sg"
  name = "https-sg"
  vpc_id = module.default_vpc.id
  port = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source = "./vpc/sg"
  name = "http-redirect-sg"
  vpc_id = module.default_vpc.id
  port = 8080
  cidr_blocks = ["0.0.0.0/0"]
}
*/