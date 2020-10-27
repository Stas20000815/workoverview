#TODO протетстить увеличение нод и не смену айпишника
provider "kubernetes" {
  config_path = "${path.root}/kube_config"
}

resource "kubernetes_namespace" "base_namespaces" {
  for_each = var.cs_namespace_name
  metadata {
    name = each.value
  }
}

resource "kubernetes_secret" "dns_token" {
  count = var.cs_cert_manager_enable ? 1 : 0
  metadata {
    name      = "dns-token"
    namespace = "cert-manager"
  }
  data       = var.cs_dns_token
  depends_on = [kubernetes_namespace.base_namespaces]
}
