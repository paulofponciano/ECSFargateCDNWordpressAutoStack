resource "aws_efs_file_system" "this" {
  creation_token  = "${var.env_prefix}-${var.environment}"
  encrypted       = true
  throughput_mode = "bursting"
  tags            = var.tags
}

resource "aws_efs_mount_target" "this" {
  count          = length(module.vpc.private_subnets)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = module.vpc.private_subnets[count.index]
  security_groups = [
    aws_security_group.efs.id
  ]
}
