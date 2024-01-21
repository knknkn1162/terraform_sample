resource "aws_cloudfront_origin_access_control" "example" {
  name                              = "example"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id = "origin-${uuid()}"
}

data "aws_cloudfront_cache_policy" "example" {
  # AWS managed cache policy names are prefixed with Managed-:
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  # Required args
  origin {
    domain_name              = aws_s3_bucket.example.bucket_regional_domain_name
    # If an S3 origin is required, use origin_access_control_id or s3_origin_config instead.
    origin_access_control_id = aws_cloudfront_origin_access_control.example.id
    origin_id                = local.s3_origin_id
  }
  enabled = true
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id = data.aws_cloudfront_cache_policy.example.id
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }
  # optional args
  # http_version = "http2" # default
  default_root_object = "index.html"
}

