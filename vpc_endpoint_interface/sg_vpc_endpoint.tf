module "sg_vpc_endpoint" {
  source = "./sg"
  name = "sg_vpc_endpoint"
  vpc_id = aws_vpc.example.id
  cidr_blocks = ["10.0.0.0/16"]
  port = "443"
}