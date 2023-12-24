data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# necessary
resource "aws_iam_instance_profile" "example" {
  name = module.ssm_role.iam_role_name
  role = module.ssm_role.iam_role_name
}

resource "aws_instance" "private" {
  ami = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.sg_ec2.security_group_id]
  subnet_id = module.az_0.private_subnet_id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.example.name
  
  tags = {
    Name = "ec2_private"
  }
}