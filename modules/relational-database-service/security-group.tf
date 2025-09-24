resource "aws_security_group" "this" {
  name        = "${var.app_name}-rds-security-group"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = split(",", tostring(var.allowed_ip_list))
  }
}