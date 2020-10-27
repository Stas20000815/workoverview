output "client_certificate" {
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  description = "The client certificate of created kubernetes cluster"
}

output "aks_cluster_host" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}

output "kube_config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  description = "The kube config of created kubernetes cluster"
}

output "public_ip_address" {
  value       = azurerm_public_ip.staticIP.ip_address
  description = "The Public IP address which will be Kubernetes IP for Ingress "
}
