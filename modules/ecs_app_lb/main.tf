locals {
  fqdn = "${var.name}-${var.environment}.${var.zone.name}"
  health_check_defaults = {
    unhealthy_threshold = 3
    healthy_threshold   = 2
    interval            = 30
    timeout             = 10
    success_codes       = [200]
    path                = "/health"
  }
  health_check = merge(local.health_check_defaults, var.health_check)
}

module "ecs_task" {
  source      = "../ecs_task"
  cpu         = var.cpu
  memory      = var.memory
  containers  = var.containers
  environment = var.environment
  name        = var.name
}

resource "aws_ecs_service" "this" {
  name                               = "${var.name}-${var.environment}"
  cluster                            = var.ecs.cluster_id
  task_definition                    = module.ecs_task.task_def.arn
  desired_count                      = var.desired_replica_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 600
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = var.ecs.subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.this.arn
    container_name   = var.load_balancer.container_name
    container_port   = var.load_balancer.container_port
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name}-${var.environment}"
  description = var.name
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_incoming" {
  description              = "Allow incoming HTTP"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.load_balancer.sg_id
  type                     = "ingress"
  from_port                = var.load_balancer.container_port
  to_port                  = var.load_balancer.container_port
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "allow_outgoing" {
  description       = "Allow all outgoing"
  security_group_id = aws_security_group.this.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_alb_target_group" "this" {
  name        = "${var.name}-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = local.health_check.healthy_threshold
    interval            = local.health_check.interval
    protocol            = "HTTP"
    matcher             = join(",", local.health_check.success_codes)
    timeout             = local.health_check.timeout
    path                = local.health_check.path
    unhealthy_threshold = local.health_check.unhealthy_threshold
  }
}

resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  listener_arn = var.load_balancer.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }

  condition {
    host_header {
      values = [local.fqdn]
    }
  }
}

resource "aws_route53_record" "this" {
  zone_id = var.zone.id
  name    = local.fqdn
  type    = "A"
  alias {
    name                   = var.load_balancer.resource.dns_name
    zone_id                = var.load_balancer.resource.zone_id
    evaluate_target_health = true
  }
}
