resource "kubernetes_namespace" "ingress" {
   depends_on = [aws_eks_node_group.Eks-node_group]
  metadata {
    name = "ingress"
  }
}

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
