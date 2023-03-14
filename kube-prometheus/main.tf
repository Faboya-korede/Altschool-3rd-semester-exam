

resource "helm_release" "kube-prometheus" {
 depends_on = [kubernetes_namespace.monitoring]
  name       = "kube-prometheus-stack"
  namespace  = var.namespace
  repository = "https://aws.github.io/eks-charts"
  version    = var.kube-version
  chart      = "kube-prometheus-stack"
}


