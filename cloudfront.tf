resource "aws_cloudfront_origin_access_control" "wordpress" {
  name                              = "wordpress"
  description                       = "S3 Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "random_string" "custom_header_alb" {
  length  = 8
  special = true
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = var.public_alb_domain
    origin_id   = "alb"

    custom_header {
      name  = "X-Custom-Secret"
      value = random_string.custom_header_alb.result
    }

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]

    }
  }

  origin {
    domain_name              = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    origin_id                = "s3_assets"
    origin_access_control_id = aws_cloudfront_origin_access_control.wordpress.id
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = var.site_domain

  aliases = [var.site_domain]

  # Cache behavior with precedence 1

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "alb"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }

    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
  }

  # Cache behavior with precedence 0

  ordered_cache_behavior {
    path_pattern     = "/wp-content/uploads"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "s3_assets"

    forwarded_values {
      query_string = true
      headers      = ["Host"]

      cookies {
        forward = "all"
      }
    }

    min_ttl                = 900
    default_ttl            = 900
    max_ttl                = 900
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = var.cf_price_class
  tags        = var.tags
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = module.acm.this_acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  custom_error_response {
    error_code            = 400
    error_caching_min_ttl = var.error_ttl
  }

  custom_error_response {
    error_code            = 403
    error_caching_min_ttl = var.error_ttl
  }

  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = var.error_ttl
  }

  custom_error_response {
    error_code            = 405
    error_caching_min_ttl = var.error_ttl
  }

  depends_on = [
    aws_ecs_service.this,
    module.s3_bucket
  ]
}
