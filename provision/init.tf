terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "edwin-tf-state"
    key            = "terraform-observability.tfstate"
    dynamodb_table = "edwin-tf-state"
    encrypt        = true
  }
}
