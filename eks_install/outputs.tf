output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.EKS.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.EKS.cluster_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.VPC.vpc_id
}