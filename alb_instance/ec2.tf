module "ec2_sg" {
  source = "./sg"
  name = "ec2-sg"
  vpc_id = aws_vpc.example.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "example_0" {
  ami = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id = aws_subnet.private_0.id
  
  user_data = <<EOF
#!/bin/bash
yum install -y httpd
touch /var/www/html/index.html
echo "This is server1" > /var/www/html/index.html
systemctl start httpd.service
  EOF
  
  tags = {
    Name = "ec2_0"
  }
}


resource "aws_instance" "example_1" {
  ami = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id = aws_subnet.private_1.id
  
  user_data = <<EOF
#!/bin/bash
yum install -y httpd
touch /var/www/html/index.html
echo "This is server2" > /var/www/html/index.html
systemctl start httpd.service
  EOF
  tags = {
    Name = "ec2_1"
  }
}