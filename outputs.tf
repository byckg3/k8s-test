data "kubernetes_service" "currency_demo" {
  metadata {
    name = kubernetes_manifest.demo_service.manifest.metadata.name
  }
}

output "service_hostname" {
  value = data.kubernetes_service.currency_demo.status[0].load_balancer[0].ingress[0].hostname
}