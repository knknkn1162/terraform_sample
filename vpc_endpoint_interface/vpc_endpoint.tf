module "vpc_endpoint_ssm" {
  source = "./vpc_endpoint"
  vpc_id = aws_vpc.example.id
  service_names = {
    "com.amazonaws.ap-northeast-1.ssm" = "Interface",
    "com.amazonaws.ap-northeast-1.ssmmessages" = "Interface",
    "com.amazonaws.ap-northeast-1.ec2messages" = "Interface"
  }
  subnet_ids = [module.az_0.public_subnet_id]
  security_group_ids = [module.sg_vpc_endpoint.security_group_id]
} 