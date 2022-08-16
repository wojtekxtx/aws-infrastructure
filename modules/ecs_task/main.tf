locals {
  task_definition = [
    for container in var.containers : {
      name      = container.name
      image     = "${container.image_repo.repository_url}@${data.aws_ecr_image.this[container.name].id}"
      essential = true
      command   = container.command
      portMappings = [
        for port in container.ports : {
          containerPort = port
          hostPort      = port
          protocol      = "tcp"
        }
      ]
      environment = [
        for name, value in container.environment : {
          name  = name
          value = value
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-stream-prefix = "ecs" // Can't be empty
          awslogs-region        = data.aws_region.current.name
        }
      }
    }
  ]
}

data "aws_ecr_image" "this" {
  for_each = { for elem in var.containers : elem.name => {
    image_repo = elem.image_repo,
    image_tag  = elem.image_tag,
  } }
  repository_name = each.value.image_repo.name
  image_tag       = each.value.image_tag
}

data "aws_region" "current" {}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ecs" {
  name               = "${var.name}-${var.environment}-ecs"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role" "app" {
  name               = "${var.name}-${var.environment}-app"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.name}-${var.environment}"
  retention_in_days = 14
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  // In brain damaged AWS naming terms, execution role is used to spawn container only, NOT running app inside.
  // execution_role_arn = role to grant pulling container, creating cloudwatch logs etc.
  // task_role_arn = permissions for app itself
  execution_role_arn    = aws_iam_role.ecs.arn
  task_role_arn         = aws_iam_role.app.arn
  container_definitions = jsonencode(local.task_definition)
}
