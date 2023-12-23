data "aws_vpc" "default" {
  default = true
}

output "id" {
    value = data.aws_vpc.default.id
}