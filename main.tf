resource "kubernetes_manifest" "demo_deployment" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/currency-demo-deployment.yaml"))

  wait {
    fields = {
      "status.readyReplicas" = 3
    }
  }
}

resource "kubernetes_manifest" "demo_service" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/currency-demo-service.yaml"))
}

resource "kubernetes_manifest" "demo_ingress" {
  manifest = provider::kubernetes::manifest_decode(file("${path.module}/currency-demo-ingress.yaml"))

  depends_on = [helm_release.alb_ingress_controller]
}