resource "aws_security_group" "ecs_sg" {
  name        = "${local.name_prefix}-ecs-sg"
  description = "Security group for ECS service"
  vpc_id      = var.vpc_id

  # Allow traffic from the ALB on the application port (if provided)
  dynamic "ingress" {
    for_each = var.alb_sg_id != "" ? [1] : []
    content {
      from_port       = var.app_port
      to_port         = var.app_port
      protocol        = "tcp"
      security_groups = [var.alb_sg_id]
      description     = "Allow ALB to talk to tasks on container port"
    }
  }

  # Allow ephemeral ports from ASG / EC2 instances (useful when hostPort is ephemeral)
  dynamic "ingress" {
    for_each = var.asg_sg_id != "" ? [1] : []
    content {
      from_port       = 1024
      to_port         = 65535
      protocol        = "tcp"
      security_groups = [var.asg_sg_id]
      description     = "Allow EC2 instances / ASG to reach ephemeral host ports"
    }
  }

  # Fallback: allow traffic from VPC CIDR on application port
  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow internal VPC traffic to app port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}