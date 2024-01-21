variable "s3_bucket_name" {}

resource "aws_s3_bucket" "example" {
  bucket = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.example.arn}/*"]

    principals {
      type = "Service"
      identifiers = [ "cloudfront.amazonaws.com" ]
    }
  }
}