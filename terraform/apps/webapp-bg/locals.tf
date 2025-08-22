locals {
  deploy_type          = var.environment == "prod" ? "prod" : "nonprod"
  name_prefix          = "${var.application}-${var.environment}${var.name_sufix}"
  ssm_prefix           = "/${var.platform}/${var.application}/${var.environment}"
  aws_account_id       = data.aws_caller_identity.current.account_id
  image_repository_url = module.nginx_bg.image_repository_uri
  current_image_tag    = "9336cad"
  common_tags = {
    Event          = "KCDColombia2025"
    CostAllocation = "Direct"
    Workload       = "ECS"
    Platform       = var.platform
    Application    = var.application
    Environment    = var.environment
    Provisioned_by = "Terraform"
  }
  tfcore = data.terraform_remote_state.core.outputs
}