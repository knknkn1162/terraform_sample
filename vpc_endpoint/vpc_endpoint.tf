module "vpc_endpoint_ssm" {
  source = "./vpc_endpoint_interface"
  vpc_id = aws_vpc.example.id
  service_names = [
    "com.amazonaws.ap-northeast-1.ssm",
    "com.amazonaws.ap-northeast-1.ssmmessages",
    "com.amazonaws.ap-northeast-1.ec2messages"
  ]
  subnet_ids = [module.az_0.public_subnet_id]
  security_group_ids = [module.sg_vpc_endpoint.security_group_id]
}

module "vpc_endpoint_s3" {
  source = "./vpc_endpoint_gateway"
  vpc_id = aws_vpc.example.id
  service_names = [
    "com.amazonaws.ap-northeast-1.s3"    
  ]
  route_table_ids = [
    module.rt.public_rt_id,
    module.rt.private_rt_id
  ]
}