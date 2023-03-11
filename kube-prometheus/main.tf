

resource "helm_release" "kube-prometheus" {
 depends_on = [kubernetes_namespace.monitoring]
  name       = "kube-prometheus-stack"
  namespace  = var.namespace
  version    = var.kube-version
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
}


