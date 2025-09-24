module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.app_name

  engine            = "postgres"
  engine_version    = "14.17"
  instance_class    = "db.t3.small"
  allocated_storage = 30

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  iam_database_authentication_enabled = false
  manage_master_user_password         = false
  publicly_accessible                 = true

  vpc_security_group_ids = [aws_security_group.this.id, var.vpc_security_group_default]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  create_db_subnet_group = true
  subnet_ids             = var.subnet_ids

  family               = "postgres14"
  major_engine_version = "14"
  deletion_protection  = false
}
