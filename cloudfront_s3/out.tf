output "s3_arn" {
  value = aws_s3_bucket.example.arn
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}