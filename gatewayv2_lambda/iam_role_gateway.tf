module "role_gateway" {
    source = "./iam/role"
    name = "gateway"
    identifier = "apigateway.amazonaws.com"
    policy_arns = [
        aws_iam_policy.gateway.arn
    ]
}

resource "aws_iam_policy" "gateway" {
  name        = "gateway"
  path        = "/"
  description = "My test policy"
  policy = data.aws_iam_policy_document.gateway.json
}

# see https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/http-api-logging.html
data "aws_iam_policy_document" "gateway" {
    statement {
        sid = "log"
        effect = "Allow"

        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents",
            "logs:GetLogEvents",
            "logs:FilterLogEvents"
        ]
        resources = ["*"]
    }

    statement {
        sid = "loggroup"
        effect = "Allow"
        actions = [
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:GetLogEvents",
            "logs:FilterLogEvents"
        ]
        resources = ["arn:aws:logs:ap-northeast-1:${module.sts.account_id}:log-group:*"]
    }
}