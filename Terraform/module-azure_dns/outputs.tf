output "sp_app_id" {
  value = azuread_application.dnssp.*.application_id
}

output "sp_dnssp_id" {
  value = azuread_service_principal.dnssp.*.id
}

output "dns_name" {
  value = azurerm_dns_zone.dns.*.name
}

output "dns_rg" {
  value = azurerm_dns_zone.dns.*.resource_group_name
}
