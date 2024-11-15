# data "kubernetes_service" "currency_demo" {
#   metadata {
#     name = kubernetes_manifest.demo_service.manifest.metadata.name
#   }
# }

data "kubernetes_ingress_v1" "currency_demo" {
  metadata {
    name = kubernetes_manifest.demo_ingress.manifest.metadata.name
  }
}

output "ingress_hostname" {
  value = data.kubernetes_ingress_v1.currency_demo.status[0].load_balancer[0].ingress[0].hostname
}