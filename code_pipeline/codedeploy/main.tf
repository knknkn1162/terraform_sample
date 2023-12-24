variable "app_name" {
  type = string
}

resource "aws_codedeploy_app" "example" {
  # default
  compute_platform = "Server"
  name             = var.app_name
}