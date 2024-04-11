variable "name" {
  description = "The name of the CloudWatch Dashboard"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "function_name" {
  description = "The Name of the Lambda function"
  type        = string
}

variable "dynamodb_table_name" {
  description = "The Name of the DynamoDB table"
  type        = string
}
