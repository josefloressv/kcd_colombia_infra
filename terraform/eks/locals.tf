locals {
  name_prefix = join("-", [var.platform, var.environment])
  tags = {
    Event          = "KCDColombia2025"
    CostAllocation = "Direct"
    Workload       = "EKS"
    Application    = var.application
    Platform       = var.platform
    Environment    = var.environment
    ProvisionedBy  = "Terraform"
  }
}