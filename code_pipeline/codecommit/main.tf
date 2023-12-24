variable "repository_name" {
  type = string
}

data "aws_codecommit_repository" "test" {
  repository_name = var.repository_name
}

output "repository_id" {
  value = data.aws_codecommit_repository.test.repository_id
}

output "repository_url" {
  value = data.aws_codecommit_repository.test.clone_url_http
}