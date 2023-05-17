variable "ingress_cidr_ipv4" {
  description = "Ingress IPv4 CIDR"
  type        = string
  default     = null
}

variable "egress_cidr_ipv4" {
  description = "Egress IPv4 CIDR"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = null
}