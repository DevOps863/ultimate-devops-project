provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my-demo-bucket" {
  bucket = "demo-terraform-s3-ram-state-bucket"

  lifecycle {
    prevent_destroy =  "false"
  }
}

resource "aws_s3_bucket_versioning" "my-demo-bucket" {
  bucket = aws_s3_bucket.my-demo-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "state-locking" {
  name = "ram-terraform-eks-state-locking"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

