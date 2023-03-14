
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