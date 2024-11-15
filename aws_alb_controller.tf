
locals {
  lb_controller = {
    sa_name   = "aws-lb-controller-sa"
    namespace = "kube-system"
  }
}

module "aws_lb_controller_irsa" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "5.48.0"
  role_name                              = "aws_lb_controller_irsa"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = local.eks_oidc_provider_arn
      namespace_service_accounts = ["${local.lb_controller.namespace}:${local.lb_controller.sa_name}"]
    }
  }
}

resource "kubernetes_service_account" "aws_lb_controller" {
  metadata {
    name      = local.lb_controller.sa_name
    namespace = local.lb_controller.namespace

    annotations = {
      "eks.amazonaws.com/role-arn"               = module.aws_lb_controller_irsa.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "alb_ingress_controller" {
  name       = "aws-lb-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"

  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }
  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }
  set {
    name  = "clusterName"
    value = local.eks_cluster_name
  }
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws_lb_controller.metadata[0].name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
}