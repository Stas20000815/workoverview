###___________Resource_group____________________________________________
variable "cs_resource_group_name" {
  type        = string
  description = "The name of resource group"
}
variable "cs_resource_group_location" {
  type        = string
  description = "The location of resource group"
}
variable "cs_rg_tags" {
  type        = map
  description = "The name and value of tags"
}

###___________Azure_AD_application______________________________________
variable "cs_azuread_application_name" {
  type        = string
  description = "The name of azuread application"
}

###___________Azure_AD_service_principal________________________________
variable "cs_azuread_service_principal_password" {
  type        = string
  description = "The password of azure AD application service principal"
}
variable "cs_azuread_service_principal_end_date" {
  type        = string
  description = "The end date of azure AD application service principal"
}

###___________Kubernetes_cluster________________________________________
variable "cs_kubernetes_cluster_name" {
  type        = string
  description = "The name of kubernetes cluster"
}
variable "cs_kubernetes_cluster_dns_prefix" {
  type        = string
  description = "The name of kubernetes dns prefix"
}
###____________Nodes_pool_______________________________________________
variable "cs_node_pool_name" {
  type        = string
  description = "The name of kubernetes node pool"
}
variable "cs_node_pool_node_count" {
  type        = string
  description = "The number of kuberenetes nodes count"
}
variable "cs_node_pool_vm_size" {
  type        = string
  description = "The size of kubernetes nodes pool VMs"
}
###____________Tags_____________________________________________________
variable "cs_aks_tags" {
  type        = map
  description = "The name and value of tags"
}

###________________StaticIP_______________________________________________
variable "cs_public_ip_name" {
  type        = string
  description = "The name of static IP"
}
