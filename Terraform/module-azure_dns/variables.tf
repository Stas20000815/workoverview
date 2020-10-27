variable "cs_azure_dns_enable" {
  type    = bool
  default = false
}

variable "cs_dns_name" {
  type = string
}

variable "cs_dns_resource_group_name" {
  type        = string
  description = "The name of resource group"
}

###___________Azure_AD_application______________________________________
variable "cs_dns_azuread_application_name" {
  type        = string
  description = "The name of azuread application"
}

###___________Azure_AD_service_principal________________________________
variable "cs_dns_azuread_service_principal_password" {
  type        = string
  description = "The password of azure AD application service principal"
}
variable "cs_dns_azuread_service_principal_end_date" {
  type        = string
  description = "The end date of azure AD application service principal"
}

variable "cs_ingress_ip_address" {
  type = string
}
