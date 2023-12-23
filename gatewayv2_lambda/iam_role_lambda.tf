module "role_lambda" {
    source = "./iam/role"
    name = "lambda"
    identifier = "lambda.amazonaws.com"
    policy_arns = [
        aws_iam_policy.logging.arn,
        data.aws_iam_policy.TranslateFullAccess.arn
    ]
}

#---
data "aws_iam_policy" "TranslateFullAccess" {
  arn = "arn:aws:iam::aws:policy/TranslateFullAccess"
}

resource "aws_iam_policy" "logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.logging.json
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
## https://docs.aws.amazon.com/ja_jp/aws-managed-policy/latest/reference/AWSLambdaBasicExecutionRole.html
data "aws_iam_policy_document" "logging" {
  statement {
    sid = "log"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}