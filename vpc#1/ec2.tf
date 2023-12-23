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

resource "aws_instance" "example_0" {
  ami = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id = module.az_0.private_subnet_id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.example.name
  user_data = <<EOF
#!/bin/bash
yum install -y httpd
touch /var/www/html/index.html
echo "This is server1" > /var/www/html/index.html
systemctl enable httpd.service
systemctl start httpd.service
  EOF
  
  tags = {
    Name = "ec2_private"
  }
}

resource "aws_eip" "private_ec2" {
}

resource "aws_nat_gateway" "example" {
  #connectivity_type = "public"
  subnet_id = module.az_0.public_subnet_id
  allocation_id = aws_eip.private_ec2.allocation_id
  tags = {
    Name = "gw NAT"
  }
}