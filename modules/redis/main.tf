resource "aws_security_group" "staging" {
  name        = "${var.app_name}-redis-sg"
  description = "Allow Redis traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "staging" {
  name       = "${var.app_name}-ecsg"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "staging" {
  cluster_id           = var.app_name
  engine               = "redis"
  node_type            = "cache.t3.small"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.staging.name
  engine_version       = "7.1"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.staging.name
  security_group_ids   = [aws_security_group.staging.id]
}

resource "aws_elasticache_parameter_group" "staging" {
  name        = "${var.app_name}-ec-param-group"
  family      = "redis7"
  description = "Custom parameter group for Redis cluster"

  parameter {
    name  = "maxmemory-policy"
    value = "noeviction"
  }
}