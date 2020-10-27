###___________Resource_group_________________________
### Name of resource group to create
cs_resource_group_name = "test"
### Location of resource group to create
cs_resource_group_location = "northeurope"
cs_rg_tags = {
  Infrastructure = "test"
  Environment    = "Development"
}

###___________Azure_AD_application________________________
# Name of azure AD application
cs_azuread_application_name = "test"

###___________Azure_AD_service_principal__________________
# Password of azure AD application service principal
cs_azuread_service_principal_password = "test"
### End date of azure AD application service principal
cs_azuread_service_principal_end_date = "2025-01-01T01:02:03Z"

###___________Kubernetes_cluster______________________
### Name of kubernetes cluster to create
cs_kubernetes_cluster_name = "test"
### Name of DNS prefix to create
cs_kubernetes_cluster_dns_prefix = "test"

###____________Nodes_pool_____________________________
### Name of kubernetes node pool
cs_node_pool_name = "aksdevpool"
### Number of kubernetes node to create
cs_node_pool_node_count = "2"
### Size of VM in Azure
cs_node_pool_vm_size = "Standard_DS1_v2"

###____________Tags_______________________
### Map of tags
cs_aks_tags = {
  Infrastructure = "test"
  Environment    = "Development"
}

###________________StaticIP_______________________________________________
### Name of Static IP
cs_public_ip_name = "test"
