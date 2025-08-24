resource "aws_ssm_parameter" "A_SECRET" {
  name  = "${local.ssm_prefix}/A_SECRET"
  type  = "SecureString"
  value = "dummy"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "active_color" {
  name  = "${local.ssm_prefix}/active_color"
  type  = "String"
  value = "blue" # default value, can be overridden
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "docker_tag" {
  name  = "${local.ssm_prefix}/docker_tag"
  type  = "String"
  value = "latest"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "live_service_minimum_tasks" {
  name  = "${local.ssm_prefix}/live_service_minimum_tasks"
  type  = "String"
  value = var.task_min_number
}