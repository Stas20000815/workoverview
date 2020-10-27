variable "cs_namespace_name" {
  type = set(string)
}

variable "cs_ingress_ip_address" {
  type = string
}

variable "cs_cert_manager_enable" {
  type    = bool
  default = false
}

variable "cs_dns_token" {
  type = map(string)
  default = {
  }
}

variable "cs_azure_dns_sp_app_id" {
  type = string
}

variable "cs_azure_dns_zone_rg" {
  type = string
}

variable "cs_azure_dns_zone" {
  type = string
}
