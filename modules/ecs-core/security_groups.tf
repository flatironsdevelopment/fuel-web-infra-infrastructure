resource "aws_security_group" "ecs_container_instance" {
  name        = "${var.project_name}_ECS_Task_SecurityGroup"
  description = "Security group for ECS task running on Fargate"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ingress traffic from ALB on HTTP only"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id] 
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.project_name}_ECS_Task_SecurityGroup"
    Scenario = var.scenario
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.project_name}_ALB_SecurityGroup"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id
  revoke_rules_on_delete      = true

  tags = {
    Name     = "${var.project_name}_ALB_SecurityGroup"
    Scenario = var.scenario
  }
}

# ------------------------------------------------------------------------------
# Alb Security Group Rules - INBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "alb_http_ingress" {
    type                        = "ingress"
    from_port                   = 80
    to_port                     = 80
    protocol                    = "TCP"
    description                 = "Allow http inbound traffic from internet"
    security_group_id           = aws_security_group.alb.id
    cidr_blocks                 = ["0.0.0.0/0"] 
}
resource "aws_security_group_rule" "alb_https_ingress" {
    type                        = "ingress"
    from_port                   = 443
    to_port                     = 443
    protocol                    = "TCP"
    description                 = "Allow https inbound traffic from internet"
    security_group_id           = aws_security_group.alb.id
    cidr_blocks                 = ["0.0.0.0/0"] 
}

# ------------------------------------------------------------------------------
# Alb Security Group Rules - OUTBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "alb_egress" {
    type                        = "egress"
    from_port                   = 0
    to_port                     = 0
    protocol                    = "-1"
    description                 = "Allow outbound traffic from alb"
    security_group_id           = aws_security_group.alb.id
    cidr_blocks                 = ["0.0.0.0/0"] 
}