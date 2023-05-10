# ALB

resource "aws_security_group" "alb" {
  name        = "${var.env_prefix}-alb-${var.environment}"
  description = "Allow HTTPS inbound traffc - ALB"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  tags = var.tags
}

# EFS

resource "aws_security_group" "efs" {
  name        = "${var.env_prefix}-efs-${var.environment}"
  description = "Allow traffic from Fargate - Wordpress"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

# FARGATE - ECS

resource "aws_security_group" "wordpress" {
  name        = "${var.env_prefix}-wordpress-${var.environment}"
  description = "Allow ALL inbound traffc from ALB SG"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# RDS

resource "aws_security_group" "db" {
  vpc_id = module.vpc.vpc_id
  name   = "${var.env_prefix}-db-${var.environment}"
  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}
