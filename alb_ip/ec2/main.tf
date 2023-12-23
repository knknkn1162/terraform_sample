# for forwarded target group
module "default_vpc" {
    source = "../vpc"
}

module "ec2_sg" {
  source = "../vpc/sg"
  name = "ec2-sg"
  vpc_id = module.default_vpc.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "default_subnets" {
    source = "../vpc/subnet"
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "example" {
  ami = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id = module.default_subnets.subnet_ids[0]
  
  user_data = <<EOF
#!/bin/bash
yum install -y httpd
touch /var/www/html/index.html
echo "This is server" > /var/www/html/index.html
systemctl start httpd.service
  EOF
  
  tags = {
    Name = "ec2_0"
  }
}

output "private_ip" {
    value = aws_instance.example.private_ip
}