module "sg_ec2" {
  source = "./sg"
  name = "sg_ec2"
  vpc_id = aws_vpc.example.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}