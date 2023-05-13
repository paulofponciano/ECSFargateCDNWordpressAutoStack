resource "aws_lb_target_group" "this" {
  name        = "${var.env_prefix}-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
  health_check {
    path    = "/"
    matcher = "200,302"
  }

}

resource "aws_lb_listener_rule" "wordpress" {
  listener_arn = module.alb.https_listener_arns[0]
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = [var.site_domain, var.public_alb_domain]
    }
  }

  condition {
    http_header {
      http_header_name = "X-Custom-Secret"
      values           = ["${random_string.custom_header_alb.result}"]
    }
  }
}
