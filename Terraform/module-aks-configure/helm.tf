provider "helm" {
  kubernetes {
    config_path = "${path.root}/kube_config"
  }
}

provider "azurerm" {
  version = ">= 2.0"
  features {
  }
}

resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "stable"
  chart      = "kubernetes-dashboard"
  namespace  = "kubernetes-dashboard"
  depends_on = [kubernetes_namespace.base_namespaces]
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "stable"
  chart      = "nginx-ingress"
  namespace  = "nginx-ingress"
  depends_on = [kubernetes_namespace.base_namespaces]
  values = [
    file("${path.module}/values/nginx-ingress.yml")
  ]
  set {
    name  = "controller.service.loadBalancerIP"
    value = var.cs_ingress_ip_address
  }
}

resource "null_resource" "run_kubectl_apply" {
  count = var.cs_cert_manager_enable ? 1 : 0
  provisioner "local-exec" {
    command = <<LOCAL_EXEC
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.1/cert-manager-legacy.crds.yaml
LOCAL_EXEC
  }
}

resource "helm_release" "cert_manager" {
  count      = var.cs_cert_manager_enable ? 1 : 0
  name       = "cert-manager"
  repository = "jetstack"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  depends_on = [kubernetes_namespace.base_namespaces, null_resource.run_kubectl_apply]
  values = [
    file("${path.module}/values/cert-manager.yml")
  ]
}

data "azurerm_subscription" "primary" {
}
variable "module_depends_on" {
  default = [""]
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

resource "helm_release" "clusterissuer" {
  count      = var.cs_cert_manager_enable ? 1 : 0
  name       = "clusterissuer"
  chart      = "${path.module}/charts/clusterissuer"
  namespace  = "cert-manager"
  depends_on = [kubernetes_namespace.base_namespaces, helm_release.cert_manager, null_resource.run_kubectl_apply, null_resource.module_depends_on]

  set {
    name  = "azure.subscription_id"
    value = data.azurerm_subscription.primary.subscription_id
  }

  set {
    name  = "azure.tenant_id"
    value = data.azurerm_subscription.primary.tenant_id
  }

  set {
    name  = "azuredns.sp_app_id"
    value = var.cs_azure_dns_sp_app_id
  }

  set {
    name  = "azuredns.dns_token_name"
    value = kubernetes_secret.dns_token[count.index].metadata[count.index].name
  }

  set {
    name  = "azuredns.dns_zone_rg"
    value = var.cs_azure_dns_zone_rg
  }

  set {
    name  = "azuredns.dns_zone"
    value = var.cs_azure_dns_zone
  }
}
