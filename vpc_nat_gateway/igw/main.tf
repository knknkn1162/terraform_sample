variable "vpc_id" {
}

resource "aws_internet_gateway" "example" {
  tags = {
    Name = "igw"
  }
}
resource "aws_internet_gateway_attachment" "example" {
  internet_gateway_id = aws_internet_gateway.example.id
  vpc_id              = var.vpc_id
}

output "igw_id" {
  value = aws_internet_gateway.example.id
}