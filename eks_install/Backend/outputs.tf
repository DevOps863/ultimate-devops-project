output "s3_bucket_name" {
  value = aws_s3_bucket.my-demo-bucket.id
  description = "The name of the bucket"
}

output "Dynamo_db_table" {
  value = aws_dynamodb_table.state-locking.id
  description = "The name of the table"
}