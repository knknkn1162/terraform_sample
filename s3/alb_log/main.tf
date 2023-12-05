resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-prag-2910123"
  force_destroy = true
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