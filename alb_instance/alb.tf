resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  
  # default sg by default
  security_groups = [
    module.http_sg.security_group_id
  ]
  
  subnets = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id
  ]
  enable_deletion_protection = false
  
  
  access_logs {
    bucket  = aws_s3_bucket.alb_log.id
    prefix  = "test-lb"
    enabled = true
  }
}

module "http_sg" {
  source = "./sg"
  name = "http-sg"
  vpc_id = aws_vpc.example.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

output "alb_dns_name" {
  value = aws_lb.test.dns_name
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.example.id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "test_0" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.example_0.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "test_1" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.example_1.id
  port             = 80
}
