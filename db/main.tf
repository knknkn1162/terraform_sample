resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.small"
  db_name              = "mydb"
  username             = "admin"
  # kms key: aws/secretsmanager
  manage_master_user_password = true
  # keep information tfstate file, it's dangerous
  #password             = data.aws_ssm_parameter.example.value
  vpc_security_group_ids     = [module.mysql_sg.security_group_id]
  parameter_group_name       = aws_db_parameter_group.example.name
  #option_group_name          = aws_db_option_group.example.name
  db_subnet_group_name       = aws_db_subnet_group.example.name
  storage_encrypted = true
  # support `terraform destroy`
  #deletion_protection        = false
  skip_final_snapshot        = true
}

resource "aws_db_subnet_group" "example" {
  name       = "example"
  subnet_ids = [aws_subnet.private_0.id, aws_subnet.private_1.id]
}

resource "aws_db_parameter_group" "example" {
  name   = "example"
  family = "mysql5.7"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}
/*
// aws_db_option_group.example.name
resource "aws_db_option_group" "example" {
  name                 = "example"
  engine_name          = "mysql"
  major_engine_version = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}
*/

module "mysql_sg" {
  source      = "./sg"
  name        = "mysql-sg"
  vpc_id      = aws_vpc.example.id
  port        = 3306
  cidr_blocks = [aws_vpc.example.cidr_block]
}

output "endpoint" {
  value = aws_db_instance.default.endpoint
}

output "resource_id" {
  value = aws_db_instance.default.resource_id
}

output "username" {
  value = aws_db_instance.default.username
}