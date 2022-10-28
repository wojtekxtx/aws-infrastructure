locals {
  resource_name = "${var.rds_name}-${var.environment}"
}

resource "random_password" "this" {
  length      = 64
  special     = true
  lower       = true
  upper       = true
  numeric     = true
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  min_upper   = 2
}

resource "aws_ssm_parameter" "credentials" {
  name = "/${local.resource_name}/credentials"
  type = "SecureString"
  value = jsonencode({
    username = var.username,
    password = random_password.this.result,
    host     = aws_db_instance.this.address,
    db_name  = var.db_name,
    }
  )
  key_id = var.kms_alias
}

resource "aws_db_subnet_group" "this" {
  name       = local.resource_name
  subnet_ids = var.subnet_ids
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      name
    ]
  }
}

resource "aws_db_parameter_group" "this" {
  name   = local.resource_name
  family = "postgres${var.pg_major}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "this" {
  identifier     = local.resource_name
  db_name        = var.db_name
  engine         = "postgres"
  engine_version = var.pg_major
  instance_class = var.instance_class
  username       = var.username
  password       = random_password.this.result
  port           = 5432

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  iops                  = var.iops
  storage_encrypted     = false

  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = aws_db_parameter_group.this.name
  availability_zone      = var.availability_zone
  multi_az               = var.multi_az

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  copy_tags_to_snapshot   = true

  publicly_accessible          = false
  allow_major_version_upgrade  = false
  auto_minor_version_upgrade   = true
  apply_immediately            = var.apply_immediately
  skip_final_snapshot          = false
  final_snapshot_identifier    = "${local.resource_name}-final"
  performance_insights_enabled = false
  deletion_protection          = true
  delete_automated_backups     = false
}
