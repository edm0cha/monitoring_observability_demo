resource "aws_dynamodb_table" "this" {
  name                        = var.name
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = false

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
