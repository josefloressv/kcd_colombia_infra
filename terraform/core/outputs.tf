#region Network
output "vpc_id" {
  value = module.net.vpc_id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "private_subnet_ids" {
  value = module.net.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.net.public_subnet_ids
}

#endregion
#region Load Balancer
output "alb_http_listener_arn" {
  value = module.alb.alb_http_listener_arn
}

output "alb_https_listener_arn" {
  value = module.alb.alb_https_listener_arn
}

#endregion

#region Linux ECS Cluster outputs
output "linux_ecs_cluster_arn" {
  value = module.asg_ecs_linux.ecs_cluster_arn
}
output "linux_ecs_cluster_name" {
  value = module.asg_ecs_linux.ecs_cluster_name
}
output "linux_ecs_cluster_capacity_provider_name" {
  value = module.asg_ecs_linux.ecs_cluster_capacity_provider_name
}
#endregion

#region Application IAM Role
output "app_iam_role_arn" {
  value = aws_iam_role.app.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "asg_sg_id" {
  value = aws_security_group.asg.id
}