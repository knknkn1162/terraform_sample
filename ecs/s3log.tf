locals {
  # see https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/enable-access-logging.html
  account_id = 582318560864
}

resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-prag-2910123"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.alb_log.id 
  policy = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "example" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]
    principals {
      type = "AWS"
      identifiers = [local.account_id]
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  rule {
    id = "rule"
    status = "Enabled"
    expiration {
      days = 180
    }
  }
}