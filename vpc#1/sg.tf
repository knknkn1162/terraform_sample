module "ec2_sg" {
  source = "./sg"
  name = "ec2-sg"
  vpc_id = aws_vpc.example.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}