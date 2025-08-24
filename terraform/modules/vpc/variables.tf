variable "tags" {
  type = map(string)
}

variable "vpc_cidr" {
  type = string
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name used for subnet auto-discovery tags"
  default     = ""
}