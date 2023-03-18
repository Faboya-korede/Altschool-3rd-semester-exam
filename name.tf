resource "kubernetes_namespace" "monitoring" {
 depends_on = [aws_eks_node_group.Eks-node_group]
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kube-prometheus" {
  depends_on = [kubernetes_namespace.monitoring]
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "45.7.1"
  chart      = "kube-prometheus-stack"
  timeout = 2000
  name = "prometheus"
}

