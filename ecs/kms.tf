resource "aws_kms_key" "example" {
  description = "example key"
  enable_key_rotation = true
  is_enabled = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "example" {
  name = "alias/example"
  target_key_id = aws_kms_key.example.key_id
}

resource "aws_ssm_parameter" "db_username" {
  name = "/db/username"
  value = "root"
  type = "String"
  description = "db username"
}

resource "aws_ssm_parameter" "db_password" {
  name = "/db/password"
  value = "xxx"
  type = "SecureString"
  description = "db password"
  
  lifecycle {
    ignore_changes = [value]
  }
}