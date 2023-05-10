module "acm_alb" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "~> v2.0"
  domain_name = var.public_alb_domain
  zone_id     = data.aws_route53_zone.this.zone_id
  tags        = var.tags
}

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 5.0"
  name               = "${var.env_prefix}-${var.environment}"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.alb.id]

  https_listeners = [
    {
      "certificate_arn" = module.acm_alb.this_acm_certificate_arn
      "port"            = 443
    },
  ]

  target_groups = [
    {
      name             = "${var.env_prefix}-default-${var.environment}"
      backend_protocol = "HTTP"
      backend_port     = 80
    }
  ]
  tags = var.tags
}

module "acm" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "~> v2.0"
  domain_name = var.site_domain
  zone_id     = data.aws_route53_zone.this.zone_id
  tags        = var.tags

  providers = {
    aws = aws.us_east_1 # cloudfront needs acm certificate to be from "us-east-1" region
  }
}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = "${var.env_prefix}-${var.environment}"
  cidr                   = var.vpc_cidr
  azs                    = var.azs
  private_subnets        = var.private_subnet_cidrs
  public_subnets         = var.public_subnet_cidrs
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  tags                   = var.tags
  version                = "~>2.0"
  enable_dns_hostnames   = true
}

module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "3.10.1"
  create_bucket = true

  bucket = var.bucket_name

  versioning = {
    enabled = false
  }
}
