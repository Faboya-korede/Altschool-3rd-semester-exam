resource "kubectl_manifest" "test" {
  depends_on = [aws_eks_node_group.Eks-node_group]
  count     = length(data.kubectl_filename_list.manifests.matches)
  yaml_body = file(element(data.kubectl_filename_list.manifests.matches, count.index))
}


