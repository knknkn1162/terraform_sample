resource "aws_codebuild_project" "example" {
  name = "example"
  source {
    type = "CODEPIPELINE"
    location = module.codecommit.repository_url
  }
  source_version = "main"

  environment {
    type = "LINUX_CONTAINER"
    compute_type = "BUILD_GENERAL1_MEDIUM"
    # see https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
  }

  service_role = module.codebuild_role.iam_role_arn

  artifacts {
    type = "S3"
    name = var.bucket_name
  }
}