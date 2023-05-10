resource "aws_rds_cluster" "this" {
  cluster_identifier      = "${var.env_prefix}-${var.environment}"
  engine                  = "aurora-mysql"
  engine_mode             = "provisioned"
  vpc_security_group_ids  = [aws_security_group.db.id]
  db_subnet_group_name    = aws_db_subnet_group.this.name
  engine_version          = var.db_engine_version
  availability_zones      = var.azs
  database_name           = var.db_name
  master_username         = var.db_master_username
  master_password         = var.db_master_password
  backup_retention_period = var.db_backup_retention_days
  preferred_backup_window = var.db_backup_window
  serverlessv2_scaling_configuration {
    max_capacity = var.db_max_capacity
    min_capacity = var.db_min_capacity
  }
  final_snapshot_identifier = "${var.env_prefix}-${var.environment}-${random_string.snapshot_suffix.result}"
  tags                      = var.tags
}

resource "aws_rds_cluster_instance" "this" {
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
}

resource "random_string" "snapshot_suffix" {
  length  = 8
  special = false
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.env_prefix}-${var.environment}"
  subnet_ids = module.vpc.private_subnets
  tags       = var.tags
}

resource "aws_ssm_parameter" "db_master_user" {
  name  = "/${var.env_prefix}/${var.environment}/db_master_user"
  type  = "SecureString"
  value = var.db_master_username
  tags  = var.tags
}

resource "aws_ssm_parameter" "db_master_password" {
  name  = "/${var.env_prefix}/${var.environment}/db_master_password"
  type  = "SecureString"
  value = var.db_master_password
  tags  = var.tags
}
