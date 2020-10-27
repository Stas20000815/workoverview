provider "azurerm" {
  version = ">= 2.0"
  features {
  }
}
provider "azuread" {
  version = "~>0.3"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.cs_resource_group_name
  location = var.cs_resource_group_location
  tags     = var.cs_rg_tags
}

resource "azurerm_management_lock" "rgLock" {
  name       = "Protection"
  scope      = azurerm_resource_group.rg.id
  lock_level = "CanNotDelete"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azuread_application" "akssp" {
  provider = azuread
  name     = var.cs_azuread_application_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "azuread_service_principal" "akssp" {
  application_id = azuread_application.akssp.application_id

  lifecycle {
    prevent_destroy = true
  }
}
resource "azuread_service_principal_password" "akssp" {
  service_principal_id = azuread_service_principal.akssp.id
  value                = var.cs_azuread_service_principal_password
  end_date             = var.cs_azuread_service_principal_end_date

  lifecycle {
    prevent_destroy = true
  }
}

# Create kubernetes cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cs_kubernetes_cluster_name
  location            = var.cs_resource_group_location
  resource_group_name = var.cs_resource_group_name
  dns_prefix          = var.cs_kubernetes_cluster_dns_prefix

  service_principal {
    client_id     = azuread_service_principal.akssp.application_id
    client_secret = azuread_service_principal_password.akssp.value
  }

  default_node_pool {
    name       = var.cs_node_pool_name
    node_count = var.cs_node_pool_node_count
    vm_size    = var.cs_node_pool_vm_size
  }
  tags = var.cs_aks_tags
}

resource "azurerm_management_lock" "akslock" {
  name       = "NeverdeleteKubernetes"
  scope      = azurerm_kubernetes_cluster.aks.id
  lock_level = "CanNotDelete"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_public_ip" "staticIP" {
  name                = var.cs_public_ip_name
  location            = var.cs_resource_group_location
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  allocation_method   = "Static"
  depends_on          = [azurerm_kubernetes_cluster.aks]
}

resource "azurerm_management_lock" "staticIP" {
  name       = "NeverdeleteIPforKubernetes"
  scope      = azurerm_public_ip.staticIP.id
  lock_level = "CanNotDelete"

  lifecycle {
    prevent_destroy = true
  }
}

resource "local_file" "kubeConfig" {
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = "${path.root}/kube_config"

  lifecycle {
    prevent_destroy = true
  }
}
