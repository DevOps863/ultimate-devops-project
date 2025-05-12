variable "cidr_block" {
  description = "CIDR for the VPC"
  type = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type = string
}

variable "private_subnet_cidr" {
  description = "CIDRs for private subnet"
  type = list(string)
}

variable "public_subnet_cidr" {
  description = "CIDRs for public subnet"
  type = list(string)
}

variable "availability_zones" {
  description = "Availability Zones"
  type = list(string)
}