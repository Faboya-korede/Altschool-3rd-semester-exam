output "cluster_id" {
    value = aws_eks_cluster.Alt-eks.cluster_id
}

output "cluster_endpoint" {
    value = aws_eks_cluster.Alt-eks.endpoint
}


output "hosted_zone_id" {
  value = data.aws_route53_zone.example.id
}
