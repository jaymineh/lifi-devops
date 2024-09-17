# Create s3 bucket
resource "aws_s3_bucket" "lifinance-bucket-aws" {
  bucket = "lifinance-bucket"
  force_destroy = true
}

# Enable versioning on s3 bucket
resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.lifinance-bucket-aws.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption for s3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "first" {
  bucket = aws_s3_bucket.lifinance-bucket-aws.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Create dynamo DB for terraform locks
resource "aws_dynamodb_table" "lifinance_locks_aws" {
  name         = "lifinance-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}