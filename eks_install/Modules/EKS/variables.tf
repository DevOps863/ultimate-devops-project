variable "cluster_name" {
  description = "Cluster-name"
  type = string
}

variable "cluster_version" {
  description = "cluster version"
  type = string
}

variable "subnet_id" {
  description = "subnets for eks cluster"
  type = list(string)
}

variable "node_groups" {
  description = "EKS node group configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type = string
    scaling_config = object({
      desired_size = number
      max_size = number
      min_size = number
    })
  }))
}