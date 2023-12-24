module "codebuild_role" {
  source = "./iam/role"
  name = "codebuild"
  policy_arns = [
    aws_iam_policy.codebuild.arn,
    data.aws_iam_policy.AWSCodeDeployDeployerAccess.arn
  ]
  identifier = "codebuild.amazonaws.com"
}

data "aws_iam_policy" "AWSCodeDeployDeployerAccess" {
  arn = "arn:aws:iam::aws:policy/AWSCodeDeployDeployerAccess"
}

resource "aws_iam_policy" "codebuild" {
  name        = "codebuild"
  path        = "/"
  description = "My codebuild policy"
  policy = data.aws_iam_policy_document.codebuild.json
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateNetworkInterfacePermission"]
    resources = ["arn:aws:ec2:us-east-1:123456789012:network-interface/*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:Subnet"

      values = [
        data.aws_subnet.selected.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      module.s3_private.s3_arn,
      "${module.s3_private.s3_arn}/*",
    ]
  }
}

data "aws_subnet" "selected" {
  id = module.default_subnets.subnet_ids[0]
}