# Push state file to cloud
terraform {
  backend "s3" {
    bucket         = "lifinance-bucket"
    key            = "lifinance/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "lifinance-locks"
    encrypt        = true
  }
}