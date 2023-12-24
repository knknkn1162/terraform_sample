module "s3_private" {
  source = "./s3/private"
  bucket_name = var.bucket_name
}