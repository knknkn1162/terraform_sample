resource "aws_s3_bucket" "public" {
  bucket = "public-pragmatic-terraform-235983"
}

resource "aws_s3_bucket_acl" "public" {
  depends_on = [
    aws_s3_bucket_public_access_block.public,
    aws_s3_bucket_ownership_controls.public
  ]
  bucket = aws_s3_bucket.public.id
  # Canned ACL; see https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl
  acl    = "public-read"
}

resource "aws_s3_bucket_ownership_controls" "public" {
  bucket = aws_s3_bucket.public.id
  rule {
    # see https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html#object-ownership-overview
    object_ownership = "ObjectWriter"
  }
}


resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.public.id

  block_public_acls       = false
  #block_public_policy     = false
  #ignore_public_acls      = false
  #restrict_public_buckets = false
}

resource "aws_s3_bucket_cors_configuration" "pubic" {
  bucket = aws_s3_bucket.public.id
  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}
