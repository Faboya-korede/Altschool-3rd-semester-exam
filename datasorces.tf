
data "aws_eks_cluster" "Alt-eks" {

  depends_on = [aws_eks_cluster.Alt-eks]

  name = "Alt-eks"
}

data "aws_eks_cluster_auth" "Alt-eks" {

  depends_on = [aws_eks_cluster.Alt-eks]
  name = "Alt-eks"
}

data "kubectl_filename_list" "manifests" {
  pattern = "./*.yaml"
}

data "local_file" "lb_hostname" {
  filename = "${path.module}/lb_hostname.txt"
  
  depends_on = [null_resource.get_nlb_hostname]
}

data "aws_route53_zone" "example" {
  depends_on = [aws_route53_zone.korede]
  name = "korede.me"
}

