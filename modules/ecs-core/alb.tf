########################################################################################################################
## Application Load Balancer in public subnets with HTTP default listener that redirects traffic to HTTPS
########################################################################################################################

resource "aws_alb" "alb" {
  name            = "${var.project_name}-ALB"
  security_groups = [aws_security_group.alb.id, var.default_security_group_id]
  subnets         = var.public_subnets

  tags = {
    Scenario = var.scenario
  }
}

########################################################################################################################
## Default HTTPS listener that blocks all traffic without valid custom origin header
########################################################################################################################

resource "aws_alb_listener" "alb_default_listener_https" {
  load_balancer_arn         = aws_alb.alb.arn
  port                      = "443"
  protocol                  = "HTTPS"
  certificate_arn   = var.ingress_ssl_arn

  default_action {
    type                    = "forward"
    target_group_arn        = aws_alb_target_group.service_target_group.arn
  }

  tags = {
    Scenario = var.scenario
  }
}

resource "aws_alb_listener" "redirect" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener_rule" "frontend_listener" {
  for_each = { 
    for index, app in var.apps : app.app_name => app
  }
  
  listener_arn = aws_alb_listener.alb_default_listener_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app_service_target_group[each.key].arn
  }

  condition {
    host_header {
      values = ["${each.value.domain}"]
    }
  }
}

########################################################################################################################
## Target Group for our service
########################################################################################################################

resource "aws_alb_target_group" "service_target_group" {
  name                 = "${var.project_name}-TargetGroup"
  port                 = var.container_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 5
  target_type          = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    matcher             = var.healthcheck_matcher
    path                = var.healthcheck_endpoint
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
  }

  tags = {
    Scenario = var.scenario
  }

  depends_on = [aws_alb.alb]
}

resource "aws_alb_target_group" "app_service_target_group" {
  for_each = { for app in var.apps : app.app_name => app }

  name                 = each.value.app_name
  port                 = each.value.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 5
  target_type          = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 90
    matcher             = var.healthcheck_matcher
    path                = each.value.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 60
  }

  tags = {
    Scenario = var.scenario
  }

  depends_on = [aws_alb.alb]
}
