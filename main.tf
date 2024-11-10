resource "kubernetes_manifest" "demo_deployment" {
    manifest = provider::kubernetes::manifest_decode( file( "currency-demo-deployment.yaml" ) )
    
    wait {
        fields = {
            "status.readyReplicas" = 3
        }
    }
}