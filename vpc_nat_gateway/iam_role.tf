module "ssm_role" {
  source = "./iam/role"
  name = "ssm"
  policy_arns = [data.aws_iam_policy.AmazonSSMFullAccess.arn]
  identifier = "ec2.amazonaws.com"
}

data "aws_iam_policy" "AmazonSSMFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}