provider "azurerm" {
  version = ">= 2.0"
  features {
  }
}
provider "azuread" {
  version = "~>0.3"
}

resource "azurerm_dns_zone" "dns" {
  count               = var.cs_azure_dns_enable ? 1 : 0
  name                = var.cs_dns_name
  resource_group_name = var.cs_dns_resource_group_name
}

resource "azurerm_dns_a_record" "template_record" {
  count               = var.cs_azure_dns_enable ? 1 : 0
  name                = "*"
  zone_name           = azurerm_dns_zone.dns[count.index].name
  resource_group_name = azurerm_dns_zone.dns[count.index].resource_group_name
  ttl                 = 3600
  records             = [var.cs_ingress_ip_address]
}

resource "azurerm_dns_a_record" "selenium_record" {
  count               = var.cs_azure_dns_enable ? 1 : 0
  name                = "selenium"
  zone_name           = azurerm_dns_zone.dns[count.index].name
  resource_group_name = azurerm_dns_zone.dns[count.index].resource_group_name
  ttl                 = 3600
  records             = ["13.95.236.240"]
}

resource "azuread_application" "dnssp" {
  provider = azuread
  count    = var.cs_azure_dns_enable ? 1 : 0
  name     = var.cs_dns_azuread_application_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "azuread_application_password" "dnsapppasswd" {
  count                 = var.cs_azure_dns_enable ? 1 : 0
  provider              = azuread
  application_object_id = azuread_application.dnssp[count.index].id
  value                 = var.cs_dns_azuread_service_principal_password
  end_date              = var.cs_dns_azuread_service_principal_end_date
}

resource "azuread_service_principal" "dnssp" {
  count          = var.cs_azure_dns_enable ? 1 : 0
  application_id = azuread_application.dnssp[count.index].application_id

  lifecycle {
    prevent_destroy = true
  }
}
resource "azuread_service_principal_password" "dnssp" {
  count                = var.cs_azure_dns_enable ? 1 : 0
  service_principal_id = azuread_service_principal.dnssp[count.index].object_id
  value                = var.cs_dns_azuread_service_principal_password
  end_date             = var.cs_dns_azuread_service_principal_end_date

  lifecycle {
    prevent_destroy = true
  }
}

data "azurerm_subscription" "primary" {
}

resource "azurerm_role_assignment" "dns_role" {
  count                = var.cs_azure_dns_enable ? 1 : 0
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azuread_service_principal.dnssp[count.index].id
}
