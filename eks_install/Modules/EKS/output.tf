output "cluster_name" {
  value = aws_eks_cluster.my-cluster.arn
}

output "cluster_endpoint" {
  description = "cluster endpoint"
  value = aws_eks_cluster.my-cluster.endpoint
}