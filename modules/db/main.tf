resource "random_password" "this" {
  length      = 32
  special     = false
  lower       = true
  upper       = true
  numeric     = true
  min_lower   = 2
  min_numeric = 2
  min_special = 0
  min_upper   = 2
}

resource "aws_db_subnet_group" "this" {
  name       = var.identifier
  subnet_ids = var.subnet_ids
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      name
    ]
  }
}

resource "aws_db_parameter_group" "this" {
  name   = var.identifier
  family = "postgres${var.pg_major}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "this" {
  identifier     = var.identifier
  db_name        = var.name
  engine         = "postgres"
  engine_version = "${var.pg_major}.${var.pg_minor}"
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
  final_snapshot_identifier    = "${var.identifier}-final"
  performance_insights_enabled = false
  deletion_protection          = true
  delete_automated_backups     = false
}
