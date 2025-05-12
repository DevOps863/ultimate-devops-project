terraform {
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "demo-terraform-s3-ram-state-bucket"
    key = "terraform-state-backup"
    region = "us-east-1"
    dynamodb_table = "ram-terraform-eks-state-locking"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "VPC" {
  source = "./Modules/VPC"
  cidr_block = var.cidr_block
  cluster_name = var.cluster_name
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zones = var.availability_zones
}