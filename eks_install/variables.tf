variable "cidr_block" {
  description = "CIDR for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type = string
  default = "my-eks-cluster"
}

variable "private_subnet_cidr" {
  description = "CIDRs for private subnet"
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}

variable "public_subnet_cidr" {
  description = "CIDRs for public subnet"
  type = list(string)
  default = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
}

variable "availability_zones" {
  description = "Availability Zones"
  type = list(string)
  default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}