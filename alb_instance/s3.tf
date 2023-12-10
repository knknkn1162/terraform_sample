resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-prag-2910123"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "alg_log" {
    bucket = aws_s3_bucket.alb_log.id
    policy = data.aws_iam_policy_document.alb_log.json
}

locals {
  # see https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/enable-access-logging.html
  elb_account_id = "582318560864"
}
# # Access Denied for bucket: alb-log-prag-2910123. Please check S3bucket permission
data "aws_iam_policy_document" "alb_log" {
    statement {
        effect = "Allow"
        actions = ["s3:PutObject"]
        resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]
        principals {
            type = "AWS"
            identifiers = [local.elb_account_id]
        }
    }
}