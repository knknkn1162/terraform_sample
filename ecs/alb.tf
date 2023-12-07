resource "aws_lb" "example" {
  name = "example"
  load_balancer_type = "application"
  internal = false
  idle_timeout = 60
  # when true we can't `terraform destroy`
  # enable_deletion_protection = true
  
  subnets = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id
  ]
  
  access_logs {
    bucket = aws_s3_bucket.alb_log.id
    enabled = true
  }
  
  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id
  ]
}

module "http_sg" {
  source = "./vpc/sg"
  name = "http-sg"
  vpc_id = aws_vpc.example.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source = "./vpc/sg"
  name = "https-sg"
  vpc_id = aws_vpc.example.id
  port = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source = "./vpc/sg"
  name = "http-redirect-sg"
  vpc_id = aws_vpc.example.id
  port = 8080
  cidr_blocks = ["0.0.0.0/0"]
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name
}