variable "tags" {
  type = map(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "certificate_arn" {
  type    = string
  default = ""
}

variable "security_groups" {
  type = list(string)
}