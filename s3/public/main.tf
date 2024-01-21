data "aws_caller_identity" "current" {}
variable "bucket_name" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "public" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "public" {
  bucket = aws_s3_bucket.public.id
  policy = data.aws_iam_policy_document.public.json
}


resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.public.id

  #block_public_acls       = false
  #block_public_policy     = false
  #ignore_public_acls      = false
  restrict_public_buckets = false
}


data "aws_iam_policy_document" "public" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.public.id}/*"]

    principals {
      type = "*"
      identifiers = [ "*" ]
    }
  }
  depends_on = [aws_s3_bucket_website_configuration.example]
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.public.id

  index_document {
    suffix = "index.html"
  }
}