# Environment

variable "tags" {
  description = "AWS Tags to add to all resources created."
  type        = map(string)
  default = {
    Terraform = "true"
    Owner     = "SRE Team"
    Env       = "dev"
  }
}

variable "aws_region" {
  description = "AWS Region (e.g. us-east-1, us-west-2, sa-east-1, us-east-2)"
  default     = "us-west-2"
}

variable "azs" {
  description = "AWS Availability Zones (e.g. us-east-1a, us-west-2b, sa-east-1c, us-east-2a"
  default = [
    "us-west-2a",
    "us-west-2b"
  ]
}

variable "env_prefix" {
  description = "Environment prefix for all resources to be created. e.g. customer name"
  default     = "wordp"
}

variable "environment" {
  description = "Name of the application environment. e.g. dev, prod, staging."
  default     = "dev"
}

variable "site_domain" {
  description = "The primary domain name of the website."
  default     = "wordpress.pauloponciano.pro"
}

variable "public_alb_domain" {
  description = "The public domain name of the ALB."
  default     = "alb.pauloponciano.pro"
}

variable "cf_price_class" {
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100."
  default     = "PriceClass_100"
}

variable "error_ttl" {
  description = "The minimum amount of time (in secs) that cloudfront caches an HTTP error code."
  default     = "30"
}

variable "desired_count" {
  description = "The number of instances of fargate tasks to keep running."
  default     = "1"
}
variable "log_retention_in_days" {
  description = "The number of days to retain cloudwatch logs."
  default     = "1"
}

# VPC parameters

variable "vpc_cidr" {
  description = "The VPC CIDR block."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  default     = ["10.0.32.0/20", "10.0.48.0/20"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  default     = ["10.0.64.0/20", "10.0.80.0/20"]
}

# Database parameters

variable "db_backup_retention_days" {
  description = "Number of days to retain database backups."
  default     = "1"
}

variable "db_backup_window" {
  description = "Daily time range during which automated backups for rds are created if automated backups are enabled using the BackupRetentionPeriod parameter. Time in UTC."
  default     = "05:00-07:00"
}

variable "db_max_capacity" {
  description = "The maximum Aurora capacity unit."
  default     = "2.0"
}

variable "db_min_capacity" {
  description = "The minimum Aurora capacity unit."
  default     = "1.0"
}

variable "db_name" {
  description = "Database name."
  default     = "wordp"
}

variable "db_master_username" {
  description = "Master username of db."
  default     = "wordp"
}

variable "db_master_password" {
  description = "Master password of db."
}

variable "db_engine_version" {
  description = "The database engine version."
  default     = "8.0.mysql_aurora.3.02.0"
}

# Task parameters

variable "task_memory" {
  description = "The amount (in MiB) of memory used by the task."
  default     = 2048
}
variable "task_cpu" {
  description = "The number of cpu units used by the task."
  default     = 1024
}

variable "scaling_up_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start (upscaling)."
  default     = "60"
}

variable "scaling_down_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start (downscaling)."
  default     = "300"
}

variable "scaling_up_adjustment" {
  description = " The number of tasks by which to scale, when the upscaling parameters are breached."
  default     = "1"
}

variable "scaling_down_adjustment" {
  description = " The number of tasks by which to scale (negative for downscaling), when the downscaling parameters are breached."
  default     = "-1"
}

variable "task_cpu_low_threshold" {
  description = "The CPU value below which downscaling kicks in."
  default     = "30"
}

variable "task_cpu_high_threshold" {
  description = "The CPU value above which downscaling kicks in."
  default     = "75"
}

variable "max_task" {
  description = "Maximum number of tasks should the service scale to."
  default     = "3"
}

variable "min_task" {
  description = "Minimum number of tasks should the service always maintain."
  default     = "2"
}

# S3 parameters

variable "bucket_name" {
  description = "S3 Bucket for wordpress assets."
  default     = "paulop-wordp-assets"
}
