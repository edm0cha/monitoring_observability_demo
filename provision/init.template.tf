terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "your-bucket-tf-state"
    dynamodb_table = "your-table-tf-state"
    key            = "terraform-observability.tfstate"
    encrypt        = true
  }
}
