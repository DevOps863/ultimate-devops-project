resource "aws_iam_role" "cluster_role" {
  name = "${var.cluster_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.cluster_role.name
}

resource "aws_eks_cluster" "my-cluster" {
  name = var.cluster_name
  version = var.cluster_version
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_id
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}

resource "aws_iam_role" "node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node-policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])

  policy_arn = each.value
  role       = aws_iam_role.node_role.name
}

resource "aws_eks_node_group" "eks_cluster_node_group" {
  for_each = var.node_groups
  
  cluster_name = aws_eks_cluster.my-cluster.name
  node_role_arn = aws_iam_role.node_role.arn
  subnet_ids = var.subnet_id
  instance_types = each.value.instance_types
  capacity_type = each.value.capacity_type

  scaling_config {
    max_size = each.value.scaling_config.max_size
    min_size = each.value.scaling_config.min_size
    desired_size = each.value.scaling_config.desired_size
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.node-policy
   ]
}