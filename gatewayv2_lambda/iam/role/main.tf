variable "name" {}
variable "identifier" {}
variable "policy_arns" {
    type = list(string)
}

resource "aws_iam_role" "default" {
  name = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [var.identifier]
    }
  }
}

resource "aws_iam_role_policy_attachment" "default" {
    for_each = { for i, value in var.policy_arns : i => value }
    role       = aws_iam_role.default.name
    policy_arn = each.value
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

output "iam_role_name" {
  value = aws_iam_role.default.name
}