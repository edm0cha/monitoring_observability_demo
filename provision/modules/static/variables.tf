variable "name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "function_url" {
  description = "The URL of the get items lambda function"
  type        = string
}
