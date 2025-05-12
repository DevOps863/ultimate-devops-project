output "vpc_id" {
  description = "VPC-ID"
  value = aws_vpc.my_vpc.id
}

output "private-subnet" {
  description = "private-subnets"
  value = aws_subnet.private[*].id
}

output "public-subnet" {
  description = "public-subnets"
  value = aws_subnet.public[*].id
}