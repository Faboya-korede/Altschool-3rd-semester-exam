#Helm repo to set up monitoring, prometheus, grafana
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


resource "kubernetes_namespace" "ingress" {
   depends_on = [aws_eks_node_group.Eks-node_group]
  metadata {
    name = "ingress"
  }
}

#helm repo to set up nginx-ingress 
resource "helm_release" "nginix-ingress" {
depends_on =  [kubernetes_namespace.ingress, kubectl_manifest.test]
  name        = "nginix-ingress"    
  repository  = "https://kubernetes.github.io/ingress-nginx"    
  chart       = "ingress-nginx"
  namespace   = "ingress"
  version     = "4.5.2"
}

resource "null_resource" "get_nlb_hostname" {
  depends_on = [helm_release.nginix-ingress]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name Alt-eks --region us-east-1 && kubectl get svc nginix-ingress-ingress-nginx-controller  --namespace ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}' > ${path.module}/lb_hostname.txt"
  }
}
