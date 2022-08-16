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
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = var.ecs.subnets
    assign_public_ip = false
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name}-${var.environment}"
  description = var.name
  vpc_id      = var.vpc_id
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
